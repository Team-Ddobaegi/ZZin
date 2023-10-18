//
//  LoginSwipe.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/18.
//

import UIKit
import Shuffle

class CardController: UIViewController {
    
    //MARK: - 변수 선언
    private let cardStack = SwipeCardStack()
    private var initialCardModels: [FoodCardModel] = []
    
    //MARK: - Layout Cards
    private func layoutCardStockView() {
        cardStack.delegate = self
        cardStack.dataSource = self
        view.addSubview(cardStack)
        
        // 화면에 특정 위치에 cardStack이 보일 수 있도록 정리
        cardStack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor)
    }
}

//MARK: - viewLifeCycle
extension CardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        let image = UIImage(systemName: "photo")
        if let image = image {
            let cardModel = FoodCardModel(id: 1, name: "순대국", image: image)
            initialCardModels.append(cardModel)
        }
        layoutCardStockView()
    }
}

//MARK: - SwipeCardStackDelegate
extension CardController: SwipeCardStackDelegate {
    
}

//MARK: - SwipeCardStackDataSource
extension CardController: SwipeCardStackDataSource {
    func cardStack(_ cardStack: Shuffle.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle.SwipeCard {
        let card = FoodCard()
        card.footerHeight = 80
        card.swipeDirections = [.left, .right]
        
        //creating overlay for each direction of the cards
        for direction in card.swipeDirections {
            card.setOverlay(FoodCardOverlay(direction: direction), forDirection: direction)
        }
        
        card.configure(withModel: initialCardModels[index])
        return card
    }
    
    func numberOfCards(in cardStack: Shuffle.SwipeCardStack) -> Int {
        return initialCardModels.count
    }
}
