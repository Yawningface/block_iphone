import Foundation

// MARK: - User Model

struct SocialUser: Identifiable {
    let id: UUID
    let name: String
    let emoji: String
    let joinedDate: Date

    // Blocking commitment
    var blockedApps: [String]
    var blockStartTime: String
    var blockEndTime: String
    var blockDays: [String]

    // Streak data
    var currentStreak: Int
    var longestStreak: Int
    var lastCheckIn: Date
    var status: UserStatus

    // Privacy settings
    var showApps: Bool
    var showTimes: Bool

    enum UserStatus: String {
        case strong = "strong"      // Maintaining streak
        case weakened = "weakened"  // Recently changed limits
        case broke = "broke"        // Disabled blocking
        case ghost = "ghost"        // No check-in for 48h+
        case eliminated = "eliminated" // Out of survival challenge
    }

    var statusEmoji: String {
        switch status {
        case .strong: return "🔥"
        case .weakened: return "😬"
        case .broke: return "🏳️"
        case .ghost: return "👻"
        case .eliminated: return "💀"
        }
    }

    var compliancePercentage: Double {
        guard longestStreak > 0 else { return 0 }
        return min(Double(currentStreak) / Double(max(currentStreak, longestStreak)), 1.0)
    }
}

// MARK: - Challenge Group Model

struct ChallengeGroup: Identifiable {
    let id: UUID
    let name: String
    let inviteCode: String
    let createdDate: Date
    let challengeType: ChallengeType
    let durationDays: Int?

    var members: [SocialUser]
    var currentDay: Int
    var isActive: Bool

    enum ChallengeType: String {
        case streak = "Streak Challenge"
        case survival = "Survival Challenge"
        case team = "Team Challenge"
    }

    var combinedStreakDays: Int {
        members.reduce(0) { $0 + $1.currentStreak }
    }

    var activeMemberCount: Int {
        members.filter { $0.status == .strong }.count
    }

    var leaderboard: [SocialUser] {
        members.sorted { $0.currentStreak > $1.currentStreak }
    }
}

// MARK: - Activity Event Model

struct ActivityEvent: Identifiable {
    let id: UUID
    let userId: UUID
    let userName: String
    let userEmoji: String
    let eventType: EventType
    let timestamp: Date
    let details: String?
    var comments: [Comment]

    enum EventType: String {
        case dayCompleted = "day_completed"
        case scheduleDisabled = "schedule_disabled"
        case blockTimeShortened = "block_shortened"
        case appsRemoved = "apps_removed"
        case missedHeartbeat = "missed_heartbeat"
        case leftChallenge = "left_challenge"
        case joinedChallenge = "joined_challenge"
        case groupMilestone = "milestone"
        case streakRecord = "streak_record"
    }

    var icon: String {
        switch eventType {
        case .dayCompleted: return "🔥"
        case .scheduleDisabled: return "🏳️"
        case .blockTimeShortened: return "😬"
        case .appsRemoved: return "😬"
        case .missedHeartbeat: return "👻"
        case .leftChallenge: return "👋"
        case .joinedChallenge: return "🎉"
        case .groupMilestone: return "🎉"
        case .streakRecord: return "🏆"
        }
    }

    var message: String {
        switch eventType {
        case .dayCompleted:
            return "\(userName) completed Day \(details ?? "?")"
        case .scheduleDisabled:
            return "\(userName) disabled their blocking... streak lost"
        case .blockTimeShortened:
            return "\(userName) shortened their block by \(details ?? "some time")"
        case .appsRemoved:
            return "\(userName) removed \(details ?? "apps") from their block list"
        case .missedHeartbeat:
            return "\(userName) hasn't checked in for \(details ?? "a while")"
        case .leftChallenge:
            return "\(userName) left the challenge"
        case .joinedChallenge:
            return "\(userName) joined the challenge"
        case .groupMilestone:
            return "Group milestone: \(details ?? "achievement unlocked")!"
        case .streakRecord:
            return "\(userName) set a new personal record: \(details ?? "?") days!"
        }
    }

    var timeAgo: String {
        let interval = Date().timeIntervalSince(timestamp)
        let minutes = Int(interval / 60)
        let hours = Int(interval / 3600)
        let days = Int(interval / 86400)

        if days > 0 {
            return days == 1 ? "Yesterday" : "\(days) days ago"
        } else if hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else if minutes > 0 {
            return "\(minutes) min ago"
        } else {
            return "Just now"
        }
    }
}

// MARK: - Comment Model

struct Comment: Identifiable {
    let id: UUID
    let userId: UUID
    let userName: String
    let text: String
    let timestamp: Date
}

// MARK: - Notification Model

struct SocialNotification: Identifiable {
    let id: UUID
    let type: NotificationType
    let message: String
    let timestamp: Date
    var isRead: Bool

    enum NotificationType {
        case shameAlert      // Someone broke/weakened
        case celebration     // Milestone or record
        case reminder        // Keep your streak going
        case challenge       // Challenge update
    }

    var icon: String {
        switch type {
        case .shameAlert: return "😬"
        case .celebration: return "🎉"
        case .reminder: return "⏰"
        case .challenge: return "🏆"
        }
    }
}
