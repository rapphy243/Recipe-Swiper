//
//  InstructionsModel.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/23/25.
//
//  Generated with Claude 3.5 Sonnet

import Foundation
import SwiftData

@Model
final class AnalyzedInstructionModel {
    var name: String
    @Relationship(deleteRule: .cascade)
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
    @Relationship(deleteRule: .cascade)
    var ingredients: [InstructionComponentModel]
    @Relationship(deleteRule: .cascade)
    var equipment: [InstructionComponentModel]
    @Relationship(deleteRule: .cascade)
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
