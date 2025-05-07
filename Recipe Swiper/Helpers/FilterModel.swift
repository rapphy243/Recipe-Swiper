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
    @Published var selectedIntolerances: Set<String> = []

    init() {
        if UserDefaults.standard.stringArray(forKey: "selectedIntolerances")
            != nil
        {
            selectedIntolerances = Set(
                UserDefaults.standard.stringArray(
                    forKey: "selectedIntolerances"
                )!
            )
        } else {
            selectedIntolerances = []
        }
    }

    func queryItems(apiKey: String) -> [URLQueryItem] {
        var items = [URLQueryItem(name: "apiKey", value: apiKey)]  // API Key, Number of Recipes to return. A URLQueryItem automatically forms API query parameters.
        var include: Set<String> = []
        var exclude: Set<String> = []

        if !includeCuisine.isEmpty {
            include.insert(includeCuisine.lowercased())
        }

        if !includeMealType.isEmpty {
            include.insert(includeMealType)
        }

        if !includeDiet.isEmpty {
            if includeDiet == "lactose-intolerant" {
                ["dairy", "egg", "shellfish", "fish"].forEach {
                    exclude.insert($0)
                }
            }
            else if includeDiet == "gluten-free" {
                exclude.insert("gluten")
            }
            else if includeDiet == "vegetarian" {
                ["dairy", "egg", "fish"].forEach {
                    exclude.insert($0)
                }
            }
            else if includeDiet == "vegan" {
                ["dairy", "egg", "fish", "shellfish"].forEach {
                    exclude.insert($0)
                }
            }
        }

        if !selectedIntolerances.isEmpty {
            exclude.formUnion(selectedIntolerances) // Just inserts selectedIntolerances into exclude
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
