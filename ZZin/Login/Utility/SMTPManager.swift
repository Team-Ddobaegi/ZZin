//
//  EmailSmtp.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/26.
//

import Foundation
import SwiftSMTP

//class SMTPManager {
//    private let hostSmtp = SMTP(hostname: "smtp.gmail.com", email: SECRET_EMAIL_KEY, password: SECRET_PASS_KEY)
//    private var authenticationNum: String = ""
//    let randomNum = ["0","1","2","3","4","5","6","7","8","9"]
//    
//    // 인증 코드 생성
//    private func createRandomNumber() -> String {
//        for _ in 1...5 {
//            let random = Int.random(in: 1...randomNum.count)
//            authenticationNum += String(random)
//        }
//        return authenticationNum
//    }
//    
//    // 인증 코드 메일로 발송
//    func sendAuthentication(user: String, completion: @escaping (String, Bool) -> Void) {
//        print("아이디와 비밀번호 \(hostSmtp)")
//        let zzin = Mail.User(email: "zzinddobaegi@gmail.com")
//        let toUser = Mail.User(email: user)
//        
//        let authenticationNumber = createRandomNumber
//        let content = "이메일 인증 번호는 아래와 같습니다. + [\(authenticationNumber)], 어플에서 번호를 입력해주세요."
//        
//        let mail = Mail(from: zzin, to: [toUser], subject: "인증번호", text: "이메일 인증 번호를 입력하세요")
//        hostSmtp.send(mail) { error in
//            if let error = error {
//                print(error, "번호 발송 오류가 있었습니다.")
//                completion(self.authenticationNum, false)
//            } else {
//                completion(self.authenticationNum, true)
//                print(self.authenticationNum)
//            }
//        }
//    }
//}

class SMTPManager {
    private let hostSMTP = SMTP(hostname: "smtp.gmail.com", email: Bundle.main.smtpSecretKey, password: Bundle.main.smtpSecretPass)
    
    func sendAuth(userEmail: String, completion: @escaping (Int, Bool) -> Void) {
        let code = Int.random(in: 10000...99999)
        let fromUser = Mail.User(email: Bundle.main.smtpSecretKey)
        let toUser = Mail.User(email: userEmail)
        let verificationCode = String(code)
        let emailContent = """
    [찐으로부터 메일이 왔어요]
    
    인증번호 : [\(verificationCode)]
    APP에서 인증번호를 입력해주세요!
    """
        let mail = Mail(from: fromUser, to: [toUser], subject: "찐 인증 안내", text: emailContent)
        hostSMTP.send([mail], completion: { _, fail in
            if let error = (fail.first?.1 as? NSError) {
                print(error)
                completion(code, false)
            } else {
                completion(code, true)
                print(code)
            }
        })
    }
    
    func verifyAuthCode(authCode: Int, userInput: String) -> Bool {
        return String(authCode) == userInput
    }
}

extension Bundle {
    var smtpSecretKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
                fatalError("Couldn't find file 'SecretKey.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "SMTPSECRET_KEY") as? String else {
                fatalError("Couldn't find key 'SMTPSECRET_KEY' in 'SecretKey.plist'.")
            }
            return value
        }
    }
    
    var smtpSecretPass: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
                fatalError("Couldn't find file 'SecretKey.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "SMTPSECRET_PASS") as? String else {
                fatalError("Couldn't find key 'SMTPSECRET_PASS' in 'SecretKey.plist'.")
            }
            return value
        }
    }
}
