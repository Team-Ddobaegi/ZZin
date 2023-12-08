//
//  ErrorHandling.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/29.
//

import Foundation

enum ErrorHandling {
    case passwordError
    case passwordBlank
    case firstPasswordCap
    case lastPassword
    case idError
    case idBlank
    case noValue
    case idWrongFormat
    case signInFailure
    case loginFailure
    case doubleCheck
    case firstTimePass
    case firstTimeID
    case tooShort
    case error
    case alreadyExists
    case agreement
    case equalPassword
    case checkEmail
    case emailError
    case codeFail
    case codeSuccess
    case checkAgain
    
    var title: String {
        switch self {
        case .passwordError:
            return "🚨비밀번호 오류🚨"
        case .idError:
            return "🚨아이디 오류🚨"
        case .passwordBlank:
            return "비밀번호가 비어있어요!"
        case .firstPasswordCap, .lastPassword:
            return "잘 떠올려보세요!"
        case .idBlank:
            return "아이디가 비어있어요!"
        case .idWrongFormat:
            return "혹시 잊으셨을까요?"
        case .noValue:
            return "어라..?"
        case .signInFailure:
            return "이메일로 계정이 이미 있어요!"
        case .loginFailure:
            return "로그인 실패"
        case .doubleCheck:
            return "빈 칸이 있어요"
        case .firstTimePass:
            return "비밀번호 오류"
        case .firstTimeID:
            return "아이디 오류"
        case .error:
            return "오류"
        case .tooShort:
            return "너무 짧아요"
        case .alreadyExists:
            return "해당 이메일이 존재해요"
        case .agreement:
            return "이용 약관 동의"
        case .equalPassword:
            return "비밀번호 불일치"
        case .checkEmail:
            return "인증번호가 발송되었습니다."
        case .emailError:
            return "이메일 발송 오류"
        case .codeFail:
            return "번호가 틀렸어요"
        case .codeSuccess:
            return "인증 완료"
        case .checkAgain:
            return "인증이 되지 않았어요"
        }
    }
    
    var message: String {
        switch self {
        case .passwordError:
            return "비밀번호를 다시 확인해주세요"
        case .passwordBlank, .idBlank:
            return "다시 한번 봐주세요"
        case .firstPasswordCap:
            return "첫 글자는 아마 대문자였을꺼에요"
        case .lastPassword:
            return "마지막은 아마 특수문자 였을꺼에요!"
        case .idError:
            return "아이디를 다시 확인해주세요"
        case .idWrongFormat:
            return "이메일 주소로 가입하셨어요"
        case .noValue:
            return "빈칸없이 채워주세요!"
        case .signInFailure:
            return "아이디 생성을 실패했습니다."
        case .loginFailure:
            return "다시 한번 찐 회원이 되어주실래요?"
        case .doubleCheck:
            return "놓친 정보가 있는지 확인해주세요"
        case .firstTimePass:
            return "대문자로 시작, 숫자로 끝내주세요"
        case .firstTimeID:
            return "이메일 주소를 적어주세요"
        case .error:
            return "오류가 발생했습니다"
        case .tooShort:
            return "비밀번호는 8자리 이상이어야 합니다!"
        case .alreadyExists:
            return "다른 이메일을 사용해주세요"
        case .agreement:
            return "약관을 동의해주세요"
        case .equalPassword:
            return "같은 비밀번호를 입력해주세요"
        case .checkEmail:
            return "이메일을 확인해주세요"
        case .emailError:
            return "다른 이메일을 사용해보시겠어요?"
        case .codeFail:
            return "다시 입력해주세요"
        case .codeSuccess:
            return "번호가 인증되었습니다"
        case .checkAgain:
            return "다시 확인해주세요"
        }
    }
}
