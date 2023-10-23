//
//  FireStoreManager.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/23.
//

import Foundation
import Firebase

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
}


