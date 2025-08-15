//
//  FiltersView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

import SwiftUI

struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var model = FiltersModel.shared
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
            Form {
                Section {
                    Label(
                        "Adding too many filters may cause recipes not to load. Use the refresh recipe in the Main Screen Toolbar to refresh if needed.",
                        systemImage: "exclamationmark.triangle"
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
                Section("Meal Type") {
                    Picker("Meal Type", selection: $model.selectedMealType) {
                        ForEach(mealTypes, id: \.self) { value in
                            Text(value.isEmpty ? "None" : value.capitalized)
                                .tag(value)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Diet") {
                    Picker("Diet", selection: $model.selectedDiet) {
                        ForEach(diets, id: \.self) { value in
                            Text(value.isEmpty ? "None" : value.capitalized)
                                .tag(value)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Cuisine") {
                    Picker("Cuisine", selection: $model.selectedCuisine) {
                        ForEach(cuisines, id: \.self) { value in
                            Text(value.isEmpty ? "None" : value.capitalized)
                                .tag(value)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Intolerances") {
                    ForEach(intolerances.filter { !$0.isEmpty }, id: \.self) {
                        value in
                        Toggle(
                            isOn: Binding(
                                get: {
                                    model.selectedIntolerances.contains(value)
                                },
                                set: { isOn in
                                    if isOn {
                                        model.selectedIntolerances.insert(value)
                                    } else {
                                        model.selectedIntolerances.remove(value)
                                    }
                                }
                            )
                        ) {
                            Text(value.capitalized)
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Label("Cancel Changes", systemImage: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        model.save()
                        dismiss()
                    } label: {
                        Label("Apply", systemImage: "checkmark")
                    }
                }
            }
        }
    }
}

#Preview {
    FiltersView()
}
