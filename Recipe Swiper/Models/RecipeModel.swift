//
//  RecipeModel.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/23/25.
//
//  Generated with Claude 3.5 Sonnet

import Foundation
import SwiftData

@Model
final class RecipeModel {
    var id: Int
    var image: String?
    var imageType: String?
    var title: String
    var readyInMinutes: Int
    var servings: Int
    var sourceUrl: String?
    var vegetarian: Bool
    var vegan: Bool
    var glutenFree: Bool
    var dairyFree: Bool
    var veryHealthy: Bool
    var cheap: Bool
    var preparationMinutes: Int?
    var cookingMinutes: Int?
    var healthScore: Int
    var creditsText: String
    var license: String?
    var sourceName: String
    var pricePerServing: Double
    var extendedIngredients: [ExtendedIngredientModel]
    var summary: String
    var cuisines: [String]
    var dishTypes: [String]
    var diets: [String]
    var occasions: [String]
    var instructions: String?
    var analyzedInstructions: [AnalyzedInstructionModel]
    var originalId: Int?
    var spoonacularScore: Double
    var spoonacularSourceUrl: String?
    
    init(from recipe: Recipe) {
        self.id = recipe.id
        self.image = recipe.image
        self.imageType = recipe.imageType
        self.title = recipe.title
        self.readyInMinutes = recipe.readyInMinutes
        self.servings = recipe.servings
        self.sourceUrl = recipe.sourceUrl
        self.vegetarian = recipe.vegetarian
        self.vegan = recipe.vegan
        self.glutenFree = recipe.glutenFree
        self.dairyFree = recipe.dairyFree
        self.veryHealthy = recipe.veryHealthy
        self.cheap = recipe.cheap
        self.preparationMinutes = recipe.preparationMinutes
        self.cookingMinutes = recipe.cookingMinutes
        self.healthScore = recipe.healthScore
        self.creditsText = recipe.creditsText
        self.license = recipe.license
        self.sourceName = recipe.sourceName
        self.pricePerServing = recipe.pricePerServing
        self.extendedIngredients = recipe.extendedIngredients.map(ExtendedIngredientModel.init)
        self.summary = recipe.summary
        self.cuisines = recipe.cuisines
        self.dishTypes = recipe.dishTypes
        self.diets = recipe.diets
        self.occasions = recipe.occasions
        self.instructions = recipe.instructions
        self.analyzedInstructions = recipe.analyzedInstructions.map(AnalyzedInstructionModel.init)
        self.originalId = recipe.originalId
        self.spoonacularScore = recipe.spoonacularScore
        self.spoonacularSourceUrl = recipe.spoonacularSourceUrl
    }
}

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

@Model
final class MeasuresModel {
    var us: MeasurementUnitModel
    var metric: MeasurementUnitModel
    
    init(from measures: Measures) {
        self.us = MeasurementUnitModel(from: measures.us)
        self.metric = MeasurementUnitModel(from: measures.metric)
    }
}

@Model
final class MeasurementUnitModel {
    var amount: Double
    var unitShort: String
    var unitLong: String
    
    init(from unit: MeasurementUnit) {
        self.amount = unit.amount
        self.unitShort = unit.unitShort
        self.unitLong = unit.unitLong
    }
}

@Model
final class AnalyzedInstructionModel {
    var name: String
    var steps: [InstructionStepModel]
    
    init(from instruction: AnalyzedInstruction) {
        self.name = instruction.name
        self.steps = instruction.steps.map(InstructionStepModel.init)
    }
}

@Model
final class InstructionStepModel {
    var number: Int
    var step: String
    var ingredients: [InstructionComponentModel]
    var equipment: [InstructionComponentModel]
    var length: InstructionLengthModel?
    
    init(from step: InstructionStep) {
        self.number = step.number
        self.step = step.step
        self.ingredients = step.ingredients.map(InstructionComponentModel.init)
        self.equipment = step.equipment.map(InstructionComponentModel.init)
        self.length = step.length.map(InstructionLengthModel.init)
    }
}

@Model
final class InstructionComponentModel {
    var id: Int
    var name: String
    var localizedName: String
    var image: String?
    
    init(from component: InstructionComponent) {
        self.id = component.id
        self.name = component.name
        self.localizedName = component.localizedName
        self.image = component.image
    }
}

@Model
final class InstructionLengthModel {
    var number: Int
    var unit: String
    
    init(from length: InstructionLength) {
        self.number = length.number
        self.unit = length.unit
    }
}
