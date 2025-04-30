//
//  EditFullRecipe.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/29/25.
//
//  Generated with Gemini 2.5 Pro

import SwiftUI

struct EditFullRecipeView: View {
    @Binding var recipe: Recipe
    var body: some View {
        NavigationStack {
            Form {
                // Section for basic identification and core details
                Section("Basic Info") {
                    // ID is usually not editable
                    HStack {
                        Text("Recipe ID")
                        Text("\(recipe.id)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Recipe Title:")
                        TextField("", text: $recipe.title)
                    }

                    HStack {
                        Text("Image URL")
                        TextField(
                            "e.g., https://...",
                            text: binding(for: $recipe.image)
                        )
                        .lineLimit(1)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    }
                }
                
                // Section for timings and servings
                Section("Timings & Servings") {
                    HStack {
                        Text("Ready in Minutes")
                        TextField(
                            "Minutes",
                            value: $recipe.readyInMinutes,
                            formatter: numberFormatter
                        )
                        .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Servings")
                        TextField(
                            "Count",
                            value: $recipe.servings,
                            formatter: numberFormatter
                        )
                        .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Preparation Minutes")
                        TextField(
                            "Optional",
                            text: binding(for: $recipe.preparationMinutes)
                        )
                        .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Cooking Minutes")
                        TextField(
                            "Optional",
                            text: binding(for: $recipe.cookingMinutes)
                        )
                        .keyboardType(.numberPad)
                    }
                }
                
                // Section for dietary flags
                Section("Dietary Information") {
//                    Toggle("Vegetarian", isOn: $recipe.vegetarian)
//                    Toggle("Vegan", isOn: $recipe.vegan)
//                    Toggle("Gluten Free", isOn: $recipe.glutenFree)
//                    Toggle("Dairy Free", isOn: $recipe.dairyFree)
//                    Toggle("Very Healthy", isOn: $recipe.veryHealthy)
//                    Toggle("Cheap", isOn: $recipe.cheap)
                    // Displaying arrays as comma-separated strings (read-only is safer)
                    // Consider dedicated editing UI for these if needed
                    HStack {
                        Text("Cuisines")
                        Text("\(recipe.cuisines.joined(separator: ", "))")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Dish Types")
                        Text("\(recipe.dishTypes.joined(separator: ", "))")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Diets")
                        Text("\(recipe.diets.joined(separator: ", "))")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Ingredients & Instructions") {
                    NavigationLink("Edit Ingredients") {
                        EditIngredientListView(ingredients: $recipe.extendedIngredients)
                    }
                    NavigationLink("Edit Instructions") {
                        EditAnalyzedInstructionListView(analyzedInstructions: $recipe.analyzedInstructions)
                    }
                }
                
                // Section for summary and details
                Section("Summary") {
                    TextEditor(text: $recipe.summary)
                        .frame(height: 250)
                }
                Section("Other Details") {
                    HStack {
                        Text("Health Score")
                        TextField(
                            "Score",
                            value: $recipe.healthScore,
                            formatter: numberFormatter
                        )
                        .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Estmated Price Per Serving")
                        TextField(
                            "Price",
                            value: $recipe.pricePerServing,
                            formatter: decimalFormatter
                        )
                        .keyboardType(.decimalPad)
                    }
                }
                
                // Section for source and metadata
                Section("Source & Meta") {
                    HStack {
                        Text("Source Name: ")
                        TextField("Source Name", text: $recipe.sourceName)
                    }
                    HStack {
                        Text("Source URL")
                        TextField(
                            "Optional URL",
                            text: binding(for: $recipe.sourceUrl)
                        )
                        .lineLimit(1)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    }
                    HStack {
                        Text("Credits Text: ")
                        TextField("Source Name", text: $recipe.creditsText)
                    }
                    HStack {
                        Text("Spoonacular Score")
                        TextField(
                            "Score",
                            value: .constant(recipe.spoonacularScore),
                            formatter: decimalFormatter
                        )
                        .keyboardType(.decimalPad)
                        .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Spoonacular Source URL")
                        TextField(
                            "Optional URL",
                            text: binding(for: .constant(recipe.spoonacularSourceUrl))
                        )
                        .lineLimit(1)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Edit Recipe") // Add a title if used in NavigationView
        }
    }

    // Formatters for numeric input
        private let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0 // No decimals for Int
            return formatter
        }()

        private let decimalFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 1 // Show at least one decimal place
            formatter.maximumFractionDigits = 4 // Allow reasonable precision
            return formatter
        }()

    // MARK: - Helper Binding Functions for Optionals

        /// Creates a non-optional String binding for an optional String.
        /// Treats nil as an empty string.
        private func binding(for optionalString: Binding<String?>) -> Binding<String> {
            Binding<String>(
                get: { optionalString.wrappedValue ?? "" },
                set: {
                    if $0.isEmpty {
                        optionalString.wrappedValue = nil // Set back to nil if empty
                    } else {
                        optionalString.wrappedValue = $0
                    }
                }
            )
        }

        /// Creates a String binding for an optional Int.
        /// Basic conversion - assumes valid integer input in the TextField.
        private func binding(for optionalInt: Binding<Int?>) -> Binding<String> {
            Binding<String>(
                get: {
                    guard let value = optionalInt.wrappedValue else { return "" }
                    return String(value)
                },
                set: {
                    optionalInt.wrappedValue = Int($0) // nil if conversion fails
                }
            )
        }

        /// Creates a String binding for an optional Double.
        /// Basic conversion - assumes valid double input in the TextField.
        private func binding(for optionalDouble: Binding<Double?>) -> Binding<String> {
            Binding<String>(
                get: {
                    guard let value = optionalDouble.wrappedValue else { return "" }
                    // Potentially use a formatter here for consistent display
                    return String(value)
                },
                set: {
                    optionalDouble.wrappedValue = Double($0) // nil if conversion fails
                }
            )
        }
    
}

#Preview {
    @Previewable @State var recipe: Recipe = loadCurryRecipe()
    EditFullRecipeView(recipe: $recipe)
}
