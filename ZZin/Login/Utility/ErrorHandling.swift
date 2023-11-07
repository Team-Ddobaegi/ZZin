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
    case lastPasswordNum
    case idError
    case idBlank
    case noValue
    case numberShort
    case idWrongFormat
    case signInFailure
    case loginFailure
    case doubleCheck
    case firstTimePass
    case firstTimeID
    case tooShort
    case error
    case alreadyExists
    
    var title: String {
        switch self {
        case .passwordError:
            return "🚨비밀번호 오류🚨"
        case .idError:
            return "🚨아이디 오류🚨"
        case .passwordBlank:
            return "비밀번호가 비어있어요!"
        case .firstPasswordCap, .lastPasswordNum:
            return "잘 떠올려보세요!"
        case .idBlank:
            return "아이디가 비어있어요!"
        case .numberShort:
            return "번호 형식"
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
            return "너무 길어요"
        case .alreadyExists:
            return "해당 이메일이 존재해요"
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
        case .lastPasswordNum:
            return "마지막 자리는 숫자이지 않았나요?"
        case .idError:
            return "아이디를 다시 확인해주세요"
        case .numberShort:
            return "전화번호가 짧아요!"
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
            return "길이가 너무 긺"
        case .alreadyExists:
            return "다른 이메일을 사용해주세요"
        }
    }
}
