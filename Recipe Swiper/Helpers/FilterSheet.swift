//
//  FilterSheet.swift
//  Recipe Swiper
//
//  Created by Zane Matarieh on 4/22/25.
//

import Foundation
import SwiftUI

struct FilterSheet: View {
    @ObservedObject var model: FilterModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("Cuisine") {
                    Picker("Cuisine", selection: $model.cuisine) {
                        ForEach(["", "Italian", "Mexican", "Chinese", "Indian", "Korean"], id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                }

                Section("Diet / Allergies") {
                    Picker("Diet", selection: $model.diet) {
                        ForEach(["", "gluten free", "dairy free", "vegan", "vegetarian", "paleo"], id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                }

                Section("Meal Type") {
                    Picker("Meal Type", selection: $model.mealType) {
                        ForEach(["", "main course", "dessert", "breakfast", "snack", "soup"], id: \.self) {
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
