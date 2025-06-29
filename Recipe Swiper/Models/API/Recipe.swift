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
struct Recipe: Codable, Hashable, Equatable {
    let id: Int
    let image: String?
    let imageType: String?
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String?
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let veryHealthy: Bool
    let cheap: Bool
    let veryPopular: Bool
    let sustainable: Bool
    let lowFodmap: Bool
    let weightWatcherSmartPoints: Int
    let gaps: String
    let preparationMinutes: Int?
    let cookingMinutes: Int?
    let aggregateLikes: Int
    let healthScore: Int
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
    let spoonacularSourceUrl: String?
    
    static let empty = Recipe(
        id: -1,
        image: "https://picsum.photos/200/300", // Returns a random image, used to make sure Persistence Model doesn't try to get a null image
        imageType: "",
        title: "Not Found",
        readyInMinutes: 0,
        servings: 0,
        sourceUrl: nil,
        vegetarian: false,
        vegan: false,
        glutenFree: false,
        dairyFree: false,
        veryHealthy: false,
        cheap: false,
        veryPopular: false,
        sustainable: false,
        lowFodmap: false,
        weightWatcherSmartPoints: 0,
        gaps: "",
        preparationMinutes: nil,
        cookingMinutes: nil,
        aggregateLikes: 0,
        healthScore: 0,
        creditsText: "",
        license: nil,
        sourceName: "",
        pricePerServing: 0.0,
        extendedIngredients: [],
        summary: "Recipe data could not be loaded.",
        cuisines: [],
        dishTypes: [],
        diets: [],
        occasions: [],
        instructions: nil,
        analyzedInstructions: [],
        originalId: nil,
        spoonacularScore: 0.0,
        spoonacularSourceUrl: nil
    )
}
