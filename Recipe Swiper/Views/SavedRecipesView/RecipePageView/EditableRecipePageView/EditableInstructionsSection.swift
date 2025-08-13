//
//  EditableInstructionsSection.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 8/13/25.
//

import SwiftUI
import SwiftData

struct EditableInstructionsSection: View {
    @Bindable var recipe: RecipeModel

    var body: some View {
        Section("Instructions") {
            if recipe.analyzedInstructions.isEmpty {
                Text("No instruction sets.")
                    .foregroundColor(.secondary)
            } else {
                ForEach($recipe.analyzedInstructions) { $set in
                    InstructionSetEditor(instructionSet: $set) {
                        if let idx = recipe.analyzedInstructions.firstIndex(where: { $0 === set }) {
                            recipe.analyzedInstructions.remove(at: idx)
                        }
                    }
                }
            }
            Button {
                addInstructionSet()
            } label: {
                Label("Add Instruction Set", systemImage: "plus.circle")
            }
        }
    }

    private func addInstructionSet() {
        // Create a minimal API struct to feed the model init
        let newStep = InstructionStep(
            number: 1,
            step: "",
            ingredients: [],
            equipment: [],
            length: nil
        )
        let newSet = AnalyzedInstruction(name: "", steps: [newStep])
        let model = AnalyzedInstructionModel(from: newSet)
        recipe.analyzedInstructions.append(model)
    }
}

private struct InstructionSetEditor: View {
    @Binding var instructionSet: AnalyzedInstructionModel
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                TextField("Section name (optional)", text: $instructionSet.name)
                Button(role: .destructive) { onDelete() } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.borderless)
            }

            if instructionSet.steps.isEmpty {
                Text("No steps in this section.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } else {
                ForEach($instructionSet.steps) { $step in
                    StepRow(step: $step, onDelete: {
                        if let idx = instructionSet.steps.firstIndex(where: { $0.id == step.id }) {
                            instructionSet.steps.remove(at: idx)
                            renumberSteps()
                        }
                    }, onNumberChange: {
                        renumberSteps()
                    })
                }
            }

            Button {
                addStep()
            } label: {
                Label("Add Step", systemImage: "plus")
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 4)
    }

    private func addStep() {
        let nextNumber = (instructionSet.steps.map { $0.number }.max() ?? 0) + 1
        let newStep = InstructionStep(
            number: nextNumber,
            step: "",
            ingredients: [],
            equipment: [],
            length: nil
        )
        let model = InstructionStepModel(from: newStep)
        instructionSet.steps.append(model)
        renumberSteps()
    }

    private func renumberSteps() {
        // Sort by number then rewrite to be 1..n without duplicates
        let sorted = instructionSet.steps.sorted { $0.number < $1.number }
        for (index, step) in sorted.enumerated() {
            step.number = index + 1
        }
        instructionSet.steps = sorted
    }
}

private struct StepRow: View {
    @Binding var step: InstructionStepModel
    var onDelete: () -> Void
    var onNumberChange: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Stepper("Step #\(step.number)", value: $step.number, in: 1...500)
                    .onChange(of: step.number) { _, _ in onNumberChange() }
                Button(role: .destructive) { onDelete() } label: {
                    Image(systemName: "minus.circle")
                }
                .buttonStyle(.borderless)
            }
            TextField("Instruction text", text: $step.step, axis: .vertical)
                .lineLimit(2...6)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    EditableInstructionsSection(recipe: RecipeModel(from: Recipe.Cake))
}


