import SwiftUI

struct StrictModeChallengeView: View {
    @Environment(\.dismiss) var dismiss
    let onComplete: () -> Void

    @State private var stage = 0
    @State private var tapCount = 0
    @State private var waitTimeRemaining = 10
    @State private var timer: Timer?

    private let stages: [(type: StageType, value: Int)] = [
        (.tap, 10), (.wait, 10), (.tap, 20), (.wait, 10), (.tap, 30), (.wait, 10)
    ]

    private let waitMessages = [
        "Is this really what you want?",
        "Your friends will see you gave up...",
        "Breathe. Think about why you started."
    ]

    private let tapMessages = [
        "Are you sure this is a wise move?",
        "You were doing so well...",
        "Last chance to stay strong."
    ]

    private enum StageType { case tap, wait }

    var body: some View {
        VStack(spacing: 30) {
            Text("Moment of Weakness")
                .font(.title2).fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 40)

            Text(currentMessage)
                .font(.subheadline)
                .foregroundColor(normalTextColor.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            HStack(spacing: 8) {
                ForEach(0..<6, id: \.self) { i in
                    Circle()
                        .fill(i < stage ? .red : (i == stage ? .white : cardColor))
                        .frame(width: 12, height: 12)
                }
            }

            if stage < stages.count {
                let current = stages[stage]

                if current.type == .tap {
                    VStack(spacing: 20) {
                        Text("\(tapCount) / \(current.value)")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.red.opacity(0.8))

                        Button(action: { handleTap() }) {
                            Circle()
                                .fill(cardColor)
                                .frame(width: 200, height: 200)
                                .overlay(
                                    Text("TAP")
                                        .font(.title).fontWeight(.bold)
                                        .foregroundColor(.white.opacity(0.6))
                                )
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Text("\(waitTimeRemaining)")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(.white.opacity(0.3))

                        Text("Take a breath...")
                            .font(.headline)
                            .foregroundColor(normalTextColor.opacity(0.5))
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Text("If you insist...")
                        .font(.title2)
                        .foregroundColor(normalTextColor.opacity(0.6))

                    Button("Give Up") {
                        StreakManager.resetStreak()
                        onComplete()
                        dismiss()
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                }
            }

            Spacer()

            if stage < stages.count {
                Button("Stay Strong") {
                    timer?.invalidate()
                    dismiss()
                }
                .font(.headline)
                .foregroundColor(iconColor)
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor.ignoresSafeArea())
        .onAppear { startStage() }
        .onDisappear { timer?.invalidate() }
    }

    private var currentMessage: String {
        let index = stage / 2
        if stage < stages.count {
            return stages[stage].type == .wait ? waitMessages[min(index, 2)] : tapMessages[min(index, 2)]
        }
        return ""
    }

    private func handleTap() {
        guard stage < stages.count, stages[stage].type == .tap else { return }
        tapCount += 1
        if tapCount >= stages[stage].value { advanceStage() }
    }

    private func advanceStage() {
        timer?.invalidate()
        stage += 1
        tapCount = 0
        waitTimeRemaining = 10
        if stage < stages.count { startStage() }
    }

    private func startStage() {
        guard stage < stages.count, stages[stage].type == .wait else { return }
        waitTimeRemaining = stages[stage].value
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if waitTimeRemaining > 1 { waitTimeRemaining -= 1 }
            else { advanceStage() }
        }
    }
}

#Preview { StrictModeChallengeView(onComplete: {}) }
