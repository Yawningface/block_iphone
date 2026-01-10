import Foundation
import DeviceActivity

extension DeviceActivityName {
    // 3 periods x 2 (for midnight splits) = 6 schedule slots
    static let period0_a = DeviceActivityName("period0_a")
    static let period0_b = DeviceActivityName("period0_b")
    static let period1_a = DeviceActivityName("period1_a")
    static let period1_b = DeviceActivityName("period1_b")
    static let period2_a = DeviceActivityName("period2_a")
    static let period2_b = DeviceActivityName("period2_b")

    static func forPeriod(_ index: Int, part: String) -> DeviceActivityName {
        DeviceActivityName("period\(index)_\(part)")
    }
}

struct ScheduleManager {

    private static let center = DeviceActivityCenter()

    static func startSchedules() {
        center.stopMonitoring()

        for (index, period) in BlockerModel.timePeriods.enumerated() {
            guard index < 3 else { break } // Max 3 periods

            let crossesMidnight = (period.startHour > period.endHour) ||
                (period.startHour == period.endHour && period.startMinute > period.endMinute)

            if crossesMidnight {
                // Split: start->23:59 and 00:00->end
                let scheduleA = DeviceActivitySchedule(
                    intervalStart: DateComponents(hour: period.startHour, minute: period.startMinute),
                    intervalEnd: DateComponents(hour: 23, minute: 59),
                    repeats: true
                )
                let scheduleB = DeviceActivitySchedule(
                    intervalStart: DateComponents(hour: 0, minute: 0),
                    intervalEnd: DateComponents(hour: period.endHour, minute: period.endMinute),
                    repeats: true
                )
                try? center.startMonitoring(.forPeriod(index, part: "a"), during: scheduleA)
                try? center.startMonitoring(.forPeriod(index, part: "b"), during: scheduleB)
            } else {
                // Single schedule within same day
                let schedule = DeviceActivitySchedule(
                    intervalStart: DateComponents(hour: period.startHour, minute: period.startMinute),
                    intervalEnd: DateComponents(hour: period.endHour, minute: period.endMinute),
                    repeats: true
                )
                try? center.startMonitoring(.forPeriod(index, part: "a"), during: schedule)
            }
        }
    }

    static func stopSchedules() {
        center.stopMonitoring()
    }
}
