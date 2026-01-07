import SwiftUI

// MARK: - Colors

let cardColor = Color(hex: "#1F2937")
let backgroundColor = Color(hex: "#111926")
let iconColor = Color(hex: "#FACC16")
let normalTextColor = Color.white

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    var enabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(enabled ? Color.white : cardColor)
            .foregroundColor(enabled ? Color.black : Color.white.opacity(0.5))
            .cornerRadius(25)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(cardColor)
            .foregroundColor(normalTextColor)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
