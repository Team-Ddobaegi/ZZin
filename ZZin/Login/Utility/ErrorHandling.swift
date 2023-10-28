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
    
    var title: String {
        switch self {
        case .passwordError:
            return "🚨비밀번호 오류🚨"
        case .passwordBlank:
            return "비밀번호"
        case .firstPasswordCap:
            return "첫 단어"
        case .lastPasswordNum:
            return "마지막 단어"
        case .idError:
            return "🚨아이디 오류🚨"
        case .idBlank:
            return "빈 아이디"
        case .numberShort:
            return "번호 형식"
        case .idWrongFormat:
            return "아이디 형식"
        case .noValue:
            return "값 없음"
        case .signInFailure:
            return "🚨생성 실패🚨"
        }
    }
    
    var message: String {
        switch self {
        case .passwordError:
            return "비밀번호를 다시 확인해주세요"
        case .passwordBlank:
            return "비밀번호가 비어있어요"
        case .firstPasswordCap:
            return "는 대문자!"
        case .lastPasswordNum:
            return "는 숫자로 처리!"
        case .idError:
            return "아이디를 다시 확인해주세요"
        case .idBlank:
            return "아이디가 비어있어요"
        case .numberShort:
            return "전화번호가 짧아요!"
        case .idWrongFormat:
            return "이메일 형식과 달라요"
        case .noValue:
            return "빈칸없이 채워주세요!"
        case .signInFailure:
            return "아이디 생성을 실패했습니다."
        }
    }
}
