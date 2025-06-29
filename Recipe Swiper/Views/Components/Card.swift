//
//  Card.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 5/24/25.
//

import SwiftUI

struct Card<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
                .padding()
        }
        .background(
            colorScheme == .dark
                ? Color(.systemGray6).opacity(0.8) : .white.opacity(0.8)
        )
        .cornerRadius(10)
        .shadow(
            color: colorScheme == .dark
                ? .black.opacity(0.3) : .gray.opacity(0.3),
            radius: 5
        )
        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
        .padding()  // Padding around the entire card for spacing
    }
}

#Preview {
    VStack {
        // Example 1: Card with a simple Text view
        Card {
            Text("This is a short text inside the card.")
                .font(.headline)
                .foregroundColor(.blue)
        }

        // Example 2: Card with a longer Text view
        Card {
            Text(
                "This card has a longer piece of text that should cause the card to expand vertically to accommodate all the content. SwiftUI's layout system handles this automatically."
            )
            .font(.body)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }

        // Example 3: Card with an image and text
        Card {
            VStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.yellow)
                Text("Card with an Image")
                    .font(.subheadline)
            }
        }
    }
}
