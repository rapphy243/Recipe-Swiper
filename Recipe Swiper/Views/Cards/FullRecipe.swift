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
        }
        .task {
            if recipe.imageData == nil {
                await recipe.fetchImage()
            }
        }
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

#Preview {
    FullRecipe(recipe: RecipeModel(from: loadCurryRecipe()))
}
