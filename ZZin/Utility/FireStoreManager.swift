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
//    var createdAt: Date
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
//        case createdAt
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
            guard let document = document, document.exists, let data = document.data() else {
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: ["description": "No document or data"])))
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let obj = try JSONDecoder().decode(T.self, from: jsonData)
                completion(.success(obj))
            } catch let serializationError {
                completion(.failure(serializationError))
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
    
    //MARK: - 로그인/회원가입 Page
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
    func crossCheckDB(_ id: String, completion: @escaping (Bool) -> Void) {
        fetchUserUID { uids in
            if uids.contains(id) {
                print("아이디가 데이터베이스에 이미 있습니다.")
                completion(true)
            } else {
                print("아이디가 데이터베이스에 없습니다.")
                completion(false)
            }
        }
    }
    
    func checkIdPattern(_ email: String) -> Bool {
        return true
    }
    
    func checkPasswordPattern(_ password: String) -> Bool {
        guard !password.isEmpty else { return false }
        
        let firstLetter = password.prefix(1)
        guard firstLetter == firstLetter.uppercased() else { print("첫 단어는 대문자가 필요합니다."); return false }
        
        let numbers = password.suffix(1)
        guard numbers.rangeOfCharacter(from: .decimalDigits) != nil else { print("마지막은 숫자를 써주세요"); return false }
        return true
    }
    
    func validateNumber(_ number: String) -> Bool {
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
    
    //MARK: - Auth 관련
    // 로그인
    func loginUser(with email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("로그인하는데 에러가 발생했습니다.")
            }
        }
    }
    
    // 회원가입
    func signIn(with email: String, password: String, completion: @escaping ((Bool) -> Void)) {
        guard checkPasswordPattern(password) else {
            completion(false)
            return
        }
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
