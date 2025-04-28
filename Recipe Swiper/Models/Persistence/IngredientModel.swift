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
    var id: Int
    var aisle: String?
    var image: String?
    var consistency: String?
    var name: String
    var nameClean: String?
    var original: String
    var originalName: String
    var amount: Double
    var unit: String
    var meta: [String]?
    @Relationship(deleteRule: .cascade)
    var measures: MeasuresModel
    
    init(from ingredient: ExtendedIngredient) {
        self.id = ingredient.id
        self.aisle = ingredient.aisle
        self.image = ingredient.image
        self.consistency = ingredient.consistency
        self.name = ingredient.name
        self.nameClean = ingredient.nameClean
        self.original = ingredient.original
        self.originalName = ingredient.originalName
        self.amount = ingredient.amount
        self.unit = ingredient.unit
        self.meta = ingredient.meta
        self.measures = MeasuresModel(from: ingredient.measures)
    }
}
