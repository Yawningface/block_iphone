import SwiftUI
import FamilyControls

struct HomeView: View {
    @Binding var isAuthorized: Bool
    @State private var isBlocking = false
    @State private var blockedAppsCount = 0
    @State private var showScheduleSheet = false

    var body: some View {
        VStack(spacing: 20) {
            Text("BLOCK")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(normalTextColor)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)

            // Permission warning
            if !isAuthorized {
                HStack {
                    Text("Permission needed to block apps!")
                        .font(.subheadline)
                        .foregroundColor(normalTextColor)
                    Spacer()
                    Button("Grant") { requestAuth() }
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .foregroundColor(iconColor)
                        .cornerRadius(20)
                }
                .padding()
                .background(iconColor.opacity(0.9))
                .cornerRadius(10)
                .padding(.horizontal)
            }

            Spacer()

            // Big emoji in center
            Text(isBlocking ? "😎" : "😴")
                .font(.system(size: 100))

            Spacer()

            // Active session card (not clickable - go to Blocks tab to edit)
            if isBlocking {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Blocking Active")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("\(blockedAppsCount) apps • \(scheduleText)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(cardColor)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 20)
            } else {
                // Empty state when no blocking is active
                VStack(spacing: 12) {
                    if blockedAppsCount == 0 {
                        Text("No apps blocked yet")
                            .font(.headline)
                            .foregroundColor(normalTextColor)
                        Text("Set up a schedule to start focusing")
                            .font(.subheadline)
                            .foregroundColor(normalTextColor.opacity(0.6))
                    }

                    Button {
                        Haptics.medium()
                        showScheduleSheet = true
                    } label: {
                        Text(blockedAppsCount == 0 ? "Get Started" : "Set up blocking")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(iconColor)
                            .cornerRadius(25)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .background(backgroundColor.ignoresSafeArea())
        .onAppear { loadState() }
        .sheet(isPresented: $showScheduleSheet) {
            ScheduleSheetView(isAuthorized: $isAuthorized, onSave: { loadState() })
        }
    }

    private var scheduleText: String {
        BlockerModel.timePeriods.map { p in
            String(format: "%02d:%02d-%02d:%02d", p.startHour, p.startMinute, p.endHour, p.endMinute)
        }.joined(separator: ", ")
    }

    private func loadState() {
        isBlocking = BlockerModel.isEnabled
        blockedAppsCount = BlockerModel.selection.applicationTokens.count
    }

    private func requestAuth() {
        Task {
            try? await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            await MainActor.run {
                let approved = AuthorizationCenter.shared.authorizationStatus == .approved
                isAuthorized = approved
                UserDefaults.standard.set(approved, forKey: "authorized")
            }
        }
    }
}

#Preview { HomeView(isAuthorized: .constant(true)) }
