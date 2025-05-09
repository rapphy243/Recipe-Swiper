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
    @Environment(\.dismiss) private var dismiss
    @Bindable var recipe: RecipeModel
    @FocusState private var isTextEditorFocused: Bool
    @State private var isRefreshingImage = false
    @State private var showValidationAlert = false
    @State private var validationMessage = ""

    // Create a temporary copy for editing
    @State private var editedRecipe: RecipeModel

    init(recipe: RecipeModel) {
        self.recipe = recipe
        // Initialize the edited copy
        _editedRecipe = State(initialValue: recipe)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    HStack {
                        Text("Recipe ID")
                        Text("\(editedRecipe.id)")
                            .foregroundColor(.secondary)
                            .textSelection(.enabled)
                    }
                    HStack {
                        Text("Recipe Title:")
                        TextField("", text: $editedRecipe.title)
                    }

                    HStack {
                        Text("Image URL")
                        TextField(
                            "e.g., https://...",
                            text: $editedRecipe.image
                        )
                        .lineLimit(1)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                    }
                    Button(action: {
                        Task {
                            isRefreshingImage = true
                            await editedRecipe.fetchImage()
                            isRefreshingImage = false
                        }
                    }) {
                        HStack {
                            Text("Refresh Image")
                            if isRefreshingImage {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                        }
                    }
                    .disabled(isRefreshingImage)
                    .font(.headline)
                }

                Section("Timings & Servings") {
                    HStack {
                        Text("Ready in Minutes")
                        TextField(
                            "Minutes",
                            value: $editedRecipe.readyInMinutes,
                            formatter: numberFormatter
                        )
                        .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Servings")
                        TextField(
                            "Count",
                            value: $editedRecipe.servings,
                            formatter: numberFormatter
                        )
                        .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Preparation Minutes")
                        TextField(
                            "Optional",
                            value: $editedRecipe.preparationMinutes,
                            formatter: numberFormatter
                        )
                        .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Cooking Minutes")
                        TextField(
                            "Optional",
                            value: $editedRecipe.cookingMinutes,
                            formatter: numberFormatter
                        )
                        .keyboardType(.numberPad)
                    }
                }

                Section("Dietary Information") {
                    HStack {
                        Text("Cuisines")
                        Text(
                            "\(editedRecipe.cuisines.joined(separator: ", ").capitalized)"
                        )
                        .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Dish Types")
                        Text(
                            "\(editedRecipe.dishTypes.joined(separator: ", ").capitalized)"
                        )
                        .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Diets")
                        Text(
                            "\(editedRecipe.diets.joined(separator: ", ").capitalized)"
                        )
                        .foregroundColor(.secondary)
                    }
                }

                Section("Ingredients & Instructions") {
                    NavigationLink("Edit Ingredients") {
                        EditIngredientListView(
                            ingredients: $editedRecipe.extendedIngredients
                        )
                    }
                    NavigationLink("Edit Instructions") {
                        EditAnalyzedInstructionListView(
                            analyzedInstructions: $editedRecipe
                                .analyzedInstructions
                        )
                    }
                }

                Section("Summary") {
                    List {
                        TextField(
                            "Summary",
                            text: $editedRecipe.summary,
                            axis: .vertical
                        )
                        .focused($isTextEditorFocused)
                    }
                    .frame(height: 200)
                }

                Section("Other Details") {
                    HStack {
                        Text("Health Score")
                        TextField(
                            "Score",
                            value: $editedRecipe.healthScore,
                            formatter: numberFormatter
                        )
                        .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Estimated Price Per Serving")
                        TextField(
                            "Price",
                            value: $editedRecipe.pricePerServing,
                            formatter: decimalFormatter
                        )
                        .keyboardType(.decimalPad)
                    }
                }

                // Section for source and metadata
                Section("Source & Meta") {
                    HStack {
                        Text("Source Name: ")
                        TextField("Source Name", text: $editedRecipe.sourceName)
                    }
                    HStack {
                        Text("Source URL")
                        TextField(
                            "Optional URL",
                            text: $editedRecipe.sourceUrl
                        )
                        .lineLimit(1)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    }
                    HStack {
                        Text("Credits Text: ")
                        TextField(
                            "Source Name",
                            text: $editedRecipe.creditsText
                        )
                    }
                    HStack {
                        Text("Spoonacular Score")
                        Text(
                            String(
                                format: "%.2f",
                                editedRecipe.spoonacularScore
                            )
                        )
                        .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Spoonacular Source URL")
                        Text(editedRecipe.spoonacularSourceUrl ?? "N/A")
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .textSelection(.enabled)
                    }
                }
            }
            .navigationTitle("Edit Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if validateRecipe() {
                            saveChanges()
                            dismiss()
                        }
                    }
                }
            }
            .alert("Validation Error", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(validationMessage)
            }
        }
    }

    private func validateRecipe() -> Bool {
        // Validate title
        if editedRecipe.title.trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        {
            validationMessage = "Recipe title cannot be empty"
            showValidationAlert = true
            return false
        }

        // Validate image URL if provided
        if !editedRecipe.image.isEmpty {
            if URL(string: editedRecipe.image) == nil {
                validationMessage = "Invalid image URL format"
                showValidationAlert = true
                return false
            }
        }

        // Validate numeric fields
        if editedRecipe.readyInMinutes < 0 {
            validationMessage = "Ready in minutes cannot be negative"
            showValidationAlert = true
            return false
        }

        if editedRecipe.servings <= 0 {
            validationMessage = "Servings must be greater than 0"
            showValidationAlert = true
            return false
        }

        if editedRecipe.preparationMinutes < 0 {
            validationMessage = "Preparation minutes cannot be negative"
            showValidationAlert = true
            return false
        }

        if editedRecipe.cookingMinutes < 0 {
            validationMessage = "Cooking minutes cannot be negative"
            showValidationAlert = true
            return false
        }

        return true
    }

    private func saveChanges() {
        // Update the original recipe with edited values
        recipe.title = editedRecipe.title
        recipe.image = editedRecipe.image
        recipe.readyInMinutes = editedRecipe.readyInMinutes
        recipe.servings = editedRecipe.servings
        recipe.preparationMinutes = editedRecipe.preparationMinutes
        recipe.cookingMinutes = editedRecipe.cookingMinutes
        recipe.healthScore = editedRecipe.healthScore
        recipe.pricePerServing = editedRecipe.pricePerServing
        recipe.sourceName = editedRecipe.sourceName
        recipe.sourceUrl = editedRecipe.sourceUrl
        recipe.creditsText = editedRecipe.creditsText
        recipe.summary = editedRecipe.summary
        recipe.dateModified = Date()
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
