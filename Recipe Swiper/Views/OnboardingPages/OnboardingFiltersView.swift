//
//  OnboardingFilterView.swift
//  Recipe Swiper
//
//  Created by Zane Matarieh on 4/29/25.
//

import SwiftUI

struct OnboardingFiltersView: View {
    @State private var filterTapped = false
    @State private var isArrowAnimating = false
    @Binding var selectedTab: Int
    @Binding var recipe: Recipe
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Filters help you personalize your recipes!")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    if filterTapped {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("You can:")
                                .font(.headline)
                            Text("• Choose a Cuisine – e.g., Italian, Korean")
                            Text("• Pick a Diet – e.g., Vegan, Keto")
                            Text("• Avoid Intolerances – e.g., Gluten-Free")
                            Text("• Select a Meal Type – e.g., Snack, Dessert")
                        }
                        .font(.body)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .transition(.scale.combined(with: .opacity))
                        Button("Next") {
                            withAnimation {
                                selectedTab = 2
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.vertical)
                    }

                    SmallRecipeCard(recipe: recipe)
                        .padding(.horizontal)
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring()) {
                            filterTapped = true
                        }
                    } label: {
                        Image(
                            systemName: "line.3.horizontal.decrease.circle"
                        )
                        .foregroundStyle(.blue)
                        .font(.title2)
                        .padding(.horizontal)
                    }
                }
            }

            if !filterTapped {
                VStack(spacing: 4) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 44))
                        .rotationEffect(.degrees(42))
                        .foregroundColor(.blue)
                        .bold()
                        .offset(y: isArrowAnimating ? -5 : 5)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isArrowAnimating)
                    Text("Tap me!")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .bold()
                }
                .padding(.top, 5)
                .padding(.trailing, 60)
                .transition(.opacity)
                .onAppear {
                    isArrowAnimating = true
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedTab: Int = 1
    @Previewable @State var recipe = loadCakeRecipe()
    OnboardingFiltersView(selectedTab: $selectedTab, recipe: $recipe)
}
