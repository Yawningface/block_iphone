import Foundation

// MARK: - Day

struct Day: Identifiable {
    let id = UUID()
    let letter: String
    let weekday: Int // 1 = Sunday, 2 = Monday, etc.
    var isSelected: Bool

    static let week: [Day] = [
        Day(letter: "S", weekday: 1, isSelected: false),
        Day(letter: "M", weekday: 2, isSelected: true),
        Day(letter: "T", weekday: 3, isSelected: true),
        Day(letter: "W", weekday: 4, isSelected: true),
        Day(letter: "T", weekday: 5, isSelected: true),
        Day(letter: "F", weekday: 6, isSelected: true),
        Day(letter: "S", weekday: 7, isSelected: false)
    ]
}

// MARK: - Difficulty

enum SessionDifficulty: String, CaseIterable {
    case normal = "Normal"
    case timeout = "Timeout"
    case deepFocus = "Deep Focus"

    var icon: String {
        switch self {
        case .normal: return "sun.max"
        case .timeout: return "clock"
        case .deepFocus: return "flame"
        }
    }

    var description: String {
        switch self {
        case .normal: return "You can cancel anytime"
        case .timeout: return "Coming soon"
        case .deepFocus: return "Coming soon"
        }
    }

    var isAvailable: Bool {
        self == .normal
    }
}
