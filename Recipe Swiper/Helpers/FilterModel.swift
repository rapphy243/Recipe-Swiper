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
    
    @AppStorage("includeCuisine") var includeCuisine: String = ""
    @AppStorage("includeDiet") var includeDiet: String = ""
    @AppStorage("includeMealType") var includeMealType: String = ""
    @AppStorage("includeIntolerance") var includeIntolerance: String = ""
    @AppStorage("excludeCuisine") var excludeCuisine: String = ""
    @AppStorage("excludeDiet") var excludeDiet: String = ""
    @AppStorage("excludeMealType") var excludeMealType: String = ""

    func queryItems(apiKey: String) -> [URLQueryItem] {
        var items = [URLQueryItem(name: "apiKey", value: apiKey)]  // API Key, Number of Recipes to return. A URLQueryItem automatically forms API query parameters.
        var include: [String] = []
        var exclude: [String] = []

        // Include Tags
        if !includeCuisine.isEmpty {
            include.append(includeCuisine)
        }
        if !includeDiet.isEmpty {
            include.append(includeDiet)
        }
        if !includeMealType.isEmpty {
            include.append(includeMealType)
        }

        // Exclude Tags
        if !excludeCuisine.isEmpty {
            exclude.append(excludeCuisine)
        }
        if !excludeDiet.isEmpty {
            exclude.append(excludeDiet)
        }
        if !excludeMealType.isEmpty {
            exclude.append(excludeMealType)
        }

        items.append(
            .init(name: "include-tags", value: include.joined(separator: ","))
        )
        items.append(
            .init(name: "exclude-tags", value: exclude.joined(separator: ","))
        )
        return items
    }
}
