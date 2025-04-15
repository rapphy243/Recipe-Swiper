//
//  RecipeCardView.swift
//  Recipe Swiper
//
//  Created by Zane Matarieh on 4/15/25.
//

import Foundation
import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    var onTap: (() -> Void)? = nil

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.orange.opacity(0.2))
                .frame(height: 300)
                .shadow(radius: 5)

            VStack(spacing: 10) {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .frame(height: 180)
                }

                Text(recipe.title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
        .cornerRadius(20)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
        .padding(.horizontal)
    }
}
