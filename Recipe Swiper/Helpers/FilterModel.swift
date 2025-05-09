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
//appstorage cehcks if include____ exists and if so, sets the new var equal to it, and if it doesnt exist, makes it and sets it equal to ""
    //intoletances are public cuz you cant put a set in userdefaults, so the initializer below turns it to a string and puts it in defaults
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
// include is things a recipe must include when looking for recipes, exclude is things that should not be in a recipe when searching
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
            include.insert(includeDiet) // ideally we would also exclude more ingrediences, but spoonacular doesn't support everything
        }
        //these are because a diet is basically an intolerance, and the API sometimes includes things not in the diet because the intolerance doesnt include the things the diet doesnt want, so we just made them linked

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
