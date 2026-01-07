import SwiftUI
import FamilyControls
import ManagedSettings

struct ScheduleSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isAuthorized: Bool

    @State private var timePeriods: [TimePeriod]
    @State private var days: [Day]
    @State private var showDifficultySheet = false
    @State private var selectedDifficulty: SessionDifficulty = .normal
    @State private var showAppSelection = false
    @State private var selection: FamilyActivitySelection
    @State private var isEnabled: Bool
    @State private var strictMode: Bool
    @State private var errorMessage: String?
    @State private var showStrictChallenge = false

    private let store = ManagedSettingsStore()
    private let onSave: () -> Void
    private let maxPeriods = 3

    init(isAuthorized: Binding<Bool>, onSave: @escaping () -> Void = {}) {
        _isAuthorized = isAuthorized
        self.onSave = onSave

        _timePeriods = State(initialValue: BlockerModel.timePeriods)
        _selection = State(initialValue: BlockerModel.selection)
        _isEnabled = State(initialValue: BlockerModel.isEnabled)
        _strictMode = State(initialValue: BlockerModel.strictMode)

        let savedDays = BlockerModel.selectedDays
        _days = State(initialValue: Day.week.map { var d = $0; d.isSelected = savedDays.contains($0.weekday); return d })
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Schedule Session")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)

                // Time periods
                VStack(alignment: .leading, spacing: 12) {
                    Text("Block Times")
                        .font(.headline)
                        .foregroundColor(normalTextColor)

                    ForEach(timePeriods.indices, id: \.self) { index in
                        periodRow(index: index)
                    }

                    // Add period button
                    if timePeriods.count < maxPeriods {
                        Button { addPeriod() } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(iconColor)
                                Text("Add another time period")
                                    .foregroundColor(normalTextColor)
                                Spacer()
                            }
                            .padding()
                            .background(cardColor.opacity(0.5))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
                .background(cardColor)
                .cornerRadius(12)
                .padding(.horizontal)

                // Days selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Days of Week")
                        .font(.headline)
                        .foregroundColor(normalTextColor)

                    HStack(spacing: 8) {
                        ForEach(days.indices, id: \.self) { i in
                            Button { days[i].isSelected.toggle() } label: {
                                Text(days[i].letter)
                                    .font(.headline)
                                    .frame(width: 36, height: 36)
                                    .background(days[i].isSelected ? iconColor : cardColor)
                                    .foregroundColor(days[i].isSelected ? .black : normalTextColor)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
                .padding(.horizontal)

                // Apps to block
                VStack(alignment: .leading, spacing: 12) {
                    Text("Apps to Block")
                        .font(.headline)
                        .foregroundColor(normalTextColor)

                    Button { showAppSelection = true } label: {
                        HStack {
                            Text("Select Apps")
                            Spacer()
                            Text("\(selection.applicationTokens.count) apps")
                                .foregroundColor(normalTextColor.opacity(0.6))
                            Image(systemName: "chevron.right")
                                .foregroundColor(normalTextColor.opacity(0.4))
                        }
                        .padding()
                        .background(cardColor)
                        .foregroundColor(normalTextColor)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                // Difficulty selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Difficulty")
                        .font(.headline)
                        .foregroundColor(normalTextColor)

                    Button { showDifficultySheet = true } label: {
                        HStack {
                            Image(systemName: selectedDifficulty.icon)
                                .foregroundColor(iconColor)
                            Text(selectedDifficulty.rawValue)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(normalTextColor.opacity(0.4))
                        }
                        .padding()
                        .background(cardColor)
                        .foregroundColor(normalTextColor)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                // Strict mode toggle
                Toggle(isOn: $strictMode) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Strict Mode")
                            .font(.headline)
                            .foregroundColor(normalTextColor)
                        Text("Requires challenge to disable blocking")
                            .font(.caption)
                            .foregroundColor(normalTextColor.opacity(0.6))
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .red))
                .padding()
                .background(cardColor)
                .cornerRadius(12)
                .padding(.horizontal)

                // Enable toggle
                Toggle(isOn: $isEnabled) {
                    Text(isEnabled ? "Schedule Active" : "Enable Schedule")
                        .font(.headline)
                        .foregroundColor(normalTextColor)
                }
                .toggleStyle(SwitchToggleStyle(tint: iconColor))
                .padding()
                .background(cardColor)
                .cornerRadius(12)
                .padding(.horizontal)

                // Error message
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                // Buttons
                HStack(spacing: 20) {
                    Button("Cancel") { dismiss() }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(cardColor)
                        .foregroundColor(.red)
                        .cornerRadius(12)

                    Button("Save") { saveAndDismiss() }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValid ? Color.white : cardColor)
                        .foregroundColor(isValid ? .black : normalTextColor.opacity(0.4))
                        .cornerRadius(12)
                        .disabled(!isValid)
                }
                .padding(.horizontal)
                .padding(.top, 10)

                Spacer().frame(height: 40)
            }
        }
        .background(backgroundColor.ignoresSafeArea())
        .familyActivityPicker(isPresented: $showAppSelection, selection: $selection)
        .sheet(isPresented: $showDifficultySheet) { difficultySheet }
        .fullScreenCover(isPresented: $showStrictChallenge) {
            StrictModeChallengeView(onComplete: { performDisable() })
        }
    }

    private func periodRow(index: Int) -> some View {
        HStack(spacing: 8) {
            // From picker
            VStack(alignment: .leading, spacing: 4) {
                Text("From")
                    .font(.caption)
                    .foregroundColor(normalTextColor.opacity(0.6))
                DatePicker("", selection: Binding(
                    get: { dateFromPeriod(timePeriods[index], isStart: true) },
                    set: { updatePeriod(index: index, from: $0, isStart: true) }
                ), displayedComponents: .hourAndMinute)
                .labelsHidden()
                .colorScheme(.dark)
            }

            Text("-")
                .foregroundColor(normalTextColor.opacity(0.4))

            // To picker
            VStack(alignment: .leading, spacing: 4) {
                Text("To")
                    .font(.caption)
                    .foregroundColor(normalTextColor.opacity(0.6))
                DatePicker("", selection: Binding(
                    get: { dateFromPeriod(timePeriods[index], isStart: false) },
                    set: { updatePeriod(index: index, from: $0, isStart: false) }
                ), displayedComponents: .hourAndMinute)
                .labelsHidden()
                .colorScheme(.dark)
            }

            Spacer()

            // Delete button (only if more than 1 period)
            if timePeriods.count > 1 {
                Button { removePeriod(at: index) } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red.opacity(0.7))
                        .font(.title3)
                }
            }
        }
        .padding(.vertical, 8)
    }

    private func dateFromPeriod(_ period: TimePeriod, isStart: Bool) -> Date {
        let hour = isStart ? period.startHour : period.endHour
        let minute = isStart ? period.startMinute : period.endMinute
        return Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) ?? Date()
    }

    private func updatePeriod(index: Int, from date: Date, isStart: Bool) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        if isStart {
            timePeriods[index].startHour = components.hour ?? 0
            timePeriods[index].startMinute = components.minute ?? 0
        } else {
            timePeriods[index].endHour = components.hour ?? 0
            timePeriods[index].endMinute = components.minute ?? 0
        }
    }

    private func addPeriod() {
        guard timePeriods.count < maxPeriods else { return }
        timePeriods.append(TimePeriod(startHour: 9, startMinute: 0, endHour: 17, endMinute: 0))
    }

    private func removePeriod(at index: Int) {
        guard timePeriods.count > 1 else { return }
        timePeriods.remove(at: index)
    }

    private var isValid: Bool {
        !selection.applicationTokens.isEmpty &&
        !days.filter { $0.isSelected }.isEmpty &&
        !timePeriods.isEmpty
    }

    private func saveAndDismiss() {
        guard isValid else {
            errorMessage = "Please select apps and at least one day"
            return
        }

        // If disabling while strict mode is on, require challenge
        if BlockerModel.isEnabled && BlockerModel.strictMode && !isEnabled {
            showStrictChallenge = true
            return
        }

        performSave()
    }

    private func performSave() {
        BlockerModel.timePeriods = timePeriods
        BlockerModel.selectedDays = days.filter { $0.isSelected }.map { $0.weekday }
        BlockerModel.selection = selection
        BlockerModel.isEnabled = isEnabled
        BlockerModel.strictMode = strictMode

        if isEnabled {
            ScheduleManager.startSchedules()
            StreakManager.startStreakIfNeeded()
        } else {
            StreakManager.resetStreak()
            ScheduleManager.stopSchedules()
            store.clearAllSettings()
        }

        onSave()
        dismiss()
    }

    private func performDisable() {
        isEnabled = false
        performSave()
    }

    private var difficultySheet: some View {
        VStack(spacing: 16) {
            Text("Difficulty")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(normalTextColor)
                .padding(.top, 20)

            ForEach(SessionDifficulty.allCases, id: \.self) { d in
                Button {
                    if d.isAvailable { selectedDifficulty = d; showDifficultySheet = false }
                } label: {
                    HStack {
                        Image(systemName: d.icon)
                            .font(.title2)
                            .foregroundColor(d.isAvailable ? iconColor : normalTextColor.opacity(0.3))
                            .frame(width: 40)
                        VStack(alignment: .leading) {
                            Text(d.rawValue)
                                .font(.headline)
                                .foregroundColor(d.isAvailable ? normalTextColor : normalTextColor.opacity(0.4))
                            Text(d.description)
                                .font(.caption)
                                .foregroundColor(normalTextColor.opacity(0.5))
                        }
                        Spacer()
                        if selectedDifficulty == d {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(iconColor)
                        }
                    }
                    .padding()
                    .background(cardColor)
                    .cornerRadius(10)
                }
                .disabled(!d.isAvailable)
            }
            .padding(.horizontal)

            Spacer()
        }
        .background(backgroundColor.ignoresSafeArea())
    }
}

#Preview {
    ScheduleSheetView(isAuthorized: .constant(true))
}
