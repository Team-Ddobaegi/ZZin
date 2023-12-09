//
//  authManager.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/05.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    //MARK: - Auth 관련
    // 로그인
    func loginUser(with email: String, password: String, completion: @escaping ((Bool) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("이메일이 틀렸습니다. \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
    
    func registerNewUser(with credentials: AuthCredentials, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
            if let error = error {
                print("에러가 발생했습니다. \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(false, nil)
                return
            }
            
            let data: [String: Any] = ["email": credentials.email,
                                       "uid": uid,
                                       "userName": credentials.userName,
                                       "description": credentials.description,
                                       "pid": credentials.pid,
                                       "rid": credentials.rid,
                                       "profileImg": credentials.profileImage
            ]
            FireStoreManager.shared.db.collection("users").document(uid).setData(data) { firestoreError in
                if let error = firestoreError {
                    print("데이터 저장 에러가 발생했습니다.", error.localizedDescription)
                    completion(false, error)
                    return
                } else {
                    print("유저 생성 완료")
                    completion(true, nil)
                }
            }
        }
    }
}
