//
//  EditIngredientListView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/29/25.
//

import SwiftUI

struct EditIngredientListView: View {
    @Binding var ingredients: [ExtendedIngredient]
    @Environment(\.editMode) var editMode
    // State to track the next temporary ID for new items
    @State private var nextNewItemId: Int = -1

    var body: some View {
        List {
            Section("Ingredients") {
                // Use indices for stable bindings during editing
                ForEach($ingredients.indices, id: \.self) { index in
                    EditableIngredientRowView(
                        ingredient: $ingredients[index],
                        formatter: numberFormatter // Pass the formatter
                    )
                }
                .onDelete(perform: deleteIngredient)
                .onMove(perform: moveIngredient)

                // Button to add a new ingredient
                Button {
                    addIngredient()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Ingredient")
                    }
                }
                .buttonStyle(.borderless) // Optional styling
            }
        }
        .navigationTitle("Edit Ingredients")
        .toolbar {
            EditButton() // Add standard Edit/Done button
        }
        .onAppear {
            // Initialize nextNewItemId based on existing data if needed
            // Find the lowest (most negative) ID among existing items
            let minId = ingredients.map { $0.id }.min() ?? 0
            nextNewItemId = min(minId, 0) - 1 // Start below 0 or existing negatives
        }
    }

    // Formatter for the amount field
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0 // Allow integers
        formatter.maximumFractionDigits = 3 // Allow some precision
        return formatter
    }()
    
    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }

    private func moveIngredient(from source: IndexSet, to destination: Int) {
        ingredients.move(fromOffsets: source, toOffset: destination)
    }

    private func addIngredient() {
        let newIngredient = ExtendedIngredient.newEmpty(id: nextNewItemId)
        ingredients.append(newIngredient)
        nextNewItemId -= 1 // Decrement for the next potential add
    }
}

// MARK: - Editable Ingredient Row View
struct EditableIngredientRowView: View {
    @Binding var ingredient: ExtendedIngredient
    let formatter: NumberFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // --- Editable Name ---
            HStack {
                Text("Name:")
                    .frame(width: 60, alignment: .leading) // Align labels
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Ingredient Name", text: $ingredient.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            // --- Editable Amount & Unit Display ---
            HStack {
                Text("Amount:")
                    .frame(width: 60, alignment: .leading) // Align labels
                    .font(.caption)
                    .foregroundColor(.secondary)

                TextField(
                    "Amount",
                    value: $ingredient.amount,
                    formatter: formatter // Use the passed formatter
                )
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 80) // Give amount field a fixed width

                // Display Unit (Could make this a TextField too if needed)
                TextField("Unit", text: $ingredient.unit)
                    .textFieldStyle(RoundedBorderTextFieldStyle())


                Spacer() // Push unit text to the left if needed
            }

            // --- Display Original Text (Read-only) ---
            // Useful for reference while editing
            if !ingredient.original.isEmpty {
                 HStack {
                     Text("Original:")
                         .frame(width: 60, alignment: .leading) // Align labels
                         .font(.caption)
                         .foregroundColor(.secondary)
                     Text(ingredient.original)
                         .font(.caption)
                         .foregroundColor(.gray)
                         .lineLimit(1)
                 }
            }

            // --- Display Measures (Read-only for simplicity) ---
            // You could add TextFields here if editing measures is required
             HStack(spacing: 15) {
                 Text("Measures:")
                     .frame(width: 60, alignment: .leading)
                     .font(.caption)
                     .foregroundColor(.secondary)
                 Text("US: \(ingredient.measures.us.amount, specifier: "%.2f") \(ingredient.measures.us.unitShort)")
                     .font(.caption)
                     .foregroundColor(.gray)
                 Text("Metric: \(ingredient.measures.metric.amount, specifier: "%.2f") \(ingredient.measures.metric.unitShort)")
                     .font(.caption)
                     .foregroundColor(.gray)
             }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    @Previewable @State var recipe: Recipe = loadCurryRecipe()
    EditIngredientListView(ingredients: $recipe.extendedIngredients)
}
