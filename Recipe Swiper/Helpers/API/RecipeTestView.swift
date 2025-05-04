//
//  RecipeTestView.swift // Or keep SwiftUIView.swift and rename struct/preview
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/14/25.
//
// Generated with Gemini 2.5 Pro

import SwiftUI

//
//
//
// Xcode 14.3/IOS 18.4 currently has a problem with URLSession which causes fetching to never respond.
// Preview window in this Xcode version and IOS version will just forever load and eventually error.
// Soulution: Redownload IOS 18.3.1 and build everytime you want to test API calls.
//
//
//

struct RecipeTestView: View {
    // State variables to hold the fetched data, loading status, and error message
    @State private var fetchedRecipe: Recipe? = nil
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationView {  // Optional: Provides a title bar
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView("Fetching Recipe...")  // Show loading indicator
                } else if let error = errorMessage {
                    // Show error message and a retry button
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        // Clear previous state and fetch again
                        fetchedRecipe = nil
                        errorMessage = nil
                        Task {
                            await loadRecipe()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                } else if let recipe = fetchedRecipe {
                    // Display recipe details
                    Text(recipe.title)
                        .font(.title)
                        .multilineTextAlignment(.center)

                    Text("Ready in: \(recipe.readyInMinutes) minutes")
                        .font(.headline)

                    Text("Servings: \(recipe.servings)")
                        .font(.subheadline)

                    // Optionally display the image (requires internet)
                    if let imageUrlString = recipe.image,
                        let imageUrl = URL(string: imageUrlString)
                    {
                        AsyncImage(url: imageUrl) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 200)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 250)
                                    .cornerRadius(10)
                            case .failure:
                                Image(
                                    systemName: "photo"
                                )  // Placeholder on failure
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                                .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer()  // Pushes content to the top

                    Button("Fetch New Recipe") {
                        // Clear previous state and fetch again
                        fetchedRecipe = nil
                        errorMessage = nil
                        Task {
                            await loadRecipe()
                        }
                    }
                    .buttonStyle(.bordered)

                } else {
                    // Initial state or after a successful fetch was cleared
                    Text("Tap 'Fetch New Recipe' to start.")
                    Button("Fetch New Recipe") {
                        Task {
                            await loadRecipe()
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .navigationTitle("Random Recipe Test")
            // .task modifier runs the async code when the view appears
            // .task {
            //     // Only fetch automatically on first appear if recipe is nil
            //     if recipe == nil && errorMessage == nil {
            //         await loadRecipe()
            //     }
            // }
        }
    }

    /// Helper function to encapsulate the fetching logic and state updates
    private func loadRecipe() async {
        isLoading = true
        errorMessage = nil  // Clear previous error on new attempt

        do {
            print("Attempting to fetch recipe from View...")
            let fetchedRecipe = try await fetchRandomRecipe(
                using: FilterModel()
            )
            self.fetchedRecipe = fetchedRecipe  // Update state on the main thread
            print("Successfully updated recipe state in View.")
        } catch {
            // Handle errors
            print("Error caught in View: \(error)")
            if let recipeError = error as? RecipeError {
                self.errorMessage = recipeError.localizedDescription
            } else {
                self.errorMessage = error.localizedDescription  // Store error message
            }
        }

        isLoading = false  // Update loading state on the main thread
    }
}

#Preview {
    RecipeTestView()
}
