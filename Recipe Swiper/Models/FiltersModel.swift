//
//  FiltersModel.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 8/14/25.
//

import SwiftUI

@Observable class FiltersModel {
    static let shared = FiltersModel()
    
    // Stored selections (single-select)
    var selectedMealType: String
    var selectedDiet: String
    var selectedCuisine: String

    // Stored selections (multi-select)
    var selectedIntolerances: Set<String>

    // Persistence keys
    private let mealTypeKey = "filters.mealType"
    private let dietKey = "filters.diet"
    private let cuisineKey = "filters.cuisine"
    private let intolerancesKey = "filters.intolerances"

    init() {
        let defaults = UserDefaults.standard
        self.selectedMealType = defaults.string(forKey: mealTypeKey) ?? ""
        self.selectedDiet = defaults.string(forKey: dietKey) ?? ""
        self.selectedCuisine = defaults.string(forKey: cuisineKey) ?? ""
        if let savedArray = defaults.array(forKey: intolerancesKey) as? [String]
        {
            self.selectedIntolerances = Set(savedArray)
        } else {
            self.selectedIntolerances = []
        }
    }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(selectedMealType, forKey: mealTypeKey)
        defaults.set(selectedDiet, forKey: dietKey)
        defaults.set(selectedCuisine, forKey: cuisineKey)
        defaults.set(Array(selectedIntolerances), forKey: intolerancesKey)
    }

    func reset() {
        selectedMealType = ""
        selectedDiet = ""
        selectedCuisine = ""
        selectedIntolerances = []
        save()
    }

    /// Returns all selected filters as an array of strings.
    /// Empty selections are omitted. Multi-selected intolerances are included individually.
    func selectedIncludeFilters() -> [String] {
        var results: [String] = []
        if !selectedMealType.trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        {
            results.append(selectedMealType)
        }
        if !selectedDiet.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            results.append(selectedDiet)
        }
        if !selectedCuisine.trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        {
            results.append(selectedCuisine)
        }
        return results
    }
    
    func selectedExcludeFilters() -> [String] {
        var results: [String] = []
        results.append(contentsOf: selectedIntolerances.sorted())
        return results
    }
}
