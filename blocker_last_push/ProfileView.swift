import SwiftUI
import FamilyControls
import ManagedSettings

struct ProfileView: View {
    @AppStorage("userName") private var userName = "You"
    @AppStorage("userEmoji") private var userEmoji = "😎"
    @AppStorage("joinedDate") private var joinedTimestamp: Double = Date().timeIntervalSince1970

    private var currentStreak: Int { StreakManager.currentStreak }
    private var longestStreak: Int { StreakManager.longestStreak }
    @AppStorage("showAppsToFriends") private var showAppsToFriends = true
    @AppStorage("showTimesToFriends") private var showTimesToFriends = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true

    @State private var showEditProfile = false
    @State private var editName = ""
    @State private var editEmoji = ""

    private var joinedDate: Date {
        Date(timeIntervalSince1970: joinedTimestamp)
    }

    private var blockedAppsCount: Int {
        BlockerModel.selection.applicationTokens.count
    }

    private var totalBlockHours: Int {
        BlockerModel.timePeriods.reduce(0) { total, period in
            let start = period.startHour * 60 + period.startMinute
            var end = period.endHour * 60 + period.endMinute
            if end <= start { end += 24 * 60 }
            return total + (end - start) / 60
        }
    }

    private var activeDaysCount: Int {
        BlockerModel.selectedDays.count
    }

    private var compliancePercentage: Double {
        guard longestStreak > 0 else { return 0 }
        return min(Double(currentStreak) / Double(longestStreak), 1.0)
    }

    private var statusEmoji: String {
        if currentStreak >= longestStreak && currentStreak > 0 { return "🔥" }
        if currentStreak > 0 { return "💪" }
        return "😴"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("PROFILE")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(normalTextColor)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // MARK: - Hero Stats Section
                VStack(spacing: 16) {
                    // Profile avatar with status
                    ZStack {
                        Circle()
                            .fill(cardColor)
                            .frame(width: 100, height: 100)
                        Text(userEmoji)
                            .font(.system(size: 50))

                        // Status badge
                        Text(statusEmoji)
                            .font(.system(size: 24))
                            .background(
                                Circle()
                                    .fill(backgroundColor)
                                    .frame(width: 36, height: 36)
                            )
                            .offset(x: 35, y: 35)
                    }

                    Text(userName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(normalTextColor)

                    // Streak stats row
                    HStack(spacing: 40) {
                        VStack(spacing: 4) {
                            Text("\(currentStreak)")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(iconColor)
                            Text("Current")
                                .font(.caption)
                                .foregroundColor(normalTextColor.opacity(0.6))
                        }

                        // Compliance ring
                        ZStack {
                            Circle()
                                .stroke(cardColor, lineWidth: 8)
                                .frame(width: 70, height: 70)
                            Circle()
                                .trim(from: 0, to: compliancePercentage)
                                .stroke(iconColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .frame(width: 70, height: 70)
                                .rotationEffect(.degrees(-90))
                            Text("\(Int(compliancePercentage * 100))%")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(normalTextColor)
                        }

                        VStack(spacing: 4) {
                            Text("\(longestStreak)")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(normalTextColor)
                            Text("Best")
                                .font(.caption)
                                .foregroundColor(normalTextColor.opacity(0.6))
                        }
                    }
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(cardColor)
                .cornerRadius(16)
                .padding(.horizontal)

                // MARK: - Your Commitment Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Commitment")
                        .font(.headline)
                        .foregroundColor(normalTextColor)
                        .padding(.horizontal)

                    HStack(spacing: 12) {
                        commitmentCard(icon: "app.badge", value: "\(blockedAppsCount)", label: "Apps")
                        commitmentCard(icon: "clock", value: "\(totalBlockHours)h", label: "Daily")
                        commitmentCard(icon: "calendar", value: "\(activeDaysCount)", label: "Days/wk")
                    }
                    .padding(.horizontal)

                    // Member since
                    HStack {
                        Image(systemName: "person.badge.clock")
                            .foregroundColor(iconColor)
                        Text("Member since \(joinedDate.formatted(.dateTime.month().year()))")
                            .font(.subheadline)
                            .foregroundColor(normalTextColor.opacity(0.7))
                    }
                    .padding(.horizontal)
                }

                // MARK: - Privacy Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Privacy")
                        .font(.headline)
                        .foregroundColor(normalTextColor)
                        .padding(.horizontal)

                    VStack(spacing: 0) {
                        toggleRow(icon: "app.badge", title: "Show blocked apps to friends", isOn: $showAppsToFriends)
                        Divider().background(backgroundColor)
                        toggleRow(icon: "clock", title: "Show schedule to friends", isOn: $showTimesToFriends)
                    }
                    .background(cardColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                // MARK: - Settings Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Settings")
                        .font(.headline)
                        .foregroundColor(normalTextColor)
                        .padding(.horizontal)

                    VStack(spacing: 0) {
                        toggleRow(icon: "bell", title: "Notifications", isOn: $notificationsEnabled)
                        Divider().background(backgroundColor)
                        toggleRow(icon: "lock.shield", title: "Strict Mode", isOn: Binding(
                            get: { BlockerModel.strictMode },
                            set: { BlockerModel.strictMode = $0 }
                        ))
                    }
                    .background(cardColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                // MARK: - Account Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Account")
                        .font(.headline)
                        .foregroundColor(normalTextColor)
                        .padding(.horizontal)

                    VStack(spacing: 0) {
                        actionRow(icon: "pencil", title: "Edit Profile") {
                            editName = userName
                            editEmoji = userEmoji
                            showEditProfile = true
                        }
                    }
                    .background(cardColor)
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // App version
                    HStack {
                        Spacer()
                        Text("Version 1.0.0")
                            .font(.caption)
                            .foregroundColor(normalTextColor.opacity(0.4))
                        Spacer()
                    }
                    .padding(.top, 8)
                }

                Spacer(minLength: 40)
            }
        }
        .background(backgroundColor.ignoresSafeArea())
        .alert("Edit Profile", isPresented: $showEditProfile) {
            TextField("Name", text: $editName)
            TextField("Emoji", text: $editEmoji)
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                if !editName.isEmpty { userName = editName }
                if !editEmoji.isEmpty { userEmoji = String(editEmoji.prefix(2)) }
            }
        }
    }

    // MARK: - Component Views

    private func commitmentCard(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(normalTextColor)
            Text(label)
                .font(.caption)
                .foregroundColor(normalTextColor.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(cardColor)
        .cornerRadius(12)
    }

    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24)
            Text(title)
                .font(.subheadline)
                .foregroundColor(normalTextColor)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(iconColor)
        }
        .padding()
    }

    private func actionRow(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 24)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(normalTextColor)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(normalTextColor.opacity(0.4))
            }
            .padding()
        }
    }
}

#Preview { ProfileView() }
