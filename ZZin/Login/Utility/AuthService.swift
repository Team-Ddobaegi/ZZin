//
//  AuthService.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/23.
//

import Foundation
import FirebaseAuth
import Firebase

class AuthService {
    public static let shared = AuthService()
    private init() {}
    private let db = Firestore.firestore()
    
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
    func registerUser(with user: User, completion: @escaping (Bool, Error?) -> Void) {
        let email = user.uid
        let password = user.password ?? ""
        let username = user.nickname

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else { completion(false, nil); return }
            self.db.collection("user")
                .document(resultUser.uid)
                .setData([
                    "username": username,
                    "email": email
                ]) { error in
                    // 여기서는 에러가 있다고 보는게 맞는거 아닌가?
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    
                    completion(true, nil)
                }
        }
    }
    
    func signIn(with user: User) {
        Auth.auth().signIn(withEmail: user.uid, password: user.password ?? "") { result, error in
            if let error = error {
                print("로그인하는데 문제가 발생했어요!")
            }
            
            print("로그인 완료했어요!")
        }
    }
    
    func showCreateAccount() {
        
    }
}
