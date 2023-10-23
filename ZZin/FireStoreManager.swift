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
    
    public func validatePassword(_ password: String) -> Bool {
        let passwordCheck = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordCheck)
        return predicate.evaluate(with: password)
    }
      
      /// Method to register User
      /// - Parameters:
      ///   - user: 유저 정보 (이메일, 비밀번호, 어플 내 닉네임)
      ///   - completion: 2개의 정보를 담은 completionHandler
      ///   - Bool: wasRegistered - 유저가 데이터베이스에 저장이 되었는지 확인
      ///   - Error?: 에러가 발생할 경우 활용하는 Error
      func loginUser(with user: User) {
          if let password = user.password {
              validatePassword(password)
              Auth.auth().signIn(withEmail: user.uid, password: password) { result, error in
                  if let error = error {
                      print("로그인하는데 에러가 발생했습니다.")
                  }
              }
          }
      }
      
      func signIn(with email: String, password: String) {
          Auth.auth().createUser(withEmail: email, password: password) { result, error in
              if let error = error {
                  print("유저를 생성하는데 에러가 발생했습니다. - \(error.localizedDescription)")
              }
              print("결과값은 아래와 같습니다 - \(result?.description)")
          }
      }
    
}


