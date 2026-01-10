import SwiftUI
import FamilyControls
import ManagedSettings

struct BlocksView: View {
    @Binding var isAuthorized: Bool
    @State private var showScheduleSheet = false
    @State private var hasSchedule = false
    @State private var isActive = false
    @State private var blockedAppsCount = 0
    @State private var showStrictChallenge = false

    private let store = ManagedSettingsStore()

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                HStack {
                    Text("BLOCKS")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(normalTextColor)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Scheduled Sessions section
                VStack(alignment: .center, spacing: 15) {
                    Text("Scheduled Sessions")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(normalTextColor)

                    if hasSchedule {
                        Button(action: { showScheduleSheet = true }) {
                            HStack(alignment: .center, spacing: 15) {
                                Text(isActive ? "😎" : "😴")
                                    .font(.system(size: 30))
                                    .frame(width: 40, alignment: .center)

                                VStack(alignment: .leading, spacing: 5) {
                                    Text("My Schedule")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("\(blockedAppsCount) apps blocked")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(scheduleText)
                                        .font(.caption)
                                        .foregroundColor(iconColor)
                                }

                                Spacer()

                                if isActive {
                                    Button(action: { stopSchedule() }) {
                                        Image(systemName: "stop.circle")
                                            .font(.system(size: 20))
                                            .foregroundColor(.red)
                                    }
                                }

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(cardColor)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    // Add new schedule button
                    Button(action: { showScheduleSheet = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(iconColor)
                            Text(hasSchedule ? "Add Another Session" : "Create Schedule")
                                .foregroundColor(normalTextColor)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(cardColor.opacity(0.6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
        }
        .background(backgroundColor.ignoresSafeArea())
        .sheet(isPresented: $showScheduleSheet) {
            ScheduleSheetView(isAuthorized: $isAuthorized, onSave: { loadState() })
        }
        .fullScreenCover(isPresented: $showStrictChallenge) {
            StrictModeChallengeView(onComplete: { performStop() })
        }
        .onAppear { loadState() }
    }

    private var scheduleText: String {
        let times = BlockerModel.timePeriods.map { p in
            String(format: "%02d:%02d-%02d:%02d", p.startHour, p.startMinute, p.endHour, p.endMinute)
        }.joined(separator: ", ")
        let dayNames = BlockerModel.selectedDays.map { dayLetter(for: $0) }.joined(separator: ", ")
        return "\(times) • \(dayNames)"
    }

    private func dayLetter(for weekday: Int) -> String {
        switch weekday {
        case 1: return "Sun"
        case 2: return "Mon"
        case 3: return "Tue"
        case 4: return "Wed"
        case 5: return "Thu"
        case 6: return "Fri"
        case 7: return "Sat"
        default: return ""
        }
    }

    private func loadState() {
        blockedAppsCount = BlockerModel.selection.applicationTokens.count
        hasSchedule = blockedAppsCount > 0
        isActive = BlockerModel.isEnabled
    }

    private func stopSchedule() {
        if BlockerModel.strictMode {
            showStrictChallenge = true
        } else {
            performStop()
        }
    }

    private func performStop() {
        StreakManager.resetStreak()
        BlockerModel.isEnabled = false
        ScheduleManager.stopSchedules()
        store.clearAllSettings()
        isActive = false
    }
}

#Preview { BlocksView(isAuthorized: .constant(true)) }
