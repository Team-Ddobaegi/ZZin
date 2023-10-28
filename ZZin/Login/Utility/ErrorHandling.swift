//
//  ErrorHandling.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/29.
//

import Foundation

enum ErrorHandling {
    case passwordError
    case idError
    case noValue
    
    var title: String {
        switch self {
        case .passwordError:
            return "비밀번호"
        case .idError:
            return "아이디"
        case .noValue:
            return "값 없음"
        }
    }
    
    var message: String {
        switch self {
        case .passwordError:
            return "비밀번호를 확인해주세요"
        case .idError:
            return "아이디를 확인해주세요"
        case .noValue:
            return "이건 뭐..."
        }
    }
}
