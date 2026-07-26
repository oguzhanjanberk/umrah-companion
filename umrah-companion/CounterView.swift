//
//  CounterView.swift
//  Umrah Companion
//
//  The persistent corner counter: tap to increment toward seven, with a
//  completion cue and a one-tap undo.
//

import SwiftUI

struct CounterView: View {
    let mode: PilgrimageMode
    @Binding var count: Int

    /// Fires once the moment the count first reaches the target.
    private var isComplete: Bool { count >= mode.target }

    @State private var pulse = false

    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            // Tappable counter — a large, high-contrast target for the corner.
            Button(action: increment) {
                VStack(spacing: 2) {
                    Text("\(count)")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText(value: Double(count)))
                    Text("of \(mode.target)")
                        .font(.system(size: 13, weight: .semibold))
                        .opacity(0.9)
                }
                .foregroundStyle(.white)
                .frame(width: 96, height: 96)
                .background(
                    Circle()
                        .fill(isComplete ? Color.green : AppTheme.accent)
                )
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 3)
                )
                .overlay(
                    // Expanding ring cue when a completion happens.
                    Circle()
                        .stroke(Color.green, lineWidth: 4)
                        .scaleEffect(pulse ? 1.6 : 1.0)
                        .opacity(pulse ? 0 : 0.8)
                )
                .shadow(color: .black.opacity(0.2), radius: 6, y: 3)
            }
            .buttonStyle(.plain)
            .disabled(isComplete)
            .accessibilityLabel("\(mode.unitName) counter")
            .accessibilityValue("\(count) of \(mode.target)")

            if isComplete {
                Text("Complete ✓")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.green)
                    .transition(.opacity)
            }

            // Undo appears as soon as there is something to undo.
            if count > 0 {
                Button(action: undo) {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(AppTheme.surface))
                        .overlay(Capsule().stroke(AppTheme.secondaryText.opacity(0.3)))
                        .foregroundStyle(AppTheme.primaryText)
                }
                .buttonStyle(.plain)
                .transition(.opacity)
            }
        }
        .animation(.snappy, value: count)
        .animation(.snappy, value: isComplete)
    }

    private func increment() {
        guard count < mode.target else { return }
        count += 1
        if count == mode.target {
            Haptics.completion()
            triggerPulse()
        } else {
            Haptics.tap()
        }
    }

    private func undo() {
        guard count > 0 else { return }
        count -= 1
        Haptics.tap()
    }

    private func triggerPulse() {
        pulse = false
        withAnimation(.easeOut(duration: 0.7)) {
            pulse = true
        }
    }
}
