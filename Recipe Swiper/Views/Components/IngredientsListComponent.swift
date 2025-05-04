import SwiftUI

struct IngredientsListComponent: View {
    @Bindable var recipe: RecipeModel
    @State private var isExpanded = true
    @State private var servingMultiplier = 1.0

    var body: some View {
        VStack {
            Text("Required Ingredients")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)

            DisclosureGroup("", isExpanded: $isExpanded) {
                // Serving size adjustment
                HStack {
                    Text("Adjust servings:")
                        .font(.subheadline)
                    Stepper(
                        value: $servingMultiplier,
                        in: 0.5...4.0,
                        step: 0.5
                    ) {
                        Text(
                            "\(Int(Double(recipe.servings) * servingMultiplier)) servings"
                        )
                        .font(.subheadline)
                    }
                }
                .padding(.horizontal)
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(recipe.extendedIngredients, id: \.id) {
                        ingredient in
                        HStack(spacing: 12) {
                            // Ingredient amount and unit
                            Text(
                                formatAmount(
                                    ingredient.amount * servingMultiplier
                                ) + " " + ingredient.unit
                            )
                            .foregroundColor(.secondary)
                            .frame(width: 100, alignment: .trailing)

                            // Ingredient name
                            Text(ingredient.name.capitalized)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding()
        }
    }

    private func formatAmount(_ amount: Double) -> String {
        if amount.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", amount)
        } else {
            return String(format: "%.1f", amount)
        }
    }
}

#Preview {
    @Previewable @State var recipe = RecipeModel(from: loadCurryRecipe())
    IngredientsListComponent(recipe: recipe)
}
