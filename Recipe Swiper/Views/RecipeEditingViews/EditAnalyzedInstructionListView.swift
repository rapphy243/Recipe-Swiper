//
//  InstuctionsSteps.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/29/25.
//
//  Generated with Gemini 2.5 Pro & Reworked with Claude 3.7 Sonnet Thinking

import SwiftData
import SwiftUI

struct EditAnalyzedInstructionListView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var analyzedInstructions: [AnalyzedInstructionModel]
    @Environment(\.editMode) var editMode

    var body: some View {
        NavigationStack {
            List {
                ForEach($analyzedInstructions.indices, id: \.self) { index in
                    EditableInstructionSetView(
                        instructionSet: analyzedInstructions[index],
                        modelContext: modelContext
                    )
                }
            }
        }
        .navigationTitle("Edit Instructions")
        .toolbar {
            EditButton()
        }
    }
}

// MARK: - Editable Instruction Set View
struct EditableInstructionSetView: View {
    @Bindable var instructionSet: AnalyzedInstructionModel
    let modelContext: ModelContext

    var body: some View {
        Section {
            let sortedSteps = instructionSet.steps.sorted { $0.number < $1.number }
            ForEach(sortedSteps, id: \.id) { step in
                EditableInstructionStepView(
                    step: step,
                    stepNumber: step.number
                )
            }
            .onDelete(perform: deleteStep)
            .onMove(perform: moveStep)

            Button {
                addStep()
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Step")
                }
            }
            .buttonStyle(.borderless)
        } header: {
            Text(instructionSet.name.isEmpty ? "Steps" : instructionSet.name)
        }
    }
    
    private func deleteStep(at offsets: IndexSet) {
        let sortedSteps = instructionSet.steps.sorted { $0.number < $1.number }
        for index in offsets {
            modelContext.delete(sortedSteps[index])
        }
        instructionSet.steps.removeAll { step in
            offsets.contains(sortedSteps.firstIndex(where: { $0.id == step.id }) ?? -1)
        }
        
        // Renumber remaining steps
        let remainingSteps = instructionSet.steps.sorted { $0.number < $1.number }
        for (index, step) in remainingSteps.enumerated() {
            step.number = index + 1
        }
    }

    private func moveStep(from source: IndexSet, to destination: Int) {
        var sortedSteps = instructionSet.steps.sorted { $0.number < $1.number }
        sortedSteps.move(fromOffsets: source, toOffset: destination)
        
        // Update all step numbers to match their new positions
        for (index, step) in sortedSteps.enumerated() {
            step.number = index + 1
        }
        
        // Update the original array to match the new order
        instructionSet.steps = sortedSteps
    }

    private func addStep() {
        let nextNumber = (instructionSet.steps.count) + 1

        // Create a new instruction step with empty arrays
        let newInstructionStep = InstructionStep(
            number: nextNumber,
            step: "",
            ingredients: [],
            equipment: [],
            length: nil
        )

        // Create the model with the instruction step
        let newStep = InstructionStepModel(from: newInstructionStep)
        
        // First insert into the model context
        modelContext.insert(newStep)
        
        // Then append to the steps array
        instructionSet.steps.append(newStep)
    }
}

// MARK: - Editable Instruction Step View
struct EditableInstructionStepView: View {
    @Bindable var step: InstructionStepModel
    @State private var lengthNumberString: String = ""
    @State private var lengthUnitString: String = ""
    let stepNumber: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text("\(stepNumber).")
                    .bold()
                    .padding(.top, 8)

                TextEditor(text: $step.step)
                    .frame(minHeight: 100, maxHeight: .infinity)
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
            .frame(minHeight: 120)
            .onAppear(perform: setupLengthFields)
            .onChange(of: lengthNumberString) {
                updateLengthBinding()
            }
            .onChange(of: lengthUnitString) {
                updateLengthBinding()
            }
            .onChange(of: step.length) {
                setupLengthFields()
            }
        }
        .padding(.vertical, 5)
    }

    private func setupLengthFields() {
        if let length = step.length {
            lengthNumberString = String(length.number)
            lengthUnitString = length.unit
        } else {
            lengthNumberString = ""
            lengthUnitString = ""
        }
    }

    private func updateLengthBinding() {
        if let number = Int(lengthNumberString), !lengthUnitString.isEmpty {
            if step.length == nil {
                step.length = InstructionLengthModel(
                    from: InstructionLength(
                        number: number,
                        unit: lengthUnitString
                    )
                )
            } else {
                step.length?.number = number
                step.length?.unit = lengthUnitString
            }
        } else {
            step.length = nil
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: AnalyzedInstructionModel.self,
        configurations: config
    )

    // Create preview data
    let recipe = loadCakeRecipe()
    var instructionModels: [AnalyzedInstructionModel] = []

    for instruction in recipe.analyzedInstructions {
        let model = AnalyzedInstructionModel(from: instruction)
        instructionModels.append(model)
        container.mainContext.insert(model)
    }

    return EditAnalyzedInstructionListView(
        analyzedInstructions: .constant(instructionModels)
    )
    .modelContainer(container)
}
