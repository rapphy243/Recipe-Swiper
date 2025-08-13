//
//  EditableRecipePageView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 8/13/25.
//

import SwiftUI
import SwiftData

struct EditableRecipePageView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var recipe: RecipeModel

    @State private var didLoadInitialValues = false

    @State private var titleText: String = ""
    @State private var summaryText: String = ""
    @State private var ratingValue: Int = 0
    @State private var readyInMinutesValue: Int = 0
    @State private var servingsValue: Int = 1
    @State private var sourceUrlText: String = ""
    @State private var healthScoreValue: Int = 0
    @State private var veganToggle: Bool = false
    @State private var vegetarianToggle: Bool = false
    @State private var glutenFreeToggle: Bool = false
    @State private var dairyFreeToggle: Bool = false

    var body: some View {
        Form {
            Section("Basics") {
                TextField("Title", text: $titleText)
                Stepper("Rating: \(ratingValue)", value: $ratingValue, in: 0...10)
                Stepper(
                    "Ready in minutes: \(readyInMinutesValue)",
                    value: $readyInMinutesValue,
                    in: 0...600,
                    step: 5
                )
                Stepper("Servings: \(servingsValue)", value: $servingsValue, in: 1...100)
            }

            Section("Health & Diet") {
                Stepper("Health score: \(healthScoreValue)", value: $healthScoreValue, in: 0...100)
                Toggle("Vegetarian", isOn: $vegetarianToggle)
                Toggle("Vegan", isOn: $veganToggle)
                Toggle("Gluten free", isOn: $glutenFreeToggle)
                Toggle("Dairy free", isOn: $dairyFreeToggle)
            }

            Section("Links") {
                TextField("Source URL", text: $sourceUrlText)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section("Summary") {
                TextEditor(text: $summaryText)
                    .frame(minHeight: 120)
            }

            EditableIngredientsSection(recipe: recipe)

            EditableInstructionsSection(recipe: recipe)
        }
        .navigationTitle("Edit Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { saveChanges() }
            }
        }
        .onAppear { loadInitialValuesIfNeeded() }
    }

    private func loadInitialValuesIfNeeded() {
        guard !didLoadInitialValues else { return }
        didLoadInitialValues = true
        titleText = recipe.title
        summaryText = recipe.summary
        ratingValue = recipe.rating
        readyInMinutesValue = recipe.readyInMinutes
        servingsValue = recipe.servings
        sourceUrlText = recipe.sourceUrl ?? ""
        healthScoreValue = recipe.healthScore
        veganToggle = recipe.vegan
        vegetarianToggle = recipe.vegetarian
        glutenFreeToggle = recipe.glutenFree
        dairyFreeToggle = recipe.dairyFree
    }

    private func saveChanges() {
        recipe.title = titleText
        recipe.summary = summaryText
        recipe.rating = ratingValue
        recipe.readyInMinutes = readyInMinutesValue
        recipe.servings = servingsValue
        recipe.sourceUrl = sourceUrlText.isEmpty ? nil : sourceUrlText
        recipe.healthScore = healthScoreValue
        recipe.vegan = veganToggle
        recipe.vegetarian = vegetarianToggle
        recipe.glutenFree = glutenFreeToggle
        recipe.dairyFree = dairyFreeToggle
        recipe.dateModified = Date()
        do {
            try modelContext.save()
        } catch {
            print("Failed to save recipe edits: \(error)")
        }
        dismiss()
    }
}

#Preview {
    EditableRecipePageView(recipe: RecipeModel(from: Recipe.Cake))
}
