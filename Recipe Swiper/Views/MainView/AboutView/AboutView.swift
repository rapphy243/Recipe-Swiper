//
//  AboutView.swift
//  Recipe Swiper
//
//  Created by Snack Swipe Team (Zane, Tyler, Rapphy) on 5/28/25.
//

import SwiftUI

struct AboutView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            ?? "Unkown Version"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // App Header Section
                    VStack(spacing: 16) {
                        // App Icon
                        Image("AppIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(radius: 8)

                        VStack(spacing: 8) {
                            Text("Snack Swipe")
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Text("Discover recipes with a swipe")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text("Version \(appVersion)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 20)

                    Divider()
                        .padding(.horizontal, 20)

                    // Acknowledgments Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Acknowledgments")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 20)

                        VStack(spacing: 12) {
                            AcknowledgmentRow(
                                title: "Spoonacular API",
                                description:
                                    "Recipe data and nutritional information",
                                url: "https://spoonacular.com/food-api"
                            )
                            AcknowledgmentRow(
                                title: "Tinder",
                                description:
                                    "Inspiration for the swipe interface",
                                url: nil
                            )
                        }
                        .padding(.horizontal, 20)
                    }

                    Divider()
                        .padding(.horizontal, 20)

                    // Developer Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Developers")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 20)

                        HStack(spacing: 12) {
                            DeveloperProfile(
                                name: "Rapphy",
                                githubUsername: "rapphy243",
                                iconName: "rapphy"
                            )

                            DeveloperProfile(
                                name: "Tyler",
                                githubUsername: "tylerberlin",
                                iconName: "tyler"
                            )

                            DeveloperProfile(
                                name: "Zane",
                                githubUsername: "zmataa",
                                iconName: "zane"
                            )
                        }
                        .padding(.horizontal, 20)
                    }

                    Divider()
                        .padding(.horizontal, 20)

                    // Links & Legal Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Links & Legal")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 20)

                        VStack(spacing: 12) {
                            // Project Links
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Project")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 20)

                                VStack(spacing: 6) {
                                    LinkRow(
                                        icon: "link.circle",
                                        title: "GitHub Repository",
                                        url:
                                            "https://github.com/rapphy243/Recipe-Swiper"
                                    )

                                    LinkRow(
                                        icon: "doc.text",
                                        title: "Privacy Policy",
                                        url:
                                            "https://raw.githubusercontent.com/rapphy243/Recipe-Swiper/refs/heads/main/Privacy%20Policy"
                                    )
                                }
                            }

                            Divider()
                                .padding(.horizontal, 20)

                            // Copyright
                            HStack {
                                Image(systemName: "c.circle")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)

                                Text("2025 Snack Swipe")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 20)
                        }
                    }

                    // Bottom spacing
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("About")
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
                .font(.system(size: 20))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()
        }
    }
}

private struct AcknowledgmentRow: View {
    let title: String
    let description: String
    let url: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let url = url {
                Link(title, destination: URL(string: url)!)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            } else {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }

            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct DeveloperProfile: View {
    let name: String
    let githubUsername: String
    let iconName: String

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            // Memoji profile icon
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .clipShape(Circle())

            VStack(alignment: .center, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)

                Link(
                    "@\(githubUsername)",
                    destination: URL(
                        string: "https://github.com/\(githubUsername)"
                    )!
                )
                .font(.caption)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct LinkRow: View {
    let icon: String
    let title: String
    let url: String

    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 20, height: 20)
                    .font(.system(size: 16))

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    AboutView()
}
