import SwiftUI

@main
struct blocker_last_pushApp: App {

    init() {
        if BlockerModel.isEnabled {
            ScheduleManager.startSchedules()
        }
        StreakManager.checkAndUpdateStreak()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
