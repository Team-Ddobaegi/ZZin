//
//  Model.swift
//  ZZin
//
//  Created by 보경 on 10/13/23.
//

import Foundation

enum Company: String {
    case withFamily = "⭐️가족과 함께"
    case withFriends = "😎친구와 함께"
    case withCoworkers = "💪동료와 함께"
    case alone = "😋혼밥"
}

enum Condition: String {
    case rainy = "☔️비가 오는 날엔"
    case luxurious = "💰고급 음식점"
    case oldStoreVibe = "🏚️노포 바이브"
    case lotsOfSideDishes = "🧆반찬 많이요"
}

enum Category: String {
    case korean = "한식"
    case chinese = "중식"
    case japanese = "일식"
    case western = "양식"
    case boonsik = "분식"
    case coffeeAndDessert = "카페&디저트"
}

struct ZZinBasicInfo {
    var registerDate: Date
    var id: UUID
    var name: String
    var address: String
    var lat: Double
    var long: Double
    var RepresentativeImageURL: String
}

struct ZZinRecommendation {
    var basicInfo: ZZinBasicInfo
    var companys: Company
    var conditions: Condition
    var category: Category
    var imageURL: String
}

struct ZZinKeyword {
    var with: Company
    var how: Condition
    var menu: Category
}
