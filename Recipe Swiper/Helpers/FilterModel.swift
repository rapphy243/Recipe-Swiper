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
    @Published var includeCuisine = ""
    @Published var includeDiet = ""
    @Published var includeMealType = ""
    @Published var includeIntolerance = ""
    @Published var excludeCuisine = ""
    @Published var excludeDiet = ""
    @Published var excludeMealType = ""
    @Published var selectedIntolerances: Set<String> = []

    func queryItems(apiKey: String) -> [URLQueryItem] {
        var items = [URLQueryItem(name: "apiKey", value: apiKey)] // API Key, Number of Recipes to return. A URLQueryItem automatically forms API query parameters.
        var include: [String] = []
        var exclude: [String] = []
        
        // Include Tags
        if !includeCuisine.isEmpty {
            include.append(includeCuisine)
        }
        if !includeDiet.isEmpty {
            include.append(includeDiet)
        }
        if !selectedIntolerances.isEmpty {
            let intoleranceString = selectedIntolerances.joined(separator: ",")
            items.append(.init(name: "intolerances", value: intoleranceString))
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
        
        items.append(.init(name: "include-tags", value: include.joined(separator: ",")))
        items.append(.init(name: "exclude-tags", value: exclude.joined(separator: ",")))
        return items
    }
}
