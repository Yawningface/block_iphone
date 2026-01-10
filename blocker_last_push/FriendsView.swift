import SwiftUI

struct FriendsView: View {
    @State private var showSearch = false
    @State private var searchText = ""

    private let friends = MockFriend.mockFriends

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with friend count
                    HStack {
                        Text("FRIENDS")
                            .font(.title2).fontWeight(.bold)
                            .foregroundColor(normalTextColor)
                        Spacer()
                        Text("\(friends.count) Friends")
                            .font(.subheadline)
                            .foregroundColor(normalTextColor.opacity(0.6))
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    // Add friend button / search
                    if showSearch {
                        HStack {
                            TextField("Search by name...", text: $searchText)
                                .textFieldStyle(.plain)
                                .padding(12)
                                .background(cardColor)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            Button { showSearch = false; searchText = "" } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(normalTextColor.opacity(0.5))
                            }
                        }.padding(.horizontal)
                    } else {
                        Button { showSearch = true } label: {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                Text("Add Friend")
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(iconColor)
                            .cornerRadius(12)
                        }.padding(.horizontal)
                    }

                    // Friends list or empty state
                    if friends.isEmpty {
                        EmptyStateView(
                            icon: "👥",
                            title: "No friends yet",
                            message: "Add friends to stay accountable and see each other's progress",
                            buttonTitle: "Add Friend",
                            buttonAction: { showSearch = true }
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(filteredFriends) { friend in
                                NavigationLink(destination: FriendDetailView(friend: friend)) {
                                    FriendCard(friend: friend)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }.padding(.horizontal)
                    }

                    Spacer()
                }
            }
            .background(backgroundColor.ignoresSafeArea())
        }
    }

    private var filteredFriends: [MockFriend] {
        if searchText.isEmpty {
            return friends
        }
        return friends.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}

// MARK: - Friend Card

struct FriendCard: View {
    let friend: MockFriend

    var body: some View {
        HStack(spacing: 12) {
            // Left: Avatar + Status
            ZStack(alignment: .bottomTrailing) {
                Text(friend.emoji)
                    .font(.system(size: 36))
                    .frame(width: 50, height: 50)
                    .background(cardColor.opacity(0.5))
                    .clipShape(Circle())

                Text(friend.statusEmoji)
                    .font(.system(size: 14))
                    .offset(x: 4, y: 4)
            }

            // Middle: Name + Streak
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(friend.streakText)
                    .font(.caption)
                    .foregroundColor(friend.isStrong ? iconColor : .red)
            }

            Spacer()

            // Right: Screen time + Focus hours
            VStack(alignment: .trailing, spacing: 4) {
                Text(friend.screenTimeFormatted)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(friend.focusHours)h focus")
                    .font(.caption)
                    .foregroundColor(normalTextColor.opacity(0.5))
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(normalTextColor.opacity(0.3))
        }
        .padding()
        .background(cardColor)
        .cornerRadius(12)
    }
}

#Preview { FriendsView() }
