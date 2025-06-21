//
//  FilterSheet.swift
//  Recipe Swiper
//
//  Created by Zane Matarieh on 4/22/25.
//

import Foundation
import SwiftUI

struct FilterSheetView: View {
    @ObservedObject var model: FilterModel
    @Environment(\.dismiss) var dismiss
//all options for filters
    let mealTypes = [
        "", "main course", "side dish", "dessert", "appetizer", "salad",
        "bread", "breakfast", "soup", "beverage", "sauce", "marinade",
        "fingerfood", "snack", "drink",
    ]
    let diets = [
        "", "gluten free", "ketogenic", "vegetarian", "Lacto-Vegetarian",
        "Ovo-Vegetarian", "vegan", "pescetarian", "paleo", "primal",
        "low fodmap", "whole30",
    ]
    let cuisines = [
        "", "african", "asian", "american", "british", "cajun", "caribbean",
        "chinese", "eastern european", "european", "french", "german", "greek",
        "indian", "irish", "italian", "japanese", "jewish", "korean",
        "latin american", "mediterranean", "mexican", "middle eastern",
        "nordic", "southern", "spanish", "thai", "vietnamese",
    ]
    let intolerances = [
        "", "dairy", "egg", "gluten", "grain", "peanut", "seafood", "sesame",
        "shellfish", "soy", "sulfite", "tree nut", "wheat",
    ]

    var body: some View {
        NavigationView {
            //active filters displayed, button to reset all filters. uses model to integrate the filterModel to this sheet
            Form {
                Section(header: Text("Active Filters")) {
                    if !model.includeCuisine.isEmpty {
                        Text("Cuisine: \(model.includeCuisine.capitalized)")
                    }
                    if !model.includeDiet.isEmpty {
                        Text("Diet: \(model.includeDiet.capitalized)")
                    }
                    if !model.includeMealType.isEmpty {
                        Text("Meal Type: \(model.includeMealType.capitalized)")
                    }
                    if !model.selectedIntolerances.isEmpty {
                        Text("Intolerances: \(model.selectedIntolerances.joined(separator: ", ").capitalized)")
                    }
                    if (model.includeCuisine.isEmpty && model.includeDiet.isEmpty
                        && model.includeMealType.isEmpty
                        && model.selectedIntolerances.isEmpty) {
                        Text("No active filters")
                            .foregroundColor(.secondary)
                    } else {
                        Button("Reset All Filters", role: .destructive) {
                            model.includeCuisine = ""
                            model.includeDiet = ""
                            model.includeMealType = ""
                            model.selectedIntolerances = []
                            UserDefaults.standard.set(Array(model.selectedIntolerances), forKey: "selectedIntolerances")
                        }
                    }
                }
//picker for what cuisine you want
                Section("Cuisine") {
                    Picker("Cuisine", selection: $model.includeCuisine) {
                        ForEach(cuisines, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                }
//picker for what diet youre on
                Section("Diet") {
                    Picker("Diet", selection: $model.includeDiet) {
                        ForEach(diets, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                }
                //meal type picker
                Section("Meal Type") {
                                    Picker("Meal Type", selection: $model.includeMealType) {
                                        ForEach(mealTypes, id: \.self) {
                                            Text($0.capitalized)
                                        }
                                    }
                                }
//some people have multiple allergies, so you can select multiple filters
                Section("Intolerances") {
                    ForEach(intolerances.filter { !$0.isEmpty }, id: \.self) { intolerance in
                        Toggle(intolerance.capitalized, isOn: Binding(
                            get: {
                                model.selectedIntolerances.contains(intolerance)
                            },
                            set: { isSelected in
                                if isSelected {
                                    model.selectedIntolerances.insert(intolerance)
                                } else {
                                    model.selectedIntolerances.remove(intolerance)
                                }
                                // Save changes to UserDefaults
                                UserDefaults.standard.set(Array(model.selectedIntolerances), forKey: "selectedIntolerances")
                            }
                        ))
                    }
                }

                
            }
            .navigationTitle("Filters")
            .toolbar {
                //cancel and save buttons
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FilterSheetView(model: FilterModel())
}
