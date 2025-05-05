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
        "", "Dairy", "Egg", "Gluten", "Grain", "Peanut", "Seafood", "Sesame",
        "Shellfish", "Soy", "Sulfite", "Tree Nut", "Wheat",
    ]
    var body: some View {
        NavigationView {
            Form {
                Section("Active Filters") {
                    if model.includeCuisine.isEmpty && model.includeDiet.isEmpty && 
                       model.includeMealType.isEmpty && model.includeIntolerance.isEmpty {
                        Text("No active filters")
                            .foregroundColor(.secondary)
                    } else {
                        if !model.includeCuisine.isEmpty {
                            Text("Cuisine: \(model.includeCuisine.capitalized)")
                        }
                        if !model.includeDiet.isEmpty {
                            Text("Diet: \(model.includeDiet.capitalized)")
                        }
                        if !model.includeMealType.isEmpty {
                            Text("Meal Type: \(model.includeMealType.capitalized)")
                        }
                        if !model.includeIntolerance.isEmpty {
                            Text("Intolerance: \(model.includeIntolerance.capitalized)")
                        }
                        Button("Reset All Filters", role: .destructive) {
                            model.includeCuisine = ""
                            model.includeDiet = ""
                            model.includeMealType = ""
                            model.includeIntolerance = ""
                            model.excludeCuisine = ""
                            model.excludeDiet = ""
                            model.excludeMealType = ""
                        }
                    }
                }

                Section("Cuisine") {
                    Picker("Cuisine", selection: $model.includeCuisine) {
                        ForEach(cuisines, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                }

                Section("Diet") {
                    Picker("Diet", selection: $model.includeDiet) {
                        ForEach(diets, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                }

                Section("Intolerances") {
                    Picker("Intolerances", selection: $model.includeIntolerance)
                    {
                        ForEach(intolerances, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                }

                Section("Meal Type") {
                    Picker("Meal Type", selection: $model.includeMealType) {
                        ForEach(mealTypes, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                }

            }
            .navigationTitle("Filters")
            .toolbar {
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
