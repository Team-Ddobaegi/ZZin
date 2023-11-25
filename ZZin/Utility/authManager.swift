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
            completion(true)
            return
        }
    }
    
    // 회원가입
    //    func signInUser(with email: String, password: String, completion: @escaping ((Bool) -> Void)) {
    //        Auth.auth().createUser(withEmail: email, password: password) { result, error in
    //            if let error = error {
    //                print("여기가 문제인가요 유저를 생성하는데 에러가 발생했습니다. \(error.localizedDescription)")
    //                completion(false)
    //            }
    //            guard let uid = result?.user.uid else { return }
    //
    
    //            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    //            changeRequest?.photoURL = try! "gs://zzin-ios-application.appspot.com/profiles/default_profile.png".asURL()
    //            changeRequest?.commitChanges { error in
    //                print(error?.localizedDescription)
    //            }
    //            let user = Auth.auth().currentUser?.uid
    //            let user2 = Auth.auth().currentUser?.email
    
    //            print("유저 정보를 출력합니다", user)
    //            print("결과값은 아래와 같습니다 -", user2)
    //            completion(true)
    //        }
    //    }
    
    //    func registerNewUser(with credentials: AuthCredentials, completion: @escaping (Bool, Error?) -> Void) {
    //        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
    //            if let error = error {
    //                print("에러가 발생했습니다. \(error.localizedDescription)")
    //                completion(false, error)
    //                return
    //            }
    //
    //            guard let uid = result?.user.uid else {
    //                completion(false, nil)
    //                return
    //            }
    //
    //            do {
    //                let photoURL = URL(string: "gs://zzin-ios-application.appspot.com/profiles/default_profile.png")
    //                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    //                changeRequest?.photoURL = photoURL
    //                changeRequest?.displayName = credentials.userName
    //
    //                changeRequest?.commitChanges { commitError in
    //                    if let commitError = commitError {
    //                        print("프로필 변경 에러가 발생했습니다.", commitError.localizedDescription)
    //                        completion(false, commitError)
    //                        return
    //                    }
    //
    //                    let data: [String: Any] = ["email": credentials.email,
    //                                               "uid": uid,
    //                                               "userName": credentials.userName]
    //                    FireStoreManager.shared.db.collection("users").document(uid).setData(data) { error in
    //                        if let error = error {
    //                            print("데이터 저장 에러가 발생했습니다.", error.localizedDescription)
    //                            completion(false, error)
    //                            return
    //                        }
    //                        completion(true, error ?? "")
    //                    }
    //                }
    //            } catch {
    //                print("이미지를 저장하는데 에러가 발생했습니다.", error.localizedDescription)
    //                completion(false, error)
    //            }
    //
    //        }
    //    }
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
            
            //            do {
            //                let photoURL = URL(string: "gs://zzin-ios-application.appspot.com/profiles/default_profile.png") // 초
            //                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            //                changeRequest?.photoURL = photoURL
            //                changeRequest?.displayName = credentials.userName
            //
            //                changeRequest?.commitChanges { commitError in
            //                    if let commitError = commitError {
            //                        print("프로필 변경 에러가 발생했습니다.", commitError.localizedDescription)
            //                        completion(false, commitError)
            //                        return
            //                    }
            
            let data: [String: Any] = ["email": credentials.email,
                                       "uid": uid,
                                       "userName": credentials.userName,
                                       "description": credentials.description,
                                       "pid": credentials.pid,
                                       "rid": credentials.rid,
                                       "profileImg": credentials.profileImage
            ]
            //                    FireStoreManager.shared.db.collection("users").addDocument(data: data)
            
            FireStoreManager.shared.db.collection("users").document(uid).setData(data) { firestoreError in
                if let error = firestoreError {
                    print("데이터 저장 에러가 발생했습니다.", error.localizedDescription)
                    completion(false, error)
                    return
                } else {
                    print("유저 생성 완료")
                    completion(true, nil)
                }
                //                }
            }
        }
    }
    //}
    //}
}
