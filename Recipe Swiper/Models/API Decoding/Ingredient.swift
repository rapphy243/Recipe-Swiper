//
//  Ingredient.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/23/25.
//

//  Query decoded with Gemini 2.5 Pro

import Foundation

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
