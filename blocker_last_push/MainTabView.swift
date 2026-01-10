import SwiftUI
import FamilyControls

struct MainTabView: View {
    @State private var isAuthorized = false

    var body: some View {
        TabView {
            HomeView(isAuthorized: $isAuthorized)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            BlocksView(isAuthorized: $isAuthorized)
                .tabItem {
                    Label("Blocks", systemImage: "lock.shield.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .accentColor(iconColor)
        .onAppear { checkAuthorization() }
    }

    private func checkAuthorization() {
        let systemApproved = AuthorizationCenter.shared.authorizationStatus == .approved
        let storedApproved = UserDefaults.standard.bool(forKey: "authorized")
        isAuthorized = systemApproved || storedApproved
    }
}

#Preview { MainTabView() }
