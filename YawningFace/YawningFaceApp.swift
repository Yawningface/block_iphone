import SwiftUI

@main
struct YawningFaceApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    init() {
        if BlockerModel.isEnabled {
            ScheduleManager.startSchedules()
        }
        StreakManager.checkAndUpdateStreak()
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
    }
}
