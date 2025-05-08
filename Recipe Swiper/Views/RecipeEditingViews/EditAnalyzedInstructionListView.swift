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
    @State private var showValidationAlert = false
    @State private var validationMessage = ""
    @State private var showAddInstructionSet = false
    @State private var newInstructionSetName = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach($analyzedInstructions.indices, id: \.self) { index in
                    EditableInstructionSetView(
                        instructionSet: analyzedInstructions[index],
                        modelContext: modelContext,
                        onValidationError: { message in
                            validationMessage = message
                            showValidationAlert = true
                        }
                    )
                }
                .onDelete(perform: deleteInstructionSet)
                .onMove(perform: moveInstructionSet)

                Button {
                    showAddInstructionSet = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Instruction Set")
                    }
                }
                .buttonStyle(.borderless)
            }
            .navigationTitle("Edit Instructions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .alert("Validation Error", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(validationMessage)
            }
            .sheet(isPresented: $showAddInstructionSet) {
                NavigationView {
                    Form {
                        Section(header: Text("New Instruction Set")) {
                            TextField(
                                "Name (Optional)",
                                text: $newInstructionSetName
                            )
                        }
                    }
                    .navigationTitle("Add Instructions")
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            showAddInstructionSet = false
                        },
                        trailing: Button("Add") {
                            addInstructionSet()
                            showAddInstructionSet = false
                        }
                    )
                }
            }
        }
    }

    private func deleteInstructionSet(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(analyzedInstructions[index])
        }
        analyzedInstructions.remove(atOffsets: offsets)
    }

    private func moveInstructionSet(from source: IndexSet, to destination: Int)
    {
        analyzedInstructions.move(fromOffsets: source, toOffset: destination)
    }

    private func addInstructionSet() {
        let newInstructionStep = AnalyzedInstruction(
            name: newInstructionSetName,
            steps: []
        )
        let newSet = AnalyzedInstructionModel(from: newInstructionStep)
        modelContext.insert(newSet)
        analyzedInstructions.append(newSet)
        newInstructionSetName = ""
    }
}

// MARK: - Editable Instruction Set View
struct EditableInstructionSetView: View {
    @Bindable var instructionSet: AnalyzedInstructionModel
    let modelContext: ModelContext
    let onValidationError: (String) -> Void
    @State private var editingSetName = false
    @FocusState private var isSetNameFocused: Bool

    var body: some View {
        Section {
            if editingSetName {
                TextField("Set Name", text: $instructionSet.name)
                    .focused($isSetNameFocused)
                    .onSubmit {
                        editingSetName = false
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 4)
            }

            let sortedSteps = instructionSet.steps.sorted {
                $0.number < $1.number
            }
            ForEach(sortedSteps, id: \.id) { step in
                EditableInstructionStepView(
                    step: step,
                    stepNumber: step.number,
                    onValidationError: onValidationError
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
            HStack {
                Text(
                    instructionSet.name.isEmpty ? "Steps" : instructionSet.name
                )
                Spacer()
                Button {
                    editingSetName = true
                    isSetNameFocused = true
                } label: {
                    Image(systemName: "pencil.circle")
                        .foregroundColor(.blue)
                }
            }
        }
    }

    private func deleteStep(at offsets: IndexSet) {
        let sortedSteps = instructionSet.steps.sorted { $0.number < $1.number }
        for index in offsets {
            modelContext.delete(sortedSteps[index])
        }
        instructionSet.steps.removeAll { step in
            offsets.contains(
                sortedSteps.firstIndex(where: { $0.id == step.id }) ?? -1
            )
        }

        // Renumber remaining steps
        let remainingSteps = instructionSet.steps.sorted {
            $0.number < $1.number
        }
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
        let newInstructionStep = InstructionStep(
            number: nextNumber,
            step: "",
            ingredients: [],
            equipment: [],
            length: nil
        )

        let newStep = InstructionStepModel(from: newInstructionStep)
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
    let onValidationError: (String) -> Void
    @FocusState private var isStepTextFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text("\(stepNumber).")
                    .bold()
                    .padding(.top, 8)

                TextEditor(text: $step.step)
                    .focused($isStepTextFocused)
                    .frame(minHeight: 100, maxHeight: .infinity)
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .onChange(of: step.step) {
                        validateStep()
                    }
            }
            .frame(minHeight: 120)

            // Step Length (Optional)
            HStack {
                Text("Duration:")
                    .font(.caption)
                    .foregroundColor(.secondary)

                TextField("Number", text: $lengthNumberString)
                    .keyboardType(.numberPad)
                    .frame(width: 60)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Unit (e.g., minutes)", text: $lengthUnitString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
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

    private func validateStep() {
        if step.step.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onValidationError("Step instructions cannot be empty")
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
