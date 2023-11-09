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
    case coldNoodle
    
    var title: String {
        switch self {
        case .hamburger:
            return "햄버거"
        case .curry:
            return "카레"
        case .tteokboki:
            return "떡볶이"
        case .coldNoodle:
            return "냉면"
        }
    }
    
    var imageURL: String {
        switch self {
        case .hamburger:
            return "https://images.unsplash.com/photo-1585238341267-1cfec2046a55?auto=format&fit=crop&q=80&w=2948&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        case .curry:
            return ""
        case .tteokboki:
            return ""
        case .coldNoodle:
            return ""
        }
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("에러가 발생했습니다.", error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let httpURLresponse = response as? HTTPURLResponse, httpURLresponse.statusCode == 200 else {
                print("허가되지 않음")
                completion(nil)
                return
            }
            if let type = response?.mimeType, type.hasPrefix("image"),
               let data = data,
               let image = UIImage(data: data) {
                completion(image)
            } else {
                print("이미지 데이터가 없습니다.")
                completion(nil)
                return
            }
        }
        task.resume()
    }
}
