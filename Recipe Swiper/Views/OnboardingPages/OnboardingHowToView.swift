//
//  OnboardingHowToView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI

struct Recipe: Codable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let sourceUrl: String
}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

struct OnboardingHowToView: View {
    @State private var recipe: Recipe?
    @State private var offset: CGSize = .zero
    @State private var step = 0
    @State private var cardRemoved = false

    var body: some View {
        VStack(spacing: 20) {
            Text(instructionText)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            if let recipe = recipe, !cardRemoved {
                RecipeCardView(recipe: recipe) {
                    if step == 0, let url = URL(string: recipe.sourceUrl) {
                        UIApplication.shared.open(url)
                        step += 1
                    }
                }
                .offset(offset)
                .rotationEffect(.degrees(Double(offset.width / 20)))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if step >= 2 {
                                offset = gesture.translation
                            }
                        }
                        .onEnded { _ in
                            if step == 2 && offset.width < -100 {
                                cardRemoved = true
                                step += 1
                            } else if step == 3 && offset.width > 100 {
                                cardRemoved = true
                                step += 1
                            } else {
                                offset = .zero
                            }
                        }
                )
                .animation(.spring(), value: offset)

                if step == 1 {
                    Button("Next") {
                        step += 1
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                }
            } else if step < 4 {
                ProgressView("Loading Recipe...")
                    .onAppear {
                        loadRecipe()
                    }
            }

            Spacer()

            if step == 4 {
                Text("You're all set! Start discovering recipes!")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("How It Works")
    }

    var instructionText: String {
        switch step {
        case 0: return "Tap the recipe card to open it in Safari."
        case 1: return "Now tap 'Next' to continue."
        case 2: return "Swipe left to discard the recipe."
        case 3: return "Swipe right to save it to your cookbook!"
        default: return "You're ready to go!"
        }
    }

    func loadRecipe() {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/random?number=1&apiKey=e58f9d08265b4ceab4294e4c5544d0cf") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(RecipeResponse.self, from: data) {
                    DispatchQueue.main.async {
                        recipe = decoded.recipes.first
                        cardRemoved = false
                        offset = .zero
                    }
                }
            }
        }.resume()
    }
}



#Preview {
    OnboardingHowToView()
}
