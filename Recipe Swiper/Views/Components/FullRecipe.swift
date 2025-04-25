//
//  FullRecipe.swift
//  Recipe Swiper
//
//  Created by Tyler Berlin on 4/23/25.
//

import SwiftUI

struct FullRecipe: View {
    @State var recipe: Recipe

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    Text(recipe.title)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)
                    
                    if let imageUrl = recipe.image, let url = URL(
                        string: imageUrl
                    ) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .padding()
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 300)
                                .padding()
                        }
                    }
                    
                    Text("Details")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    FullCardDetails(recipe: $recipe)
                    
                    Divider()
                    
                    Text("Summary")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(simplifySummary(recipe.summary))
                        .font(.body)
                        .padding(.bottom)
                    
                    Divider()
                    
                    IngredientsList(recipe: $recipe)
                    
                    Divider()
                    
                    InstructionsSteps(recipe: $recipe)
                    
                    Divider()
                }
                .padding()
            }
        }
    }
}

#Preview {
    FullRecipe(recipe: loadCakeRecipe())
}
