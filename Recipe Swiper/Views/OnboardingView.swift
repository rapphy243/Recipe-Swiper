//
//  OnboardingView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("This is the onboarding screen")
                Button("Next") {
                    UserDefaults.standard.set(false, forKey: "isOnboarding")
                }
            }
                
        }
    }
}

#Preview {
    OnboardingView()
}
