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
    
    @AppStorage("includeCuisine") var includeCuisine = ""
    @AppStorage("includeDiet") var includeDiet = ""
    @AppStorage("includeMealType") var includeMealType = ""
    @AppStorage("selectedIntolerancesRaw") var selectedIntolerancesRaw: String = ""
    
    @Published var selectedIntolerances: Set<String> {
        didSet {
            selectedIntolerancesRaw = selectedIntolerances.joined(separator: ",")
        }
    }

    init() {
        let raw = UserDefaults.standard.string(forKey: "selectedIntolerancesRaw") ?? ""
        if raw.isEmpty {
            selectedIntolerances = []
        } else {
            selectedIntolerances = Set(raw.components(separatedBy: ","))
        }
    }


    func queryItems(apiKey: String) -> [URLQueryItem] {
        var items = [URLQueryItem(name: "apiKey", value: apiKey)]  // API Key, Number of Recipes to return. A URLQueryItem automatically forms API query parameters.
        var include: [String] = []
        var exclude: [String] = []
        
        if !includeCuisine.isEmpty {
            items.append(URLQueryItem(name: "cuisine", value: includeCuisine.lowercased()))
        }
        
        if !includeMealType.isEmpty {
            items.append(URLQueryItem(name: "type", value: includeMealType.lowercased()))
        }
        
        var intolerancesSet = selectedIntolerances.map { $0.lowercased() }
        
        if includeDiet.lowercased() == "gluten free" && !intolerancesSet.contains("gluten") {
            intolerancesSet.append("gluten")
        }
        if includeDiet.lowercased() == "vegan" {
            ["dairy", "egg", "shellfish", "fish"].forEach {
                if !intolerancesSet.contains($0) { intolerancesSet.append($0) }
            }
        }
        if includeDiet.lowercased() == "vegetarian" {
            ["meat", "fish", "shellfish"].forEach {
                if !intolerancesSet.contains($0) { intolerancesSet.append($0) }
            }
        }
        if includeDiet.lowercased() == "pescetarian" {
            if !intolerancesSet.contains("meat") { intolerancesSet.append("meat") }
        }
        if includeDiet.lowercased() == "ovo-vegetarian" {
            ["meat", "fish", "shellfish"].forEach {
                if !intolerancesSet.contains($0) { intolerancesSet.append($0) }
            }
        }
        if includeDiet.lowercased() == "lacto-vegetarian" {
            ["meat", "fish", "shellfish"].forEach {
                if !intolerancesSet.contains($0) { intolerancesSet.append($0) }
            }
        }
        
        if intolerancesSet.contains("gluten"), includeDiet.isEmpty {
            includeDiet = "gluten free"
        }
        if intolerancesSet.contains("egg") && intolerancesSet.contains("shellfish"), includeDiet.isEmpty {
            includeDiet = "vegan"
        }
        
        if !includeDiet.isEmpty {
            items.append(URLQueryItem(name: "diet", value: includeDiet.lowercased()))
        }
        
        if !intolerancesSet.isEmpty {
            let intoleranceString = intolerancesSet.joined(separator: ",")
            items.append(URLQueryItem(name: "intolerances", value: intoleranceString))
        }
        
        return items
    }
}
