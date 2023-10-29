//
//  FireStoreManager.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/23.
//

import Foundation
import Firebase
import FirebaseAuth

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
    var rid: String // UUID.uuidString
    var uid: String
    var pid: String // UUID.uuidString
    var reviewImg: String?
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
    var pid: String // UUID.uuidString
    var rid: [String] // [UUID.uuidString]
    var placeName: String
    var placeImg: [String]
    var placeTelNum: String
    var city: String
    var town: String
    var address: String
    var lat: Double?
    var long: Double?
    
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

       func fetchDataWithPid(pid: String, completion: @escaping (Result<Place, Error>) -> Void) {
           fetchDocument(from: "places", documentId: pid, completion: completion)
       }
       
       func fetchDataWithRid(rid: String, completion: @escaping (Result<Review, Error>) -> Void) {
           fetchDocument(from: "reviews", documentId: rid, completion: completion)
       }
    
    func setUserData(_ UserInfo: User) {
        let userRef = db.collection("users").document(UserInfo.uid)
        
        userRef.setData([
            "profileImg": (UserInfo.profileImg ?? "basic_profile") as String,
            "uid": UserInfo.uid,
            "nickname": UserInfo.nickname,
            "phoneNum": UserInfo.phoneNum,
            "rid": UserInfo.rid,
            "pid": UserInfo.pid
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(userRef.documentID)")
            }
        }
    }
    
    func updateUserData(_ UserInfo: User) {
        let userRef = db.collection("users").document(UserInfo.uid)
        
        userRef.updateData([
            "profileImg": (UserInfo.profileImg ?? "https://i.ibb.co/QMVpNXC/todo-main-img.png") as String,
            "uid": UserInfo.uid,
            "nickname": UserInfo.nickname,
            "phoneNum": UserInfo.phoneNum,
            "rid": FieldValue.arrayUnion(UserInfo.rid ?? []),
            "pid": FieldValue.arrayUnion(UserInfo.pid ?? [])
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(userRef.documentID)")
            }
        }
    }
    
    func setReview(_ ReviewInfo: Review) {
        let reviewRef = db.collection("reviews").document(ReviewInfo.rid)
        
        reviewRef.setData([
            "rid": ReviewInfo.rid,
            "uid": ReviewInfo.uid,
            "pid": ReviewInfo.pid,
            "reviewImg": ReviewInfo.reviewImg,
            "title": ReviewInfo.title,
            "like": ReviewInfo.like,
            "dislike": ReviewInfo.dislike,
            "content": ReviewInfo.content,
            "rate": ReviewInfo.rate,
            "companion": ReviewInfo.companion,
            "condition": ReviewInfo.condition,
            "kindOfFood": ReviewInfo.kindOfFood
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(reviewRef.documentID)")
            }
        }
        
    }
    
    func setPlace(_ PlaceInfo: Place) {
        let placeRef = db.collection("places").document(PlaceInfo.pid)
        
        placeRef.setData([
            "pid": PlaceInfo.pid,
            "rid": FieldValue.arrayUnion(PlaceInfo.rid),
            "placeName": PlaceInfo.placeName,
            "placeImg": PlaceInfo.placeImg,
            "placeTelNum": PlaceInfo.placeTelNum,
            "city": PlaceInfo.city,
            "town": PlaceInfo.town,
            "address": PlaceInfo.address,
            "lat": PlaceInfo.lat,
            "long": PlaceInfo.long
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(placeRef.documentID)")
            }
        }
    }
    //---------------------------------------
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

    
    func getReviewDatas(completion: @escaping (Result<[Review], Error>) -> Void) {
        fetchCollectionData(from: "reviews", objectType: Review.self, completion: completion)
    }

    /**
     @brief userData를 불러온다,
     */
    func getUserData(completion: @escaping ([User]?) -> Void) {
        var userData: [[String:Any]] = [[:]]
        var user: [User]?
        
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(user) // 호출하는 쪽에 빈 배열 전달
                return
            }
            
            for document in querySnapshot!.documents {
                userData.append(document.data())
            }
            userData.remove(at: 0)
            user = self.dictionaryToObject(objectType: User.self, dictionary: userData)
            completion(user) // 성공 시 배열 전달
        }
    }
    
    /**
     @brief reviewData를 불러온다,
     */
    func getReviewData(completion: @escaping ([Review]?) -> Void) {
        var reviewData: [[String:Any]] = [[:]]
        var review: [Review]?
        
        db.collection("reviews").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(review) // 호출하는 쪽에 빈 배열 전달
                return
            }
            
            for document in querySnapshot!.documents {
                reviewData.append(document.data())
            }
            reviewData.remove(at: 0)
            review = self.dictionaryToObject(objectType: Review.self, dictionary: reviewData)
            completion(review) // 성공 시 배열 전달
        }
    }
    
    /**
     @brief placeData를 불러온다,
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
            print(place?.count)
            completion(place) // 성공 시 배열 전달
        }
    }
    
    /// regex 활용 번호 탐색 함수
    /// - Parameter number: 텍스트필드 내 입력된 값으로 대한민국 전화번호 구조인지 확인
//    private func validateNumber(_ number: String) -> String {
//        let regex = "^[0-9]{3}-[0-9]{4}-[0-9]{4}"
//        let test = NSPredicate(format: "SELF MATCHES %@", arguments: regex)
//        if test.evaluate(withObject: number) {
//            print("숫자가 올바르게 입력됐습니다.")
//        } else {
//            print("숫자 형식이 조금 틀립니다.")
//        }
//    func validateEmail(_ email: String) -> Bool {
//        // 이메일 형식이 맞는지 확인
//        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailpred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return emailpred.evaluate(with: email)
//    }
    
    // 중복 버튼으로 임시 배치, textfield에서 자동으로 확인할 수 있도록 처리
    func validateNumber(_ number: String) -> Bool {
        // 🚨 네트워크 서버에서 존재하는 번호인지 체크할 수 있나?
        // 가드문으로 확인하는 것보다 if문으로 차례대로 거르는 구조가 해당 영역에 알맞는 errorHandling을 할 수 있기에.
        if number.isEmpty {
            print("번호가 입력이 되지 않았어요")
            return false
        } else if Int(number) == nil {
            print("번호 형식을 맞춰주세요")
            return false
        } else if number.count != 11 {
            print("번호가 짧아요")
            return false
        }
        return true
    }
    
    func validatePassword(_ password: String) -> Bool {
        let passwordCheck = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordCheck)
        return predicate.evaluate(with: password)
    }
    
    func validateData(id: UITextField, pw: UITextField) -> String? {
        if id.text?.isEmpty == true || pw.text?.isEmpty == true {
            /// alert 처리 필요
            return "비어있는 값이 있는지 확인해주세요."
        }
        return nil
    }
    
    // 우리가 값을 텍스트 필드로 받고 있는 상황에서 user값으로 로그인과 회원가입을 처리 할 수 있나? -> 불가능
    func loginUser(with email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("로그인하는데 에러가 발생했습니다.")
            }
        }
    }
    
    func signIn(with email: String, password: String) {
        if validatePassword(password) { print("비밀번호를 한번 더 확인 해주세요") }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("여기가 문제인가요 유저를 생성하는데 에러가 발생했습니다. \(error.localizedDescription)")
            }
            print("결과값은 아래와 같습니다 - \(result?.description)")
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
