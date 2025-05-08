//
//  RecipeCardView.swift
//  Recipe Swiper
//
//  Created by Zane Matarieh on 4/15/25.
//

import SwiftData
import SwiftUI

struct SmallRecipeCard: View {
    @Environment(\.colorScheme) private var colorScheme
    @State var recipe: Recipe
    @State var onTap: (() -> Void)? = nil
    var body: some View {
        VStack(spacing: 10) {
            Text(recipe.title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Divider()
            HStack {
                AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 260)
                        .clipped()
                        .cornerRadius(10)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 160, height: 260)
                }
                Spacer()
                VStack {
                    SmallCardDetails(recipe: recipe)
                    Divider()
                        .frame(width: 130)
                    ScrollView {
                        Text("\(simplifySummary(recipe.summary))")
                            .font(.caption2)
                            .padding()
                    }
                    .frame(minHeight: 175, maxHeight: 175)
                }
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    colorScheme == .dark
                        ? Color(.systemGray6).opacity(0.8) : .white.opacity(0.8)
                )
                .shadow(
                    color: colorScheme == .dark
                        ? .black.opacity(0.3) : .gray.opacity(0.3),
                    radius: 5
                )
        )
        .foregroundStyle(colorScheme == .dark ? .white : .black)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
        .padding(.horizontal)
    }
}

#Preview {
    SmallRecipeCard(recipe: loadCakeRecipe())
}
