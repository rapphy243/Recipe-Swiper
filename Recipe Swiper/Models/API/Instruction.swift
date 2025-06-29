//
//  Instruction.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/23/25.
//

//  Query decoded with Gemini 2.5 Pro

import Foundation

// MARK: - AnalyzedInstruction
// Represents a step-by-step breakdown of the instructions.
struct AnalyzedInstruction: Codable, Hashable {
    var name: String
    var steps: [InstructionStep]
}

// MARK: - InstructionStep
// Represents a single step in the recipe instructions.
struct InstructionStep: Codable, Hashable {
    var number: Int
    var step: String
    var ingredients: [InstructionComponent]
    var equipment: [InstructionComponent]
    var length: InstructionLength?
}

// MARK: - InstructionComponent
// Represents either an ingredient or equipment used in a step.
// Using a shared struct as ingredient/equipment have the same fields here.
struct InstructionComponent: Codable, Hashable {
    var id: Int
    var name: String
    var localizedName: String
    var image: String?  // Image might be optional or just a filename
}

// MARK: - InstructionLength
// Represents the duration of an instruction step.
struct InstructionLength: Codable, Hashable {
    var number: Int
    var unit: String
}
