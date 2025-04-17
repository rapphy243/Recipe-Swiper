//
//  MainView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI

struct MainView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @Binding var savedRecipes: [String]
    @State private var cardOffset: CGSize = .zero
    @State private var cardRotation: Double = 0
    @State private var currentRecipe: Recipe = Recipe.empty
    @State private var shownRecipes: [String] = []

    var body: some View {
        NavigationStack {
            VStack {
                    ZStack {
                        SmallRecipeCard(recipe: currentRecipe)
                            .offset(cardOffset)
                            .rotationEffect(.degrees(cardRotation))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        cardOffset = value.translation
                                        cardRotation = Double(value.translation.width / 20)
                                    }
                                    .onEnded { value in
                                        if abs(value.translation.width) > 100 {
                                            if value.translation.width > 0 {
                                                savedRecipes.append(currentRecipe.title)
                                                shownRecipes.append(currentRecipe.title)
                                            }
                                            withAnimation {
                                                cardOffset = CGSize(width: value.translation.width > 0 ? 500 : -500, height: 0)
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                Task {
                                                    await fetchNewRecipe()
                                                }
                                                cardOffset = .zero
                                                cardRotation = 0
                                            }
                                        } else {
                                            withAnimation {
                                                cardOffset = .zero
                                                cardRotation = 0
                                            }
                                        }
                                    }
                            )
                    }
            }
            .onAppear {
                Task {
                    await fetchNewRecipe()
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Restart Onboarding", systemImage: "gear") {
                            isOnboarding = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
    }

    private func fetchNewRecipe() async {
        while true {
            if let newRecipe = try? await fetchRandomRecipe(), !shownRecipes.contains(newRecipe.title) {
                currentRecipe = newRecipe
                break
            }
        }
    }
}

#Preview {
    MainView(savedRecipes: .constant([]))
}
