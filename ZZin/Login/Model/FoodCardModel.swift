//
//  FoodCardModel.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/18.
//

import UIKit

struct FoodCardModel {
    let id: Int
    let name: String
    let image: UIImage
    var choice: Bool?
}

enum FoodCardData {
    case hamburger
    case curry
    case tteokboki
    
    var title: String {
        switch self {
        case .hamburger:
            return "햄버거"
        case .curry:
            return "카레"
        case .tteokboki:
            return "떡볶이"
        }
    }
    
    var image: String {
        switch self {
        case .hamburger:
            return "https://images.unsplash.com/photo-1585238341267-1cfec2046a55?auto=format&fit=crop&q=80&w=2948&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        case .curry:
            return ""
        case .tteokboki:
            return ""
        }
    }
}
