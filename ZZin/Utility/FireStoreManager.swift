import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct User : Codable {
    var profileImg: String?
    var uid: String
    var nickname: String
    var phoneNum: String
    var rid: [String]? // [UUID.uuidString]
    var pid: [String]? // [UUID.uuidString]
    var password: String?
    
    enum CodingKeys: String, CodingKey {
        case profileImg
        case uid
        case nickname
        case phoneNum
        case rid
        case pid
        case password
    }
}

struct Review : Codable {
    var rid: String
    var uid: String
    var pid: String // UUID.uuidString
    var reviewImg: [String]?
    var title: String
    var like: Int
    var dislike: Int
    var content: String
    var rate: Double
    var createdAt: Date
    var companion: String // 추후 enum case로 정리 필요
    var condition: String // 추후 enum case로 정리 필요
    var kindOfFood: String // 추후 enum case로 정리 필요
    
    enum CodingKeys: String, CodingKey {
        case rid
        case uid
        case pid
        case reviewImg
        case title
        case like
        case dislike
        case content
        case rate
        case createdAt
        case companion
        case condition
        case kindOfFood
    }
}

struct Place : Codable {
    var pid: String
    var rid: [String] // [UUID.uuidString]
    var placeName: String
    var placeImg: [String]
    var placeTelNum: String
    var city: String
    var town: String
    var address: String
    var lat: Double?
    var long: Double?
    var companion: String
    var condition: String
    var kindOfFood: String
    
    enum CodingKeys: String, CodingKey {
        case pid
        case rid
        case placeName
        case placeImg
        case placeTelNum
        case city
        case town
        case address
        case lat
        case long
        case companion
        case condition
        case kindOfFood
    }
}

class FireStoreManager {
    
    let db = Firestore.firestore()
    static let shared = FireStoreManager()
    
