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
    case japanese
    case korean
    case chinese
    case western
    
    
    var title: String {
        switch self {
        case .japanese:
            return "일식"
        case .korean:
            return "한식"
        case .chinese:
            return "중식"
        case .western:
            return "양식"
        }
    }
}
