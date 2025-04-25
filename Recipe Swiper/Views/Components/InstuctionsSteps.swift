//
//  InstuctionsSteps.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/24/25.
//

import SwiftUI

struct InstructionsSteps: View {
    @Binding var recipe: Recipe
    // State to control the expansion of the DisclosureGroup
    @State private var isExpanded: Bool = false

    var body: some View {
        // Use DisclosureGroup to make the content expandable/collapsible
        DisclosureGroup(isExpanded: $isExpanded) {
            // The content that gets shown/hidden is the List
            // Use a VStack to contain the List to avoid layout issues within DisclosureGroup
            VStack(alignment: .leading) {
                // Check if analyzed instructions exist
                if !recipe.analyzedInstructions.isEmpty {
                    // Iterate through each set of analyzed instructions
                    ForEach(recipe.analyzedInstructions, id: \.self) { instructionSet in
                        // Optional: Add a sub-header if the instruction set has a name
                        if !instructionSet.name.isEmpty {
                            Text(instructionSet.name)
                                .font(.subheadline)
                                .padding(.bottom, 2)
                        }
                        // Iterate through each step
                        ForEach(instructionSet.steps, id: \.number) { step in
                            HStack(alignment: .top) {
                                Text("\(step.number).")
                                    .bold()
                                    .frame(width: 25, alignment: .leading) // Align numbers
                                Text(step.step)
                            }
                            .padding(.vertical, 3) // Slightly more padding
                            // Add a divider between steps for clarity, except for the last one
                            if step.number != instructionSet.steps.last?.number {
                                Divider()
                            }
                        }
                    }
                }
                // Fallback: If no analyzed instructions, try the raw instructions string
                else if let rawInstructions = recipe.instructions, !rawInstructions.isEmpty {
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
                    .padding(.top, 4) // Add some padding when showing raw text
                }
                // If no instructions are available at all
                else {
                    Text("No instructions available for this recipe.")
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            }
            // Apply padding inside the DisclosureGroup content area
            .padding(.leading)
            .padding(.top, 5)

        } label: {
            // This is the tappable label for the DisclosureGroup
            Text("Instructions")
                .font(.headline)
                .foregroundColor(.primary) // Ensure label text is clearly visible
        }
        // Add some padding around the entire DisclosureGroup for spacing in the parent view
        .padding()
    }
}

#Preview {
    @Previewable @State var recipe = loadCakeRecipe()
    InstructionsSteps(recipe: $recipe)
}
