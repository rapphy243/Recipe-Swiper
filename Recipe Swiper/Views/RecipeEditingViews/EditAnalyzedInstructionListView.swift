//
//  InstuctionsSteps.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/29/25.
//
//  Generated with Gemini 2.5 Pro

import SwiftUI

struct EditAnalyzedInstructionListView: View {
    @Binding var analyzedInstructions: [AnalyzedInstruction]
    @Environment(\.editMode) var editMode  // To enable move/delete controls
    var body: some View {
        NavigationStack {
            List {
                ForEach($analyzedInstructions.indices, id: \.self) { index in
                    EditableInstructionSetView(
                        instructionSet: $analyzedInstructions[index]
                    )
                }
            }
        }
        .navigationTitle("Edit Instructions")
        .toolbar {
            EditButton()  // Adds standard Edit/Done button for List controls
        }
    }
}

// MARK: - Editable Instruction Set View
struct EditableInstructionSetView: View {
    @Binding var instructionSet: AnalyzedInstruction

    var body: some View {
        Section {
            ForEach($instructionSet.steps.indices, id: \.self) { stepIndex in
                // Pass binding to the specific step
                EditableInstructionStepView(
                    step: $instructionSet.steps[stepIndex],
                    stepNumber: stepIndex + 1  // Display number based on index
                )
            }
            .onDelete(perform: deleteStep)
            .onMove(perform: moveStep)

            // Button to add a new step to this set
            Button {
                addStep()
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Step")
                }
            }
            .buttonStyle(.borderless)  // Make it look less prominent if desired

        } header: {
            // Use a generic header or the name if available
            Text(instructionSet.name.isEmpty ? "Steps" : instructionSet.name)
        }
    }

    // Function to delete steps
    private func deleteStep(at offsets: IndexSet) {
        instructionSet.steps.remove(atOffsets: offsets)
        // Note: Step numbers will automatically adjust visually
        // because we display index + 1
    }

    // Function to move steps
    private func moveStep(from source: IndexSet, to destination: Int) {
        instructionSet.steps.move(fromOffsets: source, toOffset: destination)
        // Note: Step numbers will automatically adjust visually
    }

    // Function to add a new step
    private func addStep() {
        let nextNumber = (instructionSet.steps.last?.number ?? 0) + 1
        let newStep = InstructionStep(
            number: nextNumber,  // Assign next logical number
            step: "",  // Start with empty text
            ingredients: [],
            equipment: [],
            length: nil
        )
        instructionSet.steps.append(newStep)
    }
}

// MARK: - Editable Instruction Step View
struct EditableInstructionStepView: View {
    @Binding var step: InstructionStep
    @State private var lengthNumberString: String = ""
    @State private var lengthUnitString: String = ""
    let stepNumber: Int  // Displayed number (index + 1)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Display Step Number and Editable Text
            HStack(alignment: .top) {
                Text("\(stepNumber).")
                    .bold()
                    .padding(.top, 8)

                // Use TextEditor for multi-line step instructions
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
            // Also update fields if binding changes externally (e.g., loaded data)
            .onChange(of: step.length) {
                setupLengthFields()
            }

        }
        .padding(.vertical, 5)
    }

    // Initialize state variables from the binding on appear
    private func setupLengthFields() {
        if let length = step.length {
            lengthNumberString = String(length.number)
            lengthUnitString = length.unit
        } else {
            lengthNumberString = ""
            lengthUnitString = ""
        }
    }

    // Update the binding when state variables change
    private func updateLengthBinding() {  // Removed the unused parameter
        if let number = Int(lengthNumberString), !lengthUnitString.isEmpty {
            // Only update if both number is valid and unit is not empty
            if step.length == nil {  // Create if it doesn't exist
                step.length = InstructionLength(
                    number: number,
                    unit: lengthUnitString
                )
            } else {  // Modify existing
                step.length?.number = number
                step.length?.unit = lengthUnitString
            }
        } else {
            // If input is invalid or incomplete, set binding to nil
            step.length = nil
        }
    }
}

#Preview {
    @Previewable @State var recipe = loadCakeRecipe()
    EditAnalyzedInstructionListView(
        analyzedInstructions: $recipe.analyzedInstructions
    )
}
