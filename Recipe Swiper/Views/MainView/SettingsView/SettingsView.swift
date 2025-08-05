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
    @State private var showResetDialog = false
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
                        TextField("Enter API Key", text: $settings.apiKey)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.alphabet)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
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
                            Text("Card Activation Threshold")
                        }
                        Picker(
                            "Sensitivity",
                            selection: $settings.swipeSensitivity
                        ) {
                            Text("Low")
                                .tag(100.0)
                            Text("Medium")
                                .tag(200.0)
                            Text("High")
                                .tag(300.0)
                        }
                        .pickerStyle(.palette)
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
                        showResetDialog = true
                    }
                    .font(.headline)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .confirmationDialog(
                        "Reset Settings",
                        isPresented: $showResetDialog,
                        titleVisibility: .visible
                    ) {
                        Button(role: .destructive) {
                            resetAllSettings()
                        } label: {
                            Text("Reset")
                        }
                    } message: {
                        Text("Are you sure you want to reset all settings?")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }

    private func resetAllSettings() {
        settings.swipeSensitivity = 200.0
        settings.enableAIFeatures = true
        settings.aiRecipeSummary = true
        settings.hapticFeedbackEnabled = true
    }
}

#Preview {
    SettingsView()
}
