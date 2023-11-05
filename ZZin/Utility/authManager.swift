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
            print("로그인이 됐습니다. \(result?.description)")
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
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.photoURL = try! "gs://zzin-ios-application.appspot.com/profiles/default_profile.png".asURL()
            changeRequest?.commitChanges { error in
                print(error?.localizedDescription)
            }
            let user = Auth.auth().currentUser?.uid
            let user2 = Auth.auth().currentUser?.email
            
            print("유저 정보를 출력합니다", user)
            print("결과값은 아래와 같습니다 -", user2)
            completion(true)
        }
    }
}
