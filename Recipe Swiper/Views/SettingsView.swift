//
//  SettingsView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/22/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State private var apiKey: String = Secrets.apiKey
    @ObservedObject private var quota = APIQuota.shared

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("API Usage")) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Daily Quota Usage")
                            Spacer()
                            Text(
                                "\(Int(quota.quotaUsed))/\(Int(quota.quotaUsed + quota.quotaLeft)) points"
                            )
                        }

                        // Daily quota progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(
                                        width: geometry.size.width,
                                        height: 20
                                    )
                                    .opacity(0.3)
                                    .foregroundColor(.gray)

                                Rectangle()
                                    .frame(
                                        width: calculateProgressWidth(
                                            totalWidth: geometry.size.width
                                        ),
                                        height: 20
                                    )
                                    .foregroundColor(
                                        getProgressColor(
                                            used: quota.quotaUsed,
                                            total: quota.quotaUsed
                                                + quota.quotaLeft
                                        )
                                    )
                            }
                            .cornerRadius(10)
                        }
                        .frame(height: 20)
                        .padding(.bottom, 8)

                        // Last request info
                        HStack {
                            Text("Last Request:")
                            Spacer()
                            Text("\(Int(quota.quotaRequest)) points")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section(header: Text("Other")) {
                    HStack {
                        Text("Spoonacular API Key:")
                            .lineLimit(1)
                            .fixedSize()
                        Spacer()
                        TextField(Secrets.apiKey, text: $apiKey)
                            .onChange(of: apiKey) {
                                Secrets.setApiKey(apiKey)
                            }
                    }
                }
                Button("Restart Onboarding") {
                    isOnboarding = true
                }
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Settings")
        }
    }

    private func calculateProgressWidth(totalWidth: CGFloat) -> CGFloat {
        let total = quota.quotaUsed + quota.quotaLeft
        guard total > 0 else { return 0 }  // Prevent division by zero

        let ratio = quota.quotaUsed / total
        return totalWidth * CGFloat(ratio)
    }

    private func getProgressColor(used: Double, total: Double) -> Color {
        guard total > 0 else { return .green }  // Default color when no data
        let percentage = used / total
        switch percentage {
        case 0..<0.6:
            return .green
        case 0.6..<0.8:
            return .yellow
        default:
            return .red
        }
    }
}

#Preview {
    SettingsView()
}
