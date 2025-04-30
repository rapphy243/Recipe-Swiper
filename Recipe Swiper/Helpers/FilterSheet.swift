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
    
    let mealTypes = ["", "main course", "side dish", "dessert", "appetizer", "salad", "bread", "breakfast", "soup", "beverage", "sauce", "marinade", "fingerfood", "snack", "drink"]
    let diets = ["", "gluten free", "ketogenic", "vegetarian", "Lacto-Vegetarian", "Ovo-Vegetarian", "vegan", "pescetarian", "paleo", "primal", "low fodmap", "whole30"]
    let cuisines = ["", "african", "asian", "american", "british", "cajun", "caribbean", "chinese", "eastern european", "european", "french", "german", "greek", "indian", "irish", "italian", "japanese", "jewish", "korean", "latin american", "mediterranean", "mexican", "middle eastern", "nordic", "southern", "spanish", "thai", "vietnamese"]
    let intolerances = ["", "Dairy", "Egg", "Gluten", "Grain", "Peanut", "Seafood", "Sesame", "Shellfish", "Soy", "Sulfite", "Tree Nut", "Wheat"]
    var body: some View {
        NavigationView {
            Form {
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
                Section("Meal Type") {
                                    Picker("Meal Type", selection: $model.includeMealType) {
                                        ForEach(mealTypes, id: \.self) {
                                            Text($0.capitalized)
                                        }
                                    }
                                }

                Section("Intolerances") {
                    ForEach(intolerances.filter { !$0.isEmpty }, id: \.self) { intolerance in
                        Toggle(intolerance.capitalized, isOn: Binding(
                            get: { model.selectedIntolerances.contains(intolerance) },
                            set: { isSelected in
                                if isSelected {
                                    model.selectedIntolerances.insert(intolerance)
                                } else {
                                    model.selectedIntolerances.remove(intolerance)
                                }
                            }
                        ))
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