    func fetchDocument<T: Decodable>(from collection: String, documentId: String, completion: @escaping (Result<T, Error>) -> Void) {
        let docRef = db.collection(collection).document(documentId)
        docRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let document = document, document.exists, var data = document.data() else {
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: ["description": "No document or data"])))
                return
            }
            
            // FIRTimestamp를 Date로 변환하고, Date를 문자열로 변환
            if let timestamp = data["createdAt"] as? Timestamp {
                let date = timestamp.dateValue()
                let formatter = ISO8601DateFormatter()
                let dateString = formatter.string(from: date)
                data["createdAt"] = dateString
            }
            
            let dataAsJSON = try! JSONSerialization.data(withJSONObject: data, options: [])
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let obj = try decoder.decode(T.self, from: dataAsJSON)
                completion(.success(obj))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }
    }
    
    func fetchDataWithUid(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        fetchDocument(from: "users", documentId: uid, completion: completion)
    }
    
    func fetchDataWithPid(pid: String, completion: @escaping (Result<Place, Error>) -> Void) {
        fetchDocument(from: "places", documentId: pid, completion: completion)
    }
    
    func fetchDataWithRid(rid: String, completion: @escaping (Result<Review, Error>) -> Void) {
        fetchDocument(from: "reviews", documentId: rid, completion: completion)
    }
    
    // 별도의 함수로 데이터 변환 로직을 분리
    func convertFirestoreData(data: [String: Any], objectType: Decodable.Type) -> Result<Decodable, Error> {
        var mutableData = data
        
        if let timestamp = mutableData["createdAt"] as? Timestamp {
            let date = timestamp.dateValue()
            let formatter = ISO8601DateFormatter()
            let dateString = formatter.string(from: date)
            mutableData["createdAt"] = dateString
        }
        
        let dataAsJSON = try! JSONSerialization.data(withJSONObject: mutableData, options: [])
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let obj = try decoder.decode(objectType, from: dataAsJSON)
            return .success(obj)
        } catch let decodeError {
            return .failure(decodeError)
        }
    }
    
    
    
    func fetchCollectionData<T: Decodable>(from collection: String, objectType: T.Type, completion: @escaping (Result<[T], Error>) -> Void) {
        db.collection(collection).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var objects: [T] = []
            
            for document in querySnapshot!.documents {
                let data = document.data()
                switch self.convertFirestoreData(data: data, objectType: objectType) {
                case .success(let obj):
                    if let objT = obj as? T {
                        objects.append(objT)
                    }
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
            completion(.success(objects))
        }
    }
    
    
    func getReviewData(completion: @escaping (Result<[Review], Error>) -> Void) {
        fetchCollectionData(from: "reviews", objectType: Review.self, completion: completion)
    }
    
    func getPlaceData(completion: @escaping (Result<[Place], Error>) -> Void) {
        fetchCollectionData(from: "places", objectType: Place.self, completion: completion)
    }
    
    // 전체 데이터 저장 및 업데이트
    func setData(uid: String, dataWillSet: [String: Any?]){
        // 1. rid 생성
        let rid = UUID().uuidString
        
        // 2. rid를 이용해서 firebase Storage에 업로드
        let imgData = dataWillSet["imgData"] as! [Data] // nil 처리를 어떻게 해야할지 모르겠음
        uploadImagesToFirebase(imagesData: imgData, rid: rid) // 업로드 method
        
        // 3. pid 생성
        let pid = UUID().uuidString
        
        // 4. reviewData 생성
        var reviewDictionary: [String: Any] = ["rid": rid,
                                               "uid": uid,
                                               "pid": pid,
                                               "reviewImg": [],
                                               "title": dataWillSet["title"] as? String ?? "나의 리뷰",
                                               "like": 0,
                                               "dislike": 0,
                                               "content": dataWillSet["content"] as? String ?? "내용 없음",
                                               "rate": 100, // 추후 계산하는 알고리즘 추가
                                               "createdAt": Timestamp(date: Date()),
                                               "companion": dataWillSet["companion"] as? String ?? "nil",
                                               "condition": dataWillSet["condition"] as? String ?? "nil",
                                               "kindOfFood": dataWillSet["kindOfFood"] as? String ?? "nil"]
        
        var reviewImg: [String] = []
        for (index, _) in imgData.enumerated() {
            reviewImg.append("reviews/\(rid)-\(index + 1).jpeg")
        }
        
        reviewDictionary.updateValue(reviewImg, forKey: "reviewImg")
        
        // 5. reviewData 저장
        setReviewData(reviewDictionary: reviewDictionary)
        
        // 6. uid를 이용해서 rid 배열과 pid 배열 업데이트
        updateUserRidAndPid(pid: pid, rid: rid, uid: uid)
        
        // 7. place데이터 저장
        let path = reviewImg ?? []
        setPlaceData(dataWillSet: dataWillSet, pid: pid, uid: uid, rid: rid, path: path)
    }

    func uploadImagesToFirebase(imagesData: [Data?], rid: String) {
        print("uploadImagesToFirebase")
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let group = DispatchGroup()

        for (index, imgData) in imagesData.enumerated() {
            if let data = imgData {
                group.enter()
                let imageName = "\(rid)-\(index + 1)" // 이미지 이름에 순서대로 -1, -2 붙임
                let storagePath = "reviews/\(imageName).jpeg"
                let imagesRef = storageRef.child(storagePath)
                
                imagesRef.putData(data, metadata: nil) { (metadata, error) in
                    guard let _ = metadata else {
                        print("Uh-oh, an error occurred for image \(imageName)!")
                        group.leave()
                        return
                    }

                }
            }
        }
    }

    
    func setReviewData(reviewDictionary: [String: Any]){
        // FireStoreManager 안으로 옮기고 난 후에 수정
        let db = FireStoreManager.shared.db
        let reviewRef = db.collection("reviews").document(reviewDictionary["rid"] as! String)
        
        reviewRef.setData(reviewDictionary){ err in
            if let err = err {
                print("setReviewData: Error writing document: \(err)")
            } else {
                print("setReviewData: Document successfully written!")
            }
        }
    }

    func updateUserRidAndPid(pid: String?, rid: String, uid: String){
        let userRef = db.collection("users").document(uid)
        
        userRef.updateData(["rid": FieldValue.arrayUnion([rid]),
                            "pid": FieldValue.arrayUnion([pid] as? [String] ?? [])]){ err in
            if let err = err {
                print("updateUserAppendingRid: Error adding document: \(err)")
            } else {
                print("updateUserAppendingRid: Document added with ID: \(userRef.documentID)")
            }
        }
    }
    
    func setPlaceData(dataWillSet: [String: Any?], pid: String, uid: String, rid: String, path: [String]) {
        let placeRef = db.collection("places").document(pid)
        placeRef.setData(["pid": pid,
                          "uid": uid,
                          "rid": FieldValue.arrayUnion([rid]),
                          "placeImg": FieldValue.arrayUnion(path),
                          "city": "인천광역시",
                          "town": "부평구",
                          "address": dataWillSet["address"] as! String,
                          "placeName": dataWillSet["placeName"] as! String,
                          "placeTelNum": dataWillSet["placeTelNum"] as! String,
                          "lat": dataWillSet["lat"] as! Double,
                          "long": dataWillSet["long"] as! Double,
                          "companion": dataWillSet["companion"] as! String,
                          "condition": dataWillSet["condition"] as! String,
                          "kindOfFood": dataWillSet["kindOfFood"] as! String]){ err in
            if let err = err {
                print("setPlaceData: Error writing document: \(err)")
            } else {
                print("setPlaceData: Document successfully written!")
            }
        }
        
    }
    
    /**
     @brief placeData를 불러온다 >> 주연님 코드에서 현재 적용중인 상황
     */
    func getPlaceData(completion: @escaping ([Place]?) -> Void) {
        var placeData: [[String:Any]] = [[:]]
        var place: [Place]?
        
        db.collection("places").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(place) // 호출하는 쪽에 빈 배열 전달
                return
            }
            
            for document in querySnapshot!.documents {
                placeData.append(document.data())
            }
            placeData.remove(at: 0)
            place = self.dictionaryToObject(objectType: Place.self, dictionary: placeData)
            completion(place) // 성공 시 배열 전달
        }
    }
    
    func createQuery(companion: String?, condition: String?, kindOfFood: String?, city: String?, town: String?) -> Query {
        let placesReference = FireStoreManager.shared.db.collection("places")
        var query: Query = placesReference
        
        if let companionValue = companion, !companionValue.isEmpty {
            query = query.whereField("companion", isEqualTo: companionValue)
        }
        if let conditionValue = condition, !conditionValue.isEmpty {
            query = query.whereField("condition", isEqualTo: conditionValue)
        }
        if let kindOfFoodValue = kindOfFood, !kindOfFoodValue.isEmpty {
            query = query.whereField("kindOfFood", isEqualTo: kindOfFoodValue)
        }
        if let cityValue = city, !cityValue.isEmpty {
            query = query.whereField("city", isEqualTo: cityValue)
        }
        if let townValue = town, townValue != "전체" {
            query = query.whereField("town", isEqualTo: townValue)
        }

        return query
    }

    func fetchPlacesWithQuery(query: Query, completion: @escaping (Result<[Place], Error>) -> Void) {
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: ["description": "No documents found"])))
                return
            }

            var allData: [[String:Any]] = []
            for document in documents {
                let data = document.data()
                allData.append(data)
            }

            if let places = self.dictionaryToObject(objectType: Place.self, dictionary: allData) {
                completion(.success(places))
            } else {
                completion(.failure(NSError(domain: "DecodingError", code: -2, userInfo: ["description": "Error decoding data"])))
            }
        }
    }
    
    func fetchPlacesWithKeywords(companion: String?, condition: String?, kindOfFood: String?, city: String?, town: String?, completion: @escaping (Result<[Place], Error>) -> Void) {
        let query = createQuery(companion: companion, condition: condition, kindOfFood: kindOfFood, city: city, town: town)
        fetchPlacesWithQuery(query: query, completion: completion)
    }
          
    //MARK: - 로그인/회원가입 Page
    func testFetchId(completion: @escaping ([String: Any]) -> Void) {
        var uids: [String: Any] = [:]
        db.collection("users").getDocuments { result, error in
            if let error = error {
                print("오류가 발생했습니다.")
            } else {
                for document in result!.documents {
                    let newData = document.documentID
                    let totalData = document.data()
                    uids[newData] = totalData
                }
                completion(uids)
            }
        }
    }

    
    func fetchUserUID(completion: @escaping ([String]) -> Void) {
        var uids: [String] = []
        db.collection("users").getDocuments { result, error in
            if let error = error {
                print("오류가 발생했습니다.")
            } else {
                for document in result!.documents {
                    if document.exists {
                        if let uid = document.get("uid") as? String {
                            print(uid)
                            uids.append(uid)
                        }
                    }
                }
                completion(uids)
            }
        }
    }
    
    //MARK: - 유효성 검사 관련
    // 중복 UID 확인
