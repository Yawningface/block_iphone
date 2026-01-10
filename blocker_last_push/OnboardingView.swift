import SwiftUI
import FamilyControls

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @State private var isRequestingAuth = false

    private let totalPages = 4

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    WelcomePage()
                        .tag(0)
                    HowItWorksPage()
                        .tag(1)
                    PermissionsPage()
                        .tag(2)
                    GetStartedPage(
                        isRequestingAuth: $isRequestingAuth,
                        onComplete: completeOnboarding
                    )
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)

                // Bottom section
                VStack(spacing: 20) {
                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? iconColor : cardColor)
                                .frame(width: 8, height: 8)
                        }
                    }

                    // Navigation button
                    if currentPage < totalPages - 1 {
                        Button {
                            withAnimation {
                                currentPage += 1
                            }
                        } label: {
                            Text(currentPage == 0 ? "Get Started" : "Continue")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 40)
                    }

                    // Skip button (not on last page)
                    if currentPage < totalPages - 1 {
                        Button {
                            withAnimation {
                                currentPage = totalPages - 1
                            }
                        } label: {
                            Text("Skip")
                                .font(.subheadline)
                                .foregroundColor(normalTextColor.opacity(0.5))
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }

    private func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}

// MARK: - Page 1: Welcome

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // App icon placeholder
            ZStack {
                Circle()
                    .fill(cardColor)
                    .frame(width: 120, height: 120)
                Image(systemName: "shield.checkered")
                    .font(.system(size: 50))
                    .foregroundColor(iconColor)
            }

            VStack(spacing: 12) {
                Text("Block")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(normalTextColor)

                Text("Take back your focus")
                    .font(.title3)
                    .foregroundColor(normalTextColor.opacity(0.7))
            }

            Text("Block distracting apps during the times that matter most to you.")
                .font(.body)
                .foregroundColor(normalTextColor.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Page 2: How It Works

struct HowItWorksPage: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("How it works")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(normalTextColor)

            VStack(alignment: .leading, spacing: 24) {
                StepRow(number: "1", icon: "app.badge", title: "Choose apps", description: "Select the apps you want to block")
                StepRow(number: "2", icon: "clock", title: "Set schedule", description: "Pick the times you want to focus")
                StepRow(number: "3", icon: "shield.fill", title: "Stay focused", description: "We'll block apps during your schedule")
            }
            .padding(.horizontal, 32)

            Spacer()
            Spacer()
        }
    }
}

struct StepRow: View {
    let number: String
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor)
                    .frame(width: 44, height: 44)
                Text(number)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(normalTextColor)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(normalTextColor.opacity(0.6))
            }

            Spacer()
        }
    }
}

// MARK: - Page 3: Permissions

struct PermissionsPage: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(cardColor)
                    .frame(width: 100, height: 100)
                Image(systemName: "lock.shield")
                    .font(.system(size: 44))
                    .foregroundColor(iconColor)
            }

            VStack(spacing: 12) {
                Text("Screen Time Access")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(normalTextColor)

                Text("To block apps, we need permission to use Screen Time controls.")
                    .font(.body)
                    .foregroundColor(normalTextColor.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            // Privacy note
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Your data stays on your device")
                        .font(.subheadline)
                        .foregroundColor(normalTextColor.opacity(0.7))
                }
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("We never see which apps you use")
                        .font(.subheadline)
                        .foregroundColor(normalTextColor.opacity(0.7))
                }
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("You can revoke access anytime")
                        .font(.subheadline)
                        .foregroundColor(normalTextColor.opacity(0.7))
                }
            }
            .padding(.top, 16)

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Page 4: Get Started

struct GetStartedPage: View {
    @Binding var isRequestingAuth: Bool
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("🚀")
                .font(.system(size: 80))

            VStack(spacing: 12) {
                Text("Ready to focus?")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(normalTextColor)

                Text("Grant permission and start blocking distractions today.")
                    .font(.body)
                    .foregroundColor(normalTextColor.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()

            // Main CTA
            Button {
                requestAuthorization()
            } label: {
                HStack {
                    if isRequestingAuth {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    } else {
                        Text("Enable Screen Time")
                    }
                }
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(iconColor)
                .cornerRadius(12)
            }
            .disabled(isRequestingAuth)
            .padding(.horizontal, 40)

            // Skip option
            Button {
                onComplete()
            } label: {
                Text("Skip for now")
                    .font(.subheadline)
                    .foregroundColor(normalTextColor.opacity(0.5))
            }

            Spacer()
        }
    }

    private func requestAuthorization() {
        isRequestingAuth = true
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                await MainActor.run {
                    let approved = AuthorizationCenter.shared.authorizationStatus == .approved
                    UserDefaults.standard.set(approved, forKey: "authorized")
                    isRequestingAuth = false
                    onComplete()
                }
            } catch {
                await MainActor.run {
                    isRequestingAuth = false
                    onComplete()
                }
            }
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
