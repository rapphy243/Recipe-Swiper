import SwiftUI

struct OnboardingGetStartedView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 30) {
                Spacer()
                // Change Image Maybe
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.green)

                VStack(spacing: 15) {
                    Text("You're All Set!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Ready to discover your next favorite meal? Tap the button below to start swiping through delicious recipes!")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding(.top)
            Button {
                isOnboarding = false
            } label: {
                Text("Let's Get Cooking!")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    OnboardingGetStartedView()
}
