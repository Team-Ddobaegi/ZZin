//
//  EmailSmtp.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/26.
//

import Foundation
import SwiftSMTP

class SMTPManager {
    private let hostSmtp = SMTP(hostname: "zzinddobaegi@gmail.com", email: "zzinddobaegi@gmail.com", password: "WlsEhqprl123!@#")
    private var authenticationNum: String = ""
    let randomNum = ["0","1","2","3","4","5","6","7","8","9"]
    
    // 인증 코드 생성
    private func createRandomNumber() -> String {
        for _ in 1...5 {
            let random = Int.random(in: 1...randomNum.count)
            authenticationNum += String(random)
        }
        return authenticationNum
    }
    
    // 인증 코드 메일로 발송
    func sendAuthentication(user: AuthCredentials, completion: @escaping (String, Bool) -> Void) {
        let zzin = Mail.User(email: "zzinddobaegi@gmail.com")
        let toUser = Mail.User(email: user.email)
        
        let authenticationNumber = createRandomNumber
        let content = "이메일 인증 번호는 아래와 같습니다. + [\(authenticationNumber)], 어플에서 번호를 입력해주세요."
        
        let mail = Mail(from: zzin, to: [toUser], subject: "인증번호", text: "이메일 인증 번호를 입력하세요")
        hostSmtp.send(mail) { error in
            if let error = error {
                print(error, "번호 발송 오류가 있었습니다.")
                completion(self.authenticationNum, false)
            } else {
                completion(self.authenticationNum, true)
                print(self.authenticationNum)
            }
        }
    }
}
