import SwiftUI

struct FriendDetailView: View {
    let friend: MockFriend

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - Profile Header
                VStack(spacing: 16) {
                    // Avatar with status
                    ZStack {
                        Circle()
                            .fill(cardColor)
                            .frame(width: 100, height: 100)
                        Text(friend.emoji)
                            .font(.system(size: 50))

                        // Status badge
                        Text(friend.statusEmoji)
                            .font(.system(size: 24))
                            .background(
                                Circle()
                                    .fill(backgroundColor)
                                    .frame(width: 36, height: 36)
                            )
                            .offset(x: 35, y: 35)
                    }

                    Text(friend.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(normalTextColor)

                    // Streak stats row
                    HStack(spacing: 40) {
                        VStack(spacing: 4) {
                            Text("\(friend.currentStreak)")
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
                            Text("\(friend.longestStreak)")
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

                // MARK: - Screen Time Today
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today's Screen Time")
                        .font(.headline)
                        .foregroundColor(normalTextColor)
                        .padding(.horizontal)

                    HStack {
                        Image(systemName: "iphone")
                            .font(.title2)
                            .foregroundColor(iconColor)
                            .frame(width: 40)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(friend.screenTimeFormatted)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(normalTextColor)
                            Text("total screen time today")
                                .font(.caption)
                                .foregroundColor(normalTextColor.opacity(0.6))
                        }

                        Spacer()
                    }
                    .padding()
                    .background(cardColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                // MARK: - Their Commitment Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Their Commitment")
                        .font(.headline)
                        .foregroundColor(normalTextColor)
                        .padding(.horizontal)

                    HStack(spacing: 12) {
                        commitmentCard(icon: "app.badge", value: "\(friend.blockedAppsCount)", label: "Apps")
                        commitmentCard(icon: "clock", value: "\(friend.focusHours)h", label: "Daily")
                        commitmentCard(icon: "calendar", value: "\(friend.activeDays.count)", label: "Days/wk")
                    }
                    .padding(.horizontal)
                }

                // MARK: - Schedule Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Blocking Schedule")
                        .font(.headline)
                        .foregroundColor(normalTextColor)
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        // Time
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(iconColor)
                                .frame(width: 24)
                            Text(friend.schedule)
                                .font(.subheadline)
                                .foregroundColor(normalTextColor)
                            Spacer()
                        }

                        Divider().background(backgroundColor)

                        // Days
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(iconColor)
                                .frame(width: 24)
                            Text(friend.activeDays.joined(separator: ", "))
                                .font(.subheadline)
                                .foregroundColor(normalTextColor)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(cardColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                // MARK: - Privacy Note
                HStack {
                    Image(systemName: "lock.shield")
                        .foregroundColor(normalTextColor.opacity(0.4))
                    Text("Shared with their permission")
                        .font(.caption)
                        .foregroundColor(normalTextColor.opacity(0.4))
                }
                .padding(.top, 8)

                Spacer(minLength: 40)
            }
            .padding(.top, 10)
        }
        .background(backgroundColor.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Computed Properties

    private var compliancePercentage: Double {
        guard friend.longestStreak > 0 else { return 0 }
        return min(Double(friend.currentStreak) / Double(friend.longestStreak), 1.0)
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
}

#Preview {
    NavigationStack {
        FriendDetailView(friend: MockFriend.mockFriends[0])
    }
}
