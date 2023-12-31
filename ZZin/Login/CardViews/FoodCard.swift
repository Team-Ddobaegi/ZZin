//
//  FoodCard.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/18.
//

import Foundation
import Shuffle

class FoodCard: SwipeCard {
    func configure(withModel model: FoodCardModel) {
        content = FoodCardContentView(withImage: model.image)
        footer = FoodCardFooterView(withTitle: "\(model.name)")
    }
}
