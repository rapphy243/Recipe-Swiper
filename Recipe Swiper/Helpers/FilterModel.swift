//
//  FilterModel.swift
//  Recipe Swiper
//
//  Created by Zane Matarieh on 4/22/25.
//

import Foundation
import SwiftUI

class FilterModel: ObservableObject {
    @Published var showFilter = false
    @Published var cuisine = ""
    @Published var diet = ""
    @Published var mealType = ""

    func queryItems(apiKey: String) -> [URLQueryItem] {
        var items = [URLQueryItem(name: "apiKey", value: apiKey),
                     URLQueryItem(name: "number", value: "1")]
        if !cuisine.isEmpty { items.append(.init(name: "cuisine", value: cuisine)) }
        if !diet.isEmpty { items.append(.init(name: "diet", value: diet)) }
        if !mealType.isEmpty { items.append(.init(name: "type", value: mealType)) }
        return items
    }
}
