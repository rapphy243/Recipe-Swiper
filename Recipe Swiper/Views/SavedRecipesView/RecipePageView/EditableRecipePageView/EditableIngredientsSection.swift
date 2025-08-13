//
//  EditableIngredientsSection.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 8/13/25.
//

import SwiftUI
import SwiftData

struct EditableIngredientsSection: View {
    @Bindable var recipe: RecipeModel

    var body: some View {
        Section("Ingredients") {
            if recipe.extendedIngredients.isEmpty {
                Text("No ingredients yet.")
                    .foregroundColor(.secondary)
            } else {
                ForEach($recipe.extendedIngredients) { $ingredient in
                    IngredientRow(ingredient: $ingredient) {
                        if let idx = recipe.extendedIngredients.firstIndex(where: { $0 === ingredient }) {
                            recipe.extendedIngredients.remove(at: idx)
                        }
                    }
                }
            }
            Button {
                addIngredient()
            } label: {
                Label("Add Ingredient", systemImage: "plus.circle")
            }
        }
    }

    private func addIngredient() {
        let defaultUnit = MeasurementUnit(amount: 0, unitShort: "", unitLong: "")
        let defaultMeasures = Measures(us: defaultUnit, metric: defaultUnit)
        let placeholder = ExtendedIngredient(
            id: Int.random(in: 100000...999999),
            aisle: nil,
            image: nil,
            consistency: nil,
            name: "",
            nameClean: nil,
            original: "",
            originalName: "",
            amount: 0,
            unit: "",
            meta: nil,
            measures: defaultMeasures
        )
        let model = ExtendedIngredientModel(from: placeholder)
        recipe.extendedIngredients.append(model)
    }
}

private struct IngredientRow: View {
    @Binding var ingredient: ExtendedIngredientModel
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                TextField("Name", text: $ingredient.name)
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.borderless)
            }

            HStack {
                Stepper(value: $ingredient.amount, in: 0...10000, step: 0.1) {
                    Text("Amount: \(formatAmount(ingredient.amount))")
                }
                TextField("Unit", text: $ingredient.unit)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            if !ingredient.original.isEmpty || !ingredient.originalName.isEmpty {
                Text("Original: \(ingredient.original)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private func formatAmount(_ amount: Double) -> String {
        if amount.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", amount)
        } else {
            return String(format: "%.1f", amount)
        }
    }
}

#Preview {
    EditableIngredientsSection(recipe: RecipeModel(from: Recipe.Cake))
}


