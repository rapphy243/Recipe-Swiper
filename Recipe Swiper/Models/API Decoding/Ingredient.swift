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

    static func newEmpty(id: Int) -> ExtendedIngredient {
        return ExtendedIngredient(
            id: id,  // Use a temporary ID (e.g., 0 or negative)
            aisle: nil,
            image: nil,
            consistency: nil,
            name: "",  // Start empty
            nameClean: nil,
            original: "",  // Start empty
            originalName: "",  // Start empty
            amount: 1.0,  // Default amount
            unit: "",  // Start empty
            meta: nil,
            measures: Measures.empty  // Need default Measures
        )
    }
}
