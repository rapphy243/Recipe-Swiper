import SwiftUI

struct IngredientsListComponent: View {
    @Bindable var recipe: RecipeModel
    @State private var isExpanded = true
    
    var body: some View {
        Text("Required Ingredients")
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .center)
        DisclosureGroup("", isExpanded: $isExpanded) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(recipe.extendedIngredients, id: \.id) { ingredient in
                        HStack(spacing: 12) {
                            // Ingredient amount and unit
                            Text("\(String(format: "%.1f", ingredient.amount)) \(ingredient.unit)")
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

#Preview {
    @Previewable @State var recipe = RecipeModel(from: loadCurryRecipe())
    IngredientsListComponent(recipe: recipe)
}
