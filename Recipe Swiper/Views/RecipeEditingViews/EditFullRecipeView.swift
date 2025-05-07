//
//  EditFullRecipe.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/29/25.
//
//  Generated with Gemini 2.5 Pro & Reworked with Claude 3.7 Sonnet Thinking

// "In console there is an error "Unable to simultaneously satisfy constraints.... " this is fine apparently https://www.reddit.com/r/SwiftUI/comments/1dxxjh5/unable_to_simultaneously_satisfy_constraints/
import SwiftData
import SwiftUI

struct EditFullRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var recipe: RecipeModel
    @FocusState private var isTextEditorFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    HStack {
                        Text("Recipe ID")
                        Text("\(recipe.id)")
                            .foregroundColor(.secondary)
                            .textSelection(.enabled)
                    }
                    HStack {
                        Text("Recipe Title:")
                        TextField("", text: $recipe.title)
                    }

                    HStack {
                        Text("Image URL")
                        TextField(
                            "e.g., https://...",
                            text: $recipe.image
                        )
                        .lineLimit(1)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    }
                    Button("Refresh Image") {
                        Task {
                            await recipe.fetchImage()
                        }
                    }
                    .font(.headline)
                }

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
                            value: $recipe.preparationMinutes,
                            formatter: numberFormatter
                        )
                        .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Cooking Minutes")
                        TextField(
                            "Optional",
                            value: $recipe.cookingMinutes,
                            formatter: numberFormatter
                        )
                        .keyboardType(.numberPad)
                    }
                }

                Section("Dietary Information") {
                    HStack {
                        Text("Cuisines")
                        Text("\(recipe.cuisines.joined(separator: ", ").capitalized)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Dish Types")
                        Text("\(recipe.dishTypes.joined(separator: ", ").capitalized)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Diets")
                        Text("\(recipe.diets.joined(separator: ", ").capitalized)")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Ingredients & Instructions") {
                    NavigationLink("Edit Ingredients") {
                        EditIngredientListView(
                            ingredients: $recipe.extendedIngredients
                        )
                    }
                    NavigationLink("Edit Instructions") {
                        EditAnalyzedInstructionListView(
                            analyzedInstructions: $recipe.analyzedInstructions
                        )
                    }
                }

                Section("Summary") {
                    List {
                        TextField("Summary", text: $recipe.summary, axis: .vertical)
                            .focused($isTextEditorFocused)
                    }
                    .frame(height: 200)
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
                        Text("Estimated Price Per Serving")
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
                            text: $recipe.sourceUrl
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
                        Text(String(format: "%.2f", recipe.spoonacularScore))
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Spoonacular Source URL")
                        Text(recipe.spoonacularSourceUrl ?? "N/A")
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .textSelection(.enabled)
                    }
                }
            }
            .navigationTitle("Edit Recipe")
        }
    }

    // Formatters for numeric input
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0  // No decimals for Int
        return formatter
    }()

    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1  // Show at least one decimal place
        formatter.maximumFractionDigits = 4  // Allow reasonable precision
        return formatter
    }()
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: RecipeModel.self,
        configurations: config
    )
    let recipe = RecipeModel(from: loadCurryRecipe(), isDiscarded: false)
    container.mainContext.insert(recipe)

    return EditFullRecipeView(recipe: recipe)
        .modelContainer(container)
}
