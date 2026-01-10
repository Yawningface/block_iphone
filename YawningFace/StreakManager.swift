import Foundation
import FamilyControls

struct StreakManager {

    private static let defaults = UserDefaults.standard

    // MARK: - Keys
    private static let currentStreakKey = "currentStreak"
    private static let longestStreakKey = "longestStreak"
    private static let lastStreakDateKey = "lastStreakDate"
    private static let streakStartDateKey = "streakStartDate"

    // MARK: - Computed Properties

    static var currentStreak: Int {
        get { defaults.integer(forKey: currentStreakKey) }
        set {
            defaults.set(newValue, forKey: currentStreakKey)
            if newValue > longestStreak {
                longestStreak = newValue
            }
        }
    }

    static var longestStreak: Int {
        get { defaults.integer(forKey: longestStreakKey) }
        set { defaults.set(newValue, forKey: longestStreakKey) }
    }

    private static var lastStreakDate: Date? {
        get { defaults.object(forKey: lastStreakDateKey) as? Date }
        set { defaults.set(newValue, forKey: lastStreakDateKey) }
    }

    private static var streakStartDate: Date? {
        get { defaults.object(forKey: streakStartDateKey) as? Date }
        set { defaults.set(newValue, forKey: streakStartDateKey) }
    }

    // MARK: - Public Methods

    /// Call this on app launch / when main view appears
    /// Increments streak if it's a new day and blocking is still active
    static func checkAndUpdateStreak() {
        let today = Calendar.current.startOfDay(for: Date())

        // Must have blocking enabled with apps selected
        guard BlockerModel.isEnabled,
              !BlockerModel.selection.applicationTokens.isEmpty else {
            return
        }

        // First time starting a streak
        guard let lastDate = lastStreakDate else {
            currentStreak = 1
            lastStreakDate = today
            streakStartDate = today
            return
        }

        let lastDay = Calendar.current.startOfDay(for: lastDate)

        // Already checked today
        if lastDay == today {
            return
        }

        // Check if yesterday (consecutive day)
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let yesterdayStart = Calendar.current.startOfDay(for: yesterday)

        if lastDay == yesterdayStart {
            // Consecutive day - increment streak
            currentStreak += 1
            lastStreakDate = today
        } else {
            // Missed days - streak broken (they must have had blocking disabled)
            // Start fresh
            currentStreak = 1
            lastStreakDate = today
            streakStartDate = today
        }
    }

    /// Call this when user gives up via StrictModeChallenge
    /// Resets streak to 0
    static func resetStreak() {
        currentStreak = 0
        lastStreakDate = nil
        streakStartDate = nil
    }

    /// Call this when user first enables blocking
    /// Starts a new streak if not already on one
    static func startStreakIfNeeded() {
        let today = Calendar.current.startOfDay(for: Date())

        guard BlockerModel.isEnabled,
              !BlockerModel.selection.applicationTokens.isEmpty else {
            return
        }

        // Only start if no active streak
        if lastStreakDate == nil {
            currentStreak = 1
            lastStreakDate = today
            streakStartDate = today
        }
    }
}
