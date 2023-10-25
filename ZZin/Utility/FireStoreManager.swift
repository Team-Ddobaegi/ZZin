//
//  FireStoreManager.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/23.
//

import Foundation
import Firebase
import FirebaseAuth

struct User {
    var profileImg: String?
    var uid: String
    var nickname: String
    var phoneNum: String
    var rid: [String]? // [UUID.uuidString]
    var pid: [String]? // [UUID.uuidString]
    var password: String?
}

struct Review {
    var rid: String // UUID.uuidString
    var uid: String
    var pid: String // UUID.uuidString
    var reviewImg: String?
    var like: Int
    var dislike: Int
    var content: String
    var rate: Double
    var companion: String // 추후 enum case로 정리 필요
    var condition: String // 추후 enum case로 정리 필요
    var kindOfFood: String // 추후 enum case로 정리 필요
}

struct Place {
    var pid: String // UUID.uuidString
    var rid: [String] // [UUID.uuidString]
    var placeName: String
    var title: String
    var city: String
    var town: String
    var address: String
    var lat: Double
    var long: Double
}

class FireStoreManager {
    let db = Firestore.firestore()
    static let shared = FireStoreManager()
    
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
            "title": PlaceInfo.title,
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
