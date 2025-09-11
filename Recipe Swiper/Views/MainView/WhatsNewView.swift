//
//  WhatsNewView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 9/10/25.
//

import SwiftUI

struct WhatsNewView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 48))
                    .foregroundStyle(.tint)
                Text("What’s New")
                    .font(.largeTitle)
                    .bold()
                Text(
                    "Here’s a quick look at the latest improvements in this update."
                )
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            }

            // Feature highlights
            WhatsNewItem(
                icon: "wand.and.stars",
                title: "AI Summaries of Recipes",
                description:
                    "Get AI‑powered summaries of any recipe on supported devices."
            )

            WhatsNewItem(
                icon: "paintpalette",
                title: "Custom Color Schemes",
                description:
                    "Personalize your app with dark and light mode customization."
            )

            WhatsNewItem(
                icon: "app.badge.checkmark",
                title: "iOS 26 Design Guidelines",
                description:
                    "We’ve refreshed the interface to align with the latest iOS design standards."
            )
            Text(
                "We also had to unfortunately reset all your previously saved recipes to bring you the latest features."
            )
            .font(.footnote)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            Button {
                dismiss()
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(
                        Color.accentColor,
                        in: RoundedRectangle(cornerRadius: 12)
                    )
                    .padding(.top, 40)
            }
        }
        .padding()
    }

}
struct WhatsNewItem: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .frame(width: 40, height: 40)
                .foregroundStyle(.tint)
                .padding(8)
                .background(
                    .thinMaterial,
                    in: RoundedRectangle(cornerRadius: 12)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }
}
#Preview {
    WhatsNewView()
}
