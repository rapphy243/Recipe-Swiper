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

    private func deleteInstructionSet(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(analyzedInstructions[index])
        }
        analyzedInstructions.remove(atOffsets: offsets)
    }

    private func addInstructionSet() {
        let newInstruction = AnalyzedInstructionModel(
            from: AnalyzedInstruction(name: "", steps: []))
        modelContext.insert(newInstruction)
        analyzedInstructions.append(newInstruction)
    }
}

// MARK: - Editable Instruction Set View
struct EditableInstructionSetView: View {
    @Bindable var instructionSet: AnalyzedInstructionModel
    let modelContext: ModelContext

    var body: some View {
        Section {
            ForEach($instructionSet.steps.indices, id: \.self) { stepIndex in
                EditableInstructionStepView(
                    step: instructionSet.steps[stepIndex],
                    stepNumber: stepIndex + 1
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
        for index in offsets {
            modelContext.delete(instructionSet.steps[index])
        }
        instructionSet.steps.remove(atOffsets: offsets)
    }

    private func moveStep(from source: IndexSet, to destination: Int) {
        instructionSet.steps.move(fromOffsets: source, toOffset: destination)
    }

    private func addStep() {
        let nextNumber = (instructionSet.steps.last?.number ?? 0) + 1

        // Create a new step model
        let newStep = InstructionStepModel(
            from: InstructionStep(
                number: nextNumber,
                step: "",
                ingredients: [],
                equipment: [],
                length: nil
            ))

        modelContext.insert(newStep)
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
                    .frame(height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
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
                    ))
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
        for: AnalyzedInstructionModel.self, configurations: config)

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
