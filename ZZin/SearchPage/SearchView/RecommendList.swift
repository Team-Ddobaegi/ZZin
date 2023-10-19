//
//  RecommendList.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/17/23.
//

import UIKit

struct RecommendList {
    let title: String
    let contents: String

    init(title: String, contents: String) {
        self.title = title
        self.contents = contents
    }
}

// Example usage:
let recommendation1 = RecommendList(title: "추천맛집1", contents: "내용")
let recommendation2 = RecommendList(title: "추천맛집2", contents: "내용")
let recommendation3 = RecommendList(title: "추천맛집3", contents: "내용")
