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
struct AnalyzedInstruction: Codable {
    let name: String
    let steps: [InstructionStep]
}

// MARK: - InstructionStep
// Represents a single step in the recipe instructions.
struct InstructionStep: Codable {
    let number: Int
    let step: String
    let ingredients: [InstructionComponent]
    let equipment: [InstructionComponent]
    let length: InstructionLength?
}

// MARK: - InstructionComponent
// Represents either an ingredient or equipment used in a step.
// Using a shared struct as ingredient/equipment have the same fields here.
struct InstructionComponent: Codable {
    let id: Int
    let name: String
    let localizedName: String
    let image: String? // Image might be optional or just a filename
}

// MARK: - InstructionLength
// Represents the duration of an instruction step.
struct InstructionLength: Codable {
    let number: Int
    let unit: String
}
