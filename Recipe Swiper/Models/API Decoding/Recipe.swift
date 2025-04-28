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
    let image: String? // Changed to String as per JSON, consider URL if needed
    let imageType: String?
    let title: String
    let readyInMinutes: Int
    let servings: Int
    var rating: Int?
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
    static let empty = Recipe(
            id: -1, // Use -1 or 0 to indicate invalid/empty
            image: nil,
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
//            veryPopular: false,
//            sustainable: false,
//            lowFodmap: false,
//            weightWatcherSmartPoints: 0,
//            gaps: "",
            preparationMinutes: nil,
            cookingMinutes: nil,
//            aggregateLikes: 0,
            healthScore: 0,
            creditsText: "",
            license: nil,
            sourceName: "",
            pricePerServing: 0.0,
            extendedIngredients: [], // Empty array
            summary: "Recipe data could not be loaded.", // Or ""
            cuisines: [],
            dishTypes: [],
            diets: [],
            occasions: [],
            instructions: nil,
            analyzedInstructions: [], // Empty array
            originalId: nil,
            spoonacularScore: 0.0,
            spoonacularSourceUrl: nil
        )
    
    // https://www.hackingwithswift.com/example-code/language/how-to-conform-to-the-hashable-protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.title)
        hasher.combine(self.readyInMinutes)
        hasher.combine(self.servings)
    }
    
    // https://www.hackingwithswift.com/example-code/language/how-to-conform-to-the-equatable-protocol
    static func ==(lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.title == rhs.title && lhs.id == rhs.id
    }
}
