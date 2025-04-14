//
//  Recipe.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/14/25.
//

//  Query decoded with Gemini 2.5 Pro

import Foundation

// MARK: - RecipeResponse
struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

// MARK: - Recipe
// Represents a single recipe with its details.
struct Recipe: Codable {
    let id: Int
    let image: String? // Changed to String as per JSON, consider URL if needed
    let imageType: String?
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String? // Changed to String as per JSON, consider URL if needed
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let veryHealthy: Bool
    let cheap: Bool
    //let veryPopular: Bool
    //let sustainable: Bool
    //let lowFodmap: Bool
    //let weightWatcherSmartPoints: Int
    //let gaps: String
    let preparationMinutes: Int?
    let cookingMinutes: Int?
    //let aggregateLikes: Int
    let healthScore: Int // Consider Double if fractional scores are possible
    let creditsText: String
    let license: String?
    let sourceName: String
    let pricePerServing: Double
    let extendedIngredients: [ExtendedIngredient]
    let summary: String
    let cuisines: [String]
    let dishTypes: [String]
    let diets: [String]
    let occasions: [String]
    let instructions: String?
    let analyzedInstructions: [AnalyzedInstruction]
    let originalId: Int?
    let spoonacularScore: Double
    let spoonacularSourceUrl: String? // Changed to String as per JSON

    // If JSON keys differ significantly from Swift property names,
    // you might need a CodingKeys enum. Example:
    // enum CodingKeys: String, CodingKey {
    //     case id, image, imageType, title, readyInMinutes, servings
    //     case sourceUrl, vegetarian, vegan, glutenFree, dairyFree, veryHealthy
    //     case cheap, veryPopular, sustainable, lowFodmap
    //     case weightWatcherSmartPoints = "weightWatcherSmartPoints" // Example if needed
    //     case gaps, preparationMinutes, cookingMinutes, aggregateLikes
    //     case healthScore, creditsText, license, sourceName, pricePerServing
    //     case extendedIngredients, summary, cuisines, dishTypes, diets
    //     case occasions, instructions, analyzedInstructions, originalId
    //     case spoonacularScore
    //     case spoonacularSourceUrl = "spoonacularSourceUrl" // Example if needed
    // }
}

// MARK: - ExtendedIngredient
// Represents an ingredient with detailed information.
struct ExtendedIngredient: Codable {
    let id: Int
    let aisle: String?
    let image: String?
    let consistency: String? // Assuming String based on example
    let name: String
    let nameClean: String?
    let original: String
    let originalName: String
    let amount: Double
    let unit: String
    let meta: [String]? // Array of strings or potentially other types
    let measures: Measures
}

// MARK: - Measures
// Contains measurement details in US and metric units.
struct Measures: Codable {
    let us: MeasurementUnit
    let metric: MeasurementUnit
}

// MARK: - MeasurementUnit
// Represents a specific measurement unit with amount and names.
struct MeasurementUnit: Codable {
    let amount: Double
    let unitShort: String
    let unitLong: String
}

// MARK: - AnalyzedInstruction
// Represents a step-by-step breakdown of the instructions.
struct AnalyzedInstruction: Codable {
    let name: String
    let steps: [InstructionStep]
}

// MARK: - InstructionStep
// Represents a single step in the recipe instructions.
struct InstructionStep: Codable {
    let number: Int
    let step: String
    let ingredients: [InstructionComponent]
    let equipment: [InstructionComponent]
    let length: InstructionLength?
}

// MARK: - InstructionComponent
// Represents either an ingredient or equipment used in a step.
// Using a shared struct as ingredient/equipment have the same fields here.
struct InstructionComponent: Codable {
    let id: Int
    let name: String
    let localizedName: String
    let image: String? // Image might be optional or just a filename
}

// MARK: - InstructionLength
// Represents the duration of an instruction step.
struct InstructionLength: Codable {
    let number: Int
    let unit: String
}
