//
//  FullRecipe.swift
//  Recipe Swiper
//
//  Created by Tyler Berlin on 4/23/25.
//

import SwiftData
import SwiftUI

struct FullRecipe: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var recipe: RecipeModel
    @State var showEditing: Bool = false
    @State private var shareItem: ShareItem?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    Text(recipe.title)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .padding()
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                            .padding()
                    }

                    SectionTitleView(title: "Details")

                    FullCardDetails(recipe: recipe)

                    Divider()

                    RatingComponent(recipe: recipe)

                    Divider()

                    SectionTitleView(title: "Summary")

                    Text(recipe.summary)
                        .font(.body)

                    Divider()

                    SectionTitleView(title: "Ingredients")

                    IngredientsListComponent(recipe: recipe)

                    Divider()

                    SectionTitleView(title: "Instructions")

                    InstructionsStepsComponent(recipe: recipe)
                }
                .padding()
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Menu {
                        Button("Share Recipe", systemImage: "square.and.arrow.up") {
                            shareRecipe()
                        }
                        
                        Button("Edit Recipe Details", systemImage: "gear") {
                            showEditing = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showEditing) {
                EditFullRecipeView(recipe: recipe)
            }
            .sheet(item: $shareItem) { item in
                ShareSheet(items: item.items)
            }
        }
        .task {
            if recipe.imageData == nil {
                await recipe.fetchImage()
            }
        }
    }
    
    private func shareRecipe() {
        let formattedRecipe = formatRecipeForSharing()
        var itemsToShare: [Any] = [formattedRecipe]
        
        // Add image if available
        if let imageData = recipe.imageData, let image = UIImage(data: imageData) {
            itemsToShare.append(image)
        }
        
        shareItem = ShareItem(items: itemsToShare)
    }
    
    private func formatRecipeForSharing() -> String {
        var recipeText = """
        🍽️ \(recipe.title)
        
        ⏱️ Ready in: \(recipe.readyInMinutes) minutes
        👥 Servings: \(recipe.servings)
        """
        
        // Add rating if available
        if recipe.rating > 0 {
            let stars = String(repeating: "⭐", count: Int(recipe.rating))
            recipeText += "\n🌟 Rating: \(stars)"
        }
        
        // Add health information
        var healthInfo: [String] = []
        if recipe.vegetarian { healthInfo.append("🌱 Vegetarian") }
        if recipe.vegan { healthInfo.append("🌿 Vegan") }
        if recipe.glutenFree { healthInfo.append("🌾 Gluten-Free") }
        if recipe.dairyFree { healthInfo.append("🥛 Dairy-Free") }
        
        if !healthInfo.isEmpty {
            recipeText += "\n\n" + healthInfo.joined(separator: " • ")
        }
        
        // Add summary
        let cleanSummary = recipe.summary
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !cleanSummary.isEmpty {
            recipeText += "\n\n📝 About:\n\(cleanSummary)"
        }
        
        // Add ingredients
        if !recipe.extendedIngredients.isEmpty {
            recipeText += "\n\n🛒 Ingredients:"
            for ingredient in recipe.extendedIngredients {
                if !ingredient.unit.isEmpty {
                    recipeText += "\n• \(formatNumber(ingredient.amount)) \(ingredient.unit) \(ingredient.name)"
                } else {
                    recipeText += "\n• \(formatNumber(ingredient.amount)) \(ingredient.name)"
                }
            }
        }
        
        // Add instructions
        if let instructions = recipe.instructions, !instructions.isEmpty {
            recipeText += "\n\n👨‍🍳 Instructions:\n\(instructions)"
        }
        
        // Add source attribution
        if !recipe.sourceName.isEmpty {
            recipeText += "\n\n📖 Recipe from: \(recipe.sourceName)"
        }
        
        recipeText += "\n\n🍴 Shared from Snack Swipe"
        
        return recipeText
    }
    
    private func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

struct SectionTitleView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - Share Item and Sheet

struct ShareItem: Identifiable {
    let id = UUID()
    let items: [Any]
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    FullRecipe(recipe: RecipeModel(from: loadCurryRecipe()))
}
