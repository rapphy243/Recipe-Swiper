//
//  EditIngredientListView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/29/25.
//
//  Generated with Gemini 2.5 Pro & Reworked with Claude 3.7 Sonnet Thinking

import SwiftUI
import SwiftData

struct EditIngredientListView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var ingredients: [ExtendedIngredientModel]
    @Environment(\.editMode) var editMode

    var body: some View {
        List {
            Section("Ingredients") {
                // Use indices for stable bindings during editing
                ForEach($ingredients.indices, id: \.self) { index in
                    EditableIngredientRowView(
                        ingredient: ingredients[index],
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
            // Remove from ingredients array
            for index in offsets {
                let ingredient = ingredients[index]
                // Delete from model context if needed
                modelContext.delete(ingredient)
            }
            ingredients.remove(atOffsets: offsets)
        }

    private func moveIngredient(from source: IndexSet, to destination: Int) {
        ingredients.move(fromOffsets: source, toOffset: destination)
    }

    private func addIngredient() {
            // Create empty ingredient using ExtendedIngredient helper, then convert
            let tempIngredient = ExtendedIngredient.newEmpty(id: -1)
            let newIngredient = ExtendedIngredientModel(from: tempIngredient)
            ingredients.append(newIngredient)
            modelContext.insert(newIngredient)
        }
}

// MARK: - Editable Ingredient Row View
struct EditableIngredientRowView: View {
    @Bindable var ingredient: ExtendedIngredientModel
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
                
                Spacer()
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ExtendedIngredientModel.self, configurations: config)
    let recipe = loadCurryRecipe()
    var ingredientModels: [ExtendedIngredientModel] = []
    
    // Convert recipe ingredients to models for preview
    for ingredient in recipe.extendedIngredients {
        let model = ExtendedIngredientModel(from: ingredient)
        ingredientModels.append(model)
        container.mainContext.insert(model)
    }
    
    return EditIngredientListView(ingredients: .constant(ingredientModels))
        .modelContainer(container)
}
