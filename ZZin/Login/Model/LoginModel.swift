//
//  File.swift
//  ZZin
//
//  Created by Jack Lee on 2023/11/06.
//

import Foundation

struct LoginModel {
    var email: String?
    var password: String?
    
    var isValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
