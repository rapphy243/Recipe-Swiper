//
//  SettingsView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 7/2/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings = AppSettings.shared
    @ObservedObject private var quota = APIQuota.shared

    var body: some View {
        NavigationStack {
            List {
                // API Usage Section
                Section("API Usage") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Daily Quota Usage")
                            Spacer()
                            Text(
                                "\(Int(quota.quotaUsed))/\(Int(quota.quotaUsed + quota.quotaLeft)) points"
                            )
                        }
                        QuotaProgressBar()
                            .environmentObject(quota)
                        HStack {
                            Text("Last Request:")
                            Spacer()
                            Text("\(Int(quota.quotaRequest)) points")
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // API Configuration
                Section("API Configuration") {
                    HStack {
                        Text("Spoonacular API Key")
                            .lineLimit(1)
                            .fixedSize()
                        Spacer()
                        SecureField("Enter API Key", text: $settings.apiKey)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }

                // AI Features Section
                Section("AI Features") {
                    Toggle(
                        "Enable AI Features",
                        isOn: $settings.enableAIFeatures
                    )

                    if settings.enableAIFeatures {
                        HStack {
                            Text("AI Status")
                            Spacer()
                            Text(ModelHelper.availabilityDescription)
                                .foregroundColor(
                                    ModelHelper.isAvailable
                                        ? .green : .secondary
                                )
                        }
                        Toggle(
                            "AI Recipe Summary",
                            isOn: $settings.aiRecipeSummary
                        )
                        .disabled(!ModelHelper.isAvailable)
                    }
                }

                Section("App Behavior") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Swipe Sensitivity")
                            Spacer()
                            Text(sensitivityLabel)
                        }
                        Slider(
                            value: $settings.swipeSensitivity,
                            in: 50...200,
                            step: 25
                        )
                    }

                    Toggle(
                        "Haptic Feedback",
                        isOn: $settings.hapticFeedbackEnabled
                    )
                }

                // App Actions
                Section("App Actions") {
                    Button("Restart Onboarding") {
                        UserDefaults.standard.set(true, forKey: "isOnboarding")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)

                    Button("Reset All Settings") {
                        resetAllSettings()
                    }
                    .font(.headline)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Settings")
        }
    }

    private var sensitivityLabel: String {
        switch settings.swipeSensitivity {
        case 50:
            return "Low"
        case 75:
            return "Medium-Low"
        case 100:
            return "Medium"
        case 125:
            return "Medium-High"
        case 150...200:
            return "High"
        default:
            return "Custom"
        }
    }

    private func resetAllSettings() {
        settings.apiKey = ""
        settings.swipeSensitivity = 100.0
        settings.enableAIFeatures = true
        settings.aiRecipeSummary = true
        settings.hapticFeedbackEnabled = true
    }
}

#Preview {
    SettingsView()
}
