//
//  InstuctionsSteps.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/24/25.
//

import SwiftUI

struct InstructionsSteps: View {
    @Binding var recipe: Recipe
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack {
            Text("Instructions")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            DisclosureGroup("", isExpanded: $isExpanded) {
                VStack(alignment: .leading) {
                    if !recipe.analyzedInstructions.isEmpty {
                        ForEach(recipe.analyzedInstructions, id: \.self) { instructionSet in
                            if !instructionSet.name.isEmpty {
                                Text(instructionSet.name)
                                    .font(.subheadline)
                                    .padding(.bottom, 2)
                            }
                            ForEach(instructionSet.steps, id: \.number) { step in
                                HStack(alignment: .top) {
                                    Text("\(step.number).")
                                        .bold()
                                        .frame(width: 25, alignment: .leading)
                                    Text(step.step)
                                }
                                .padding(.vertical, 3)
                                if step.number != instructionSet.steps.last?.number {
                                    Divider()
                                }
                            }
                        }
                    } else if let rawInstructions = recipe.instructions, !rawInstructions.isEmpty {
                        Text(rawInstructions
                            .replacingOccurrences(of: "<ol>", with: "")
                            .replacingOccurrences(of: "</ol>", with: "")
                            .replacingOccurrences(of: "<li>", with: "\n• ")
                            .replacingOccurrences(of: "</li>", with: "")
                            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                            .trimmingCharacters(in: .whitespacesAndNewlines))
                        .padding(.top, 4)
                    } else {
                        Text("No instructions available for this recipe.")
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    }
                }
                .padding(.leading)
                .padding(.top, 5)
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var recipe = loadCurryRecipe()
    InstructionsSteps(recipe: $recipe)
}
