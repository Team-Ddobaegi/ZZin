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
    private let foodCardCases: [FoodCardData] = [.coldNoodle, .curry, .hamburger, .tteokboki]
    
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
    
    private func didSwipeAll() -> Bool {
        print(initialCardModels.count)
        if initialCardModels.count == 2 {
            return true
        }
        return true
    }
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("이미지를 호출하는데 오류가 있었습니다.")
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("UIImage로 url을 가져올 수 없었습니다.")
                completion(nil)
            }
        }.resume()
    }
    
    
    deinit {
        print("카드 화면이 내려갔습니다")
    }
}

//MARK: - viewLifeCycle
extension CardController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let hamburgerURL = URL(string: "https://images.unsplash.com/photo-1585238341267-1cfec2046a55?auto=format&fit=crop&q=80&w=2948&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D") {
            downloadImage(from: hamburgerURL) { image in
                if let downloadedImage = image {
                    let cardModel = FoodCardModel(id: 1, name: FoodCardData.hamburger.title, image: downloadedImage)
                    self.initialCardModels.append(cardModel)
                }
            }
        }
        
        let image2 = UIImage(named: "ogudangdang")
        if let image = image2 {
            let cardModel = FoodCardModel(id: 2, name: FoodCardData.coldNoodle.title, image: image)
            initialCardModels.append(cardModel)
        }
        
        let image3 = UIImage(named: "ogudangdang")
        if let image = image3 {
            let cardModel = FoodCardModel(id: 3, name: FoodCardData.curry.title, image: image)
            initialCardModels.append(cardModel)
        }
        
        let image4 = UIImage(named: "ogudangdang")
        if let image = image4 {
            let cardModel = FoodCardModel(id: 4, name: FoodCardData.tteokboki.title, image: image)
            initialCardModels.append(cardModel)
        }
        layoutCardStockView()
        print(initialCardModels.count)
    }
}

//MARK: - SwipeCardStackDelegate
extension CardController: SwipeCardStackDelegate {
    
}

//MARK: - SwipeCardStackDataSource
extension CardController: SwipeCardStackDataSource {
    func cardStack(_ cardStack: Shuffle.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle.SwipeCard {
        let card = FoodCard()
        card.footerHeight = 100
        card.swipeDirections = [.left, .right]
        
        //creating overlay for each direction of the cards
        if index >= 0 && index < initialCardModels.count {
            for direction in card.swipeDirections {
                card.setOverlay(FoodCardOverlay(direction: direction), forDirection: direction)
            }
            // 인덱스 범위를 벗어나는 카드를 선언할 경우 index out of range 발생
            card.configure(withModel: initialCardModels[index])
        } else {
            card.configure(withModel: FoodCardModel(id: -1, name: "음식 사진", image: UIImage(named: "ogudangdang") ?? UIImage()))
        }
        return card
    }
    
    func numberOfCards(in cardStack: Shuffle.SwipeCardStack) -> Int {
        return initialCardModels.count
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        print("finished with cards")
        if didSwipeAll() {
            let vc = TabBarViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        print("Swipe to", direction)
        print(index)
        if index < initialCardModels.count {
            initialCardModels.remove(at: index)
        }
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        print("Selected card at", index)
    }
}
