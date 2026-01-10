import Foundation
import FamilyControls

struct TimePeriod: Codable, Identifiable, Equatable {
    var id = UUID()
    var startHour: Int
    var startMinute: Int
    var endHour: Int
    var endMinute: Int

    static var defaultPeriod: TimePeriod {
        TimePeriod(startHour: 21, startMinute: 0, endHour: 9, endMinute: 0)
    }
}

struct BlockerModel {

    private static let group = UserDefaults(suiteName: "group.yawningface.block")

    // MARK: - App Selection

    static var selection: FamilyActivitySelection {
        get {
            guard let data = group?.data(forKey: "selection") else { return FamilyActivitySelection() }
            return (try? PropertyListDecoder().decode(FamilyActivitySelection.self, from: data)) ?? FamilyActivitySelection()
        }
        set {
            let data = try? PropertyListEncoder().encode(newValue)
            group?.set(data, forKey: "selection")
        }
    }

    // MARK: - Schedule Config

    static var isEnabled: Bool {
        get { group?.object(forKey: "enabled") == nil ? true : group!.bool(forKey: "enabled") }
        set { group?.set(newValue, forKey: "enabled") }
    }

    static var timePeriods: [TimePeriod] {
        get {
            // Try to load new format first
            if let data = group?.data(forKey: "timePeriods"),
               let periods = try? JSONDecoder().decode([TimePeriod].self, from: data),
               !periods.isEmpty {
                return periods
            }
            // Migrate from old format if exists
            if group?.object(forKey: "startHour") != nil {
                let legacy = TimePeriod(
                    startHour: group?.integer(forKey: "startHour") ?? 21,
                    startMinute: group?.integer(forKey: "startMinute") ?? 0,
                    endHour: group?.integer(forKey: "endHour") ?? 9,
                    endMinute: group?.integer(forKey: "endMinute") ?? 0
                )
                return [legacy]
            }
            return [.defaultPeriod]
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            group?.set(data, forKey: "timePeriods")
        }
    }

    static var selectedDays: [Int] {
        get { group?.array(forKey: "days") as? [Int] ?? [2, 3, 4, 5, 6] } // Mon-Fri default
        set { group?.set(newValue, forKey: "days") }
    }

    static var strictMode: Bool {
        get { group?.bool(forKey: "strictMode") ?? false }
        set { group?.set(newValue, forKey: "strictMode") }
    }
}
