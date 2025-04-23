//
//  MainView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI

struct MainView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @Binding var savedRecipes: [Recipe]
    @Binding var discardedRecipes: [Recipe]
    @State private var cardOffset: CGSize = .zero
    @State private var cardRotation: Double = 0
    @State private var currentRecipe: Recipe = loadCurryRecipe()
    @State private var shownRecipes: [String] = []
    @State private var isLoading = false
    
    // Swipe threshold to trigger action
    private let swipeThreshold: CGFloat = 200
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .zIndex(-1)
            
            VStack {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                } else {
                    SmallRecipeCard(recipe: currentRecipe)
                        .offset(cardOffset)
                        .rotationEffect(.degrees(cardRotation))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    cardOffset = gesture.translation
                                    // Add slight rotation based on horizontal movement
                                    cardRotation = Double(gesture.translation.width / 15)
                                }
                                .onEnded { gesture in
                                    handleSwipe(gesture)
                                }
                        )
                        .overlay(alignment: .trailing) {
                            if cardOffset.width > 50 {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.green)
                                    .font(.largeTitle)
                                    .padding(.trailing, 30)
                                    .opacity(Double(cardOffset.width) / swipeThreshold)
                            }
                        }
                        .overlay(alignment: .leading) {
                            if cardOffset.width < -50 {
                                Image(systemName: "xmark")
                                    .foregroundColor(.red)
                                    .font(.largeTitle)
                                    .padding(.leading, 30)
                                    .opacity(Double(-cardOffset.width) / swipeThreshold)
                            }
                        }
                        .animation(.spring(response: 0.3), value: cardOffset)
                }
            }
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
            .task {
                if currentRecipe.id == -1 {
                    await fetchNewRecipe()
                }
            }
            }
        }
    }
    
    private func handleSwipe(_ gesture: DragGesture.Value) {
        let horizontalMovement = gesture.translation.width
        
        // Right swipe (save)
        if horizontalMovement > swipeThreshold {
            saveCurrentRecipe()
        }
        // Left swipe (skip)
        else if horizontalMovement < -swipeThreshold {
            skipCurrentRecipe()
        }
        // Not enough movement - reset position
        else {
            resetCardPosition()
        }
    }
    
    private func saveCurrentRecipe() {
        if !shownRecipes.contains(currentRecipe.title) {
            savedRecipes.append(currentRecipe)
            shownRecipes.append(currentRecipe.title)
        }
        
        // Animate card off screen
        withAnimation(.easeOut(duration: 0.2)) {
            cardOffset.width = UIScreen.main.bounds.width * 1.5
            cardRotation = 20
        }
        
        // Fetch next recipe
        Task {
            isLoading = true
            await fetchNewRecipe()
            resetCardPosition()
            isLoading = false
        }
    }
    
    private func skipCurrentRecipe() {
        if !shownRecipes.contains(currentRecipe.title) {
            discardedRecipes.append(currentRecipe)
            shownRecipes.append(currentRecipe.title)
        }
        
        // Animate card off screen
        withAnimation(.easeOut(duration: 0.2)) {
            cardOffset.width = -UIScreen.main.bounds.width * 1.5
            cardRotation = -20
        }
        
        // Fetch next recipe
        Task {
            isLoading = true
            await fetchNewRecipe()
            resetCardPosition()
            isLoading = false
        }
    }
    
    private func resetCardPosition() {
        withAnimation(.spring(response: 0.3)) {
            cardOffset = .zero
            cardRotation = 0
        }
    }
    
    private func fetchNewRecipe() async {
        for _ in 0..<1 { // Only try and fetch a Recipe 1 times per call
            do {
                let newRecipe = try await fetchRandomRecipe()
                if !shownRecipes.contains(newRecipe.title) {
                    currentRecipe = newRecipe
                    break
                }
            } catch {
                print("Error fetching recipe: \(error)")
                currentRecipe = Recipe.empty
            }
        }
    }
}

#Preview {
    MainView(savedRecipes: .constant([]), discardedRecipes: .constant([]))
}
