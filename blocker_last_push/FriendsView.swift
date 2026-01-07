import SwiftUI

struct FriendsView: View {
    @State private var showSearch = false
    @State private var searchText = ""

    private let friends = [
        ("Sarah", "🔥", 12, "2h 34m", true),
        ("Mike", "😎", 8, "1h 12m", true),
        ("Jake", "💀", 0, "6h 45m", false),
        ("Emma", "🔥", 21, "45m", true),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("FRIENDS")
                    .font(.title2).fontWeight(.bold)
                    .foregroundColor(normalTextColor)
                    .frame(maxWidth: .infinity)
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
                        Button { showSearch = false } label: {
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

                // Friends list
                VStack(spacing: 12) {
                    ForEach(friends, id: \.0) { name, emoji, streak, screenTime, isStrong in
                        HStack(spacing: 15) {
                            Text(emoji).font(.system(size: 32))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(name).font(.headline).foregroundColor(.white)
                                Text(isStrong ? "Day \(streak) streak" : "Streak lost")
                                    .font(.caption)
                                    .foregroundColor(isStrong ? iconColor : .red)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(screenTime).font(.headline).foregroundColor(.white)
                                Text("today").font(.caption).foregroundColor(normalTextColor.opacity(0.5))
                            }
                        }
                        .padding()
                        .background(cardColor)
                        .cornerRadius(12)
                    }
                }.padding(.horizontal)

                Spacer()
            }
        }
        .background(backgroundColor.ignoresSafeArea())
    }
}

#Preview { FriendsView() }
