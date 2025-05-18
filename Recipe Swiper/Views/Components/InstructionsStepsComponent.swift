//
//  InstuctionsSteps.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/24/25.
//

import SwiftUI

struct InstructionsStepsComponent: View {
    @Bindable var recipe: RecipeModel
    @State private var isExpanded: Bool = true

    var body: some View {
        VStack {
            DisclosureGroup("", isExpanded: $isExpanded) {
                VStack(alignment: .leading, spacing: 10) {
                    if !recipe.analyzedInstructions.isEmpty {
                        ForEach(recipe.analyzedInstructions, id: \.self) {
                            instructionSet in
                            if !instructionSet.name.isEmpty {
                                Text(instructionSet.name)
                                    .font(.headline)
                                    .padding(.bottom, 2)
                                    .padding(.top, 5)
                            }

                            let sortedSteps = instructionSet.steps.sorted {
                                $0.number < $1.number
                            }

                            ForEach(sortedSteps, id: \.number) { step in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("\(step.number).")
                                        .bold()
                                        .frame(width: 30, alignment: .trailing)
                                    Text(step.step)
                                        .frame(
                                            maxWidth: .infinity,
                                            alignment: .leading
                                        )
                                }
                                .padding(.vertical, 4)

                                // 3. Compare the current step's number to the
                                //    last step's number *from the sorted array*
                                if step.number != sortedSteps.last?.number {
                                    Divider()
                                }
                            }
                        }
                    } else if let rawInstructions = recipe.instructions,
                        !rawInstructions.isEmpty
                    {
                        Text(
                            rawInstructions
                                .replacingOccurrences(of: "<ol>", with: "")
                                .replacingOccurrences(of: "</ol>", with: "")
                                .replacingOccurrences(of: "<li>", with: "\n• ")
                                .replacingOccurrences(of: "</li>", with: "")
                                .replacingOccurrences(
                                    of: "<[^>]+>",
                                    with: "",
                                    options: .regularExpression,
                                    range: nil
                                )
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        .padding(.top, 4)
                    } else {
                        Text("No instructions available for this recipe.")
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var recipe = RecipeModel(from: loadCurryRecipe())
    InstructionsStepsComponent(recipe: recipe)
}
