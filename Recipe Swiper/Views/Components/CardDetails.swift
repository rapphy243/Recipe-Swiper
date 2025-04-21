//
//  CardDetails.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/19/25.
//

import SwiftUI

struct CardDetails: View {
    @State var recipe: Recipe
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                HStack(spacing: 5) {
                    Image(systemName: "timer")
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(recipe.readyInMinutes)min")
                            .font(.footnote)
                        Text("Total")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                HStack(spacing: 2) {
                    Image(systemName: "person.2.fill")
                    Text("\(recipe.servings)")
                        .font(.footnote)
                }
            }
            HStack(spacing: 10) {
                HStack {
                    Image(systemName: "book.closed.fill")
                    Text("\(getHostURL(recipe.sourceUrl!))")
                        .font(.footnote)
                }
            }
        }
        .padding()
        .cornerRadius(8)  // Optional: Add rounded corners
        // Optional: Add a border or shadow if desired
        //         .overlay(
        //             RoundedRectangle(cornerRadius: 8)
        //                 .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        //         )
    }

    // Takes a URL and returns the host of it (www.google.com -> google.com)
    private func getHostURL(_ urlString: String) -> String {
        guard let url = URL(string: urlString), let host = url.host,
            !host.isEmpty
        else {
            return "No Source"  // Invalid URL or no host
        }

        //Sometimes the url has www.*, so we want to remove it
        let components = host.split(separator: ".")

        // Handle different numbers of components
        if components.count >= 2 {
            // If 2 or more parts, take the last two and join them
            return components.suffix(2).joined(separator: ".")
        } else if components.count == 1 {
            // If only 1 part (like "localhost"), return it directly
            return String(components[0])
        } else {
            // Should not happen if host is not empty, but handle defensively
            return "No Source"
        }
    }
}

#Preview {
    CardDetails(recipe: loadCakeRecipe())
}