//    func crossCheckDB(_ id: String, completion: @escaping (Bool) -> Void) {
//        fetchUserUID { uids in
//            print("전체 데이터는 아래와 같습니다 === \(uids)")
//            if uids.contains(id) {
//                print("아이디가 데이터베이스에 이미 있습니다.")
//                print(id)
//                completion(true)
//            } else {
//                print("아이디가 데이터베이스에 없습니다.")
//                print(id)
//                completion(false)
//            }
//        }
//    }
    
    //MARK: - Auth 관련
    // 로그인
    func loginUser(with email: String, password: String, completion: @escaping ((Bool) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("이메일이 틀렸습니다. \(error.localizedDescription)")
                completion(false)
                return
            }
            print("이메일이 올바릅니다. 로그인이 됐습니다. \(result?.description)")
            print("유저는 \(result?.user) 입니다.")
            completion(true)
            return
        }
    }
    
    // 회원가입
    func signInUser(with email: String, password: String, completion: @escaping ((Bool) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("여기가 문제인가요 유저를 생성하는데 에러가 발생했습니다. \(error.localizedDescription)")
                completion(false)
            }
            print("결과값은 아래와 같습니다 - \(result?.description)")
            completion(true)
        }
    }
}

extension FireStoreManager {
    func dictionaryToObject<T:Decodable>(objectType:T.Type, dictionary:[[String:Any]]) -> [T]? {
        do {
            let dictionaries = try JSONSerialization.data(withJSONObject: dictionary)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let objects = try decoder.decode([T].self, from: dictionaries)
            return objects
            
        } catch let serializationError as NSError where serializationError.domain == NSCocoaErrorDomain {
            print("JSON Serialization Error: \(serializationError.localizedDescription)")
        } catch let decodingError as DecodingError {
            print("Decoding Error: \(decodingError)")
        } catch {
            print("Unexpected error: \(error)")
        }
        return nil
    }
    
    func dicToObject<T:Decodable>(objectType:T.Type,dictionary:[String:Any]) -> T? {
        
        guard let dictionaries = try? JSONSerialization.data(withJSONObject: dictionary) else { return nil }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let objects = try? decoder.decode(T.self, from: dictionaries) else { return nil }
        return objects
        
    }
    
    
}
