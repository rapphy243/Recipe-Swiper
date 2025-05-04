//
//  OnboardingFilterView.swift
//  Recipe Swiper
//
//  Created by Zane Matarieh on 4/29/25.
//

import SwiftUI

struct OnboardingFiltersView: View {
    @State private var filterTapped = false
    @Binding var selectedTab: Int
    @Binding var recipe: Recipe

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 20) {
                    Spacer()
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

                        Button("Next") {
                            selectedTab = 2
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                    }
                    SmallRecipeCard(recipe: recipe) {}
                        .padding(.horizontal)

                    Spacer()
                }

                // ↖️ Arrow pointing toward the filter icon
                if !filterTapped {
                    VStack(spacing: 4) {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 44))
                            .rotationEffect(.degrees(42))
                            .foregroundColor(.blue)
                            .bold()
                        Text("Tap me!")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .bold()
                    }
                    .offset(x: -75, y: -5)  // adjust to align with filter icon
                    .transition(.opacity)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            filterTapped = true
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundStyle(.blue)
                            .font(.title2)
                            .padding(.horizontal)
                    }
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
