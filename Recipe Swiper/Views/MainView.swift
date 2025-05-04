//
//  MainView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State private var cardOffset: CGSize = .zero
    @State private var cardRotation: Double = 0
    @State private var currentRecipe: Recipe = loadCurryRecipe()
    @State private var isLoading = false
    @State private var showSettings = false
    @State private var showFilterSheet = false
    @ObservedObject var filterModel: FilterModel

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
                                        cardRotation = Double(
                                            gesture.translation.width / 15
                                        )
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
                                        .opacity(
                                            Double(cardOffset.width)
                                                / swipeThreshold
                                        )
                                }
                            }
                            .overlay(alignment: .leading) {
                                if cardOffset.width < -50 {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.red)
                                        .font(.largeTitle)
                                        .padding(.leading, 30)
                                        .opacity(
                                            Double(-cardOffset.width)
                                                / swipeThreshold
                                        )
                                }
                            }
                            .animation(
                                .spring(response: 0.3),
                                value: cardOffset
                            )
                        QuoteViewComponent()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Snack Swipe")
                            .foregroundColor(.white)
                            .bold()
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            showFilterSheet = true
                        } label: {
                            Image(
                                systemName: "line.3.horizontal.decrease.circle"
                            )
                            .foregroundStyle(.white)
                        }

                        Menu {
                            Button("Settings", systemImage: "gear") {
                                showSettings = true
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.white)
                        }
                    }
                }

                .toolbarBackground(.indigo, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    if currentRecipe.id == -1 {
                        await fetchNewRecipe()
                    }
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
                .sheet(isPresented: $showFilterSheet) {
                    FilterSheetView(model: filterModel)
                }

            }
        }
    }

    private func handleSwipe(_ gesture: DragGesture.Value) {
        let horizontalMovement = gesture.translation.width

        // Right swipe (save)
        if horizontalMovement > swipeThreshold {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            saveCurrentRecipe()
        }
        // Left swipe (skip)
        else if horizontalMovement < -swipeThreshold {
            let impactLight = UIImpactFeedbackGenerator(style: .light)
            impactLight.impactOccurred()
            skipCurrentRecipe()
        }
        // Not enough movement - reset position
        else {
            resetCardPosition()
            let impactMed = UIImpactFeedbackGenerator(style: .heavy)
            impactMed.impactOccurred()
        }
    }

    private func saveCurrentRecipe() {
        // Check if the recipe already exists in the model container
        let fetchDescriptor = FetchDescriptor<RecipeModel>(
            predicate: #Predicate {
                $0.title == currentRecipe.title
            }
        )

        let existingRecipes: [RecipeModel] =
            try! modelContext.fetch(fetchDescriptor)

        guard existingRecipes.isEmpty else {
            print("Recipe already exists in container, skipping save.")
            Task {
                isLoading = true
                await fetchNewRecipe()
                resetCardPosition()
                isLoading = false
            }
            return  // Exit if the recipe exists
        }
        let savedRecipe = RecipeModel(from: currentRecipe)
        Task {
            await savedRecipe.getImage()
        }
        modelContext.insert(savedRecipe)

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
        // Check if the recipe already exists in the model container
        let fetchDescriptor = FetchDescriptor<RecipeModel>(
            predicate: #Predicate {
                $0.id == currentRecipe.id  // Ids should be only non editable property
            }
        )

        let existingRecipes: [RecipeModel] =
            try! modelContext.fetch(fetchDescriptor)

        guard existingRecipes.isEmpty else {
            print("Recipe already exists in container, skipping skip.")
            Task {
                isLoading = true
                await fetchNewRecipe()
                resetCardPosition()
                isLoading = false
            }
            return  // Exit if the recipe exists
        }

        // Check if we need to remove an old discarded recipe
        let discardedFetchDescriptor = FetchDescriptor<RecipeModel>(
            predicate: #Predicate { $0.isDiscarded == true },
            sortBy: [SortDescriptor(\RecipeModel.dateModified, order: .forward)]
        )

        if let discardedRecipes = try? modelContext.fetch(
            discardedFetchDescriptor
        ),
            discardedRecipes.count >= 10,
            let oldestDiscarded = discardedRecipes.first
        {
            // Delete the oldest discarded recipe if we have 10 or more
            modelContext.delete(oldestDiscarded)
            print("Deleted oldest discarded recipe: \(oldestDiscarded.title)")
        }
        // Add deletedRecipe to model container
        let deletedRecipe = RecipeModel(from: currentRecipe, isDiscarded: true)
        Task {
            await deletedRecipe.getImage()
        }
        modelContext.insert(deletedRecipe)

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
        for _ in 0..<1 {  // Only try and fetch a Recipe 1 times per call
            do {
                let newRecipe = try await fetchRandomRecipe(using: filterModel)
                currentRecipe = newRecipe
                break
            } catch {
                print("Error fetching recipe: \(error)")
                currentRecipe = Recipe.empty
            }
        }
    }
}

#Preview {
    MainView(filterModel: FilterModel())
}
