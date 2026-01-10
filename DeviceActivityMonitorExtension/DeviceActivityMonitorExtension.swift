import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls

class DeviceActivityMonitorExtension: DeviceActivityMonitor {

    private let store = ManagedSettingsStore()
    private let group = UserDefaults(suiteName: "group.yawningface.block")

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        guard let data = group?.data(forKey: "selection"),
              let selection = try? PropertyListDecoder().decode(FamilyActivitySelection.self, from: data) else { return }
        store.shield.applications = selection.applicationTokens
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        store.clearAllSettings()
    }
}
