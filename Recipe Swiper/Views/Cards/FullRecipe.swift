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
    @State var recipeImage: UIImage?
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
                    if let image = recipeImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .padding()
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                            .padding()
                            .onAppear {
                                Task {
                                    await recipe.getImage()
                                }
                            }
                    }

                    Text("Details")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)

                    FullCardDetails(recipe: recipe)

                    Divider()

                    RatingComponent(recipe: recipe)

                    Divider()

                    Text("Summary")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Text(recipe.summary)
                        .font(.body)
                        .padding(.bottom)

                    Divider()

                    IngredientsListComponent(recipe: recipe)

                    Divider()

                    InstructionsStepsComponent(recipe: recipe)

                    Divider()
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
            .sheet(isPresented: $showEditing) {
                EditFullRecipeView(recipe: recipe)
            }
        }
        .task {
            if recipeImage == nil {
                await recipeImage = recipe.getImage()
            }
        }
    }
}

#Preview {
    FullRecipe(recipe: RecipeModel(from: loadCurryRecipe()))
}
