//
//  Ingredient.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/23/25.
//
//  Generated with Claude 3.5 Sonnet

import Foundation
import SwiftData

@Model
final class ExtendedIngredientModel {
    var aisle: String?
    var image: String?
    var consistency: String?
    var name: String
    var nameClean: String?
    var original: String
    var originalName: String
    var amount: Double
    var unit: String
    @Attribute(.externalStorage)
    private var metaData: Data?
    
    var meta: [String]? {
        get {getStringArray(from: metaData) ?? []}
        set {metaData = encodeStringArray(newValue!)}
    }
    @Relationship(deleteRule: .cascade)
    var measures: MeasuresModel
    
    init(from ingredient: ExtendedIngredient) {
        self.aisle = ingredient.aisle
        self.image = ingredient.image
        self.consistency = ingredient.consistency
        self.name = ingredient.name
        self.nameClean = ingredient.nameClean
        self.original = ingredient.original
        self.originalName = ingredient.originalName
        self.amount = ingredient.amount
        self.unit = ingredient.unit
        self.metaData = try? JSONEncoder().encode(ingredient.meta)
        self.measures = MeasuresModel(from: ingredient.measures)
    }
    
    // Helper methods for conversion
    private func encodeStringArray(_ array: [String]) -> Data? {
        try? JSONEncoder().encode(array)
    }
    private func getStringArray(from data: Data?) -> [String]? {
        guard let data = data else {
            return nil
        }
        return try? JSONDecoder().decode([String].self, from: data)
    }
}
