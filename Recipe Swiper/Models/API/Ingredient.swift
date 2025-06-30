//
//  Ingredient.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/23/25.
//

//  Query decoded with Gemini 2.5 Pro

// MARK: - ExtendedIngredient
// Represents an ingredient with detailed information.
import Foundation

struct ExtendedIngredient: Codable, Identifiable, Hashable {
    var id: Int
    var aisle: String?
    var image: String?
    var consistency: String?  // Assuming String based on example
    var name: String
    var nameClean: String?
    var original: String
    var originalName: String
    var amount: Double
    var unit: String
    var meta: [String]?  // Array of strings or potentially other types
    var measures: Measures
}
