//
//  SessionView.swift
//  Umrah Companion
//
//  The active ritual screen: a corner counter over a large, centered dua reader
//  with a big "Next" control for advancing the personal queue one-handed.
//

import SwiftUI

#if os(iOS)
import UIKit
#endif

struct SessionView: View {
    let mode: PilgrimageMode
    let queue: [Dua]

    @Environment(AppSettings.self) private var settings
    @Environment(SessionStore.self) private var sessions
    @Environment(\.dismiss) private var dismiss

    @State private var count = 0
    @State private var index = 0

    private var currentDua: Dua? {
        guard queue.indices.contains(index) else { return nil }
        return queue[index]
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            AppTheme.background.ignoresSafeArea()

            // Reader fills the screen; counter floats in the corner above it.
            VStack(spacing: 0) {
                header
                    .padding(.horizontal, 20)
                    .padding(.top, 4)

                DuaReaderView(dua: currentDua, isEmptyQueue: queue.isEmpty)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                if !queue.isEmpty {
                    controls
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                }
            }

            CounterView(mode: mode, count: $count)
                .padding(.trailing, 16)
                .padding(.top, 4)
        }
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: enableIdleTimerIfNeeded)
        .onDisappear(perform: endSession)
    }

    // MARK: Header

    private var header: some View {
        HStack(alignment: .top) {
            Button(action: { dismiss() }) {
                Label("Done", systemImage: "chevron.left")
                    .font(AppTheme.sans(17, weight: .semibold))
                    .foregroundStyle(AppTheme.accent)
            }
            .buttonStyle(.plain)

            Spacer()

            VStack(spacing: 2) {
                Text(mode.title)
                    .font(AppTheme.serif(18, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)
                if !queue.isEmpty {
                    Text("Dua \(index + 1) of \(queue.count)")
                        .font(AppTheme.sans(13, weight: .medium))
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }

            Spacer()
            // Balance the leading button so the title stays centered.
            Color.clear.frame(width: 110, height: 1)
        }
        // Leave room so the header never slides under the corner counter.
        .padding(.trailing, 96)
    }

    // MARK: Controls

    private var controls: some View {
        HStack(spacing: 14) {
            Button(action: previous) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .bold))
                    .frame(width: 64, height: 68)
                    .background(RoundedRectangle(cornerRadius: 18).fill(AppTheme.surface))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppTheme.secondaryText.opacity(0.25)))
                    .foregroundStyle(AppTheme.primaryText)
            }
            .buttonStyle(.plain)
            .disabled(queue.count < 2)
            .opacity(queue.count < 2 ? 0.4 : 1)

            Button(action: next) {
                Text("Next")
                    .font(AppTheme.serif(24, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 68)
                    .background(RoundedRectangle(cornerRadius: 18).fill(AppTheme.accent))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .disabled(queue.count < 2)
            .opacity(queue.count < 2 ? 0.6 : 1)
        }
    }

    // MARK: Queue navigation (wraps around for continuous dhikr)

    private func next() {
        guard !queue.isEmpty else { return }
        withAnimation(.snappy) {
            index = (index + 1) % queue.count
        }
        Haptics.tap()
    }

    private func previous() {
        guard !queue.isEmpty else { return }
        withAnimation(.snappy) {
            index = (index - 1 + queue.count) % queue.count
        }
        Haptics.tap()
    }

    // MARK: Keep the screen awake during a session

    private func enableIdleTimerIfNeeded() {
        #if os(iOS)
        if settings.keepScreenAwake {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        #endif
    }

    private func restoreIdleTimer() {
        #if os(iOS)
        UIApplication.shared.isIdleTimerDisabled = false
        #endif
    }

    /// Saves the session for the dashboard, then restores the idle timer.
    private func endSession() {
        sessions.record(mode: mode, count: count)
        restoreIdleTimer()
    }
}

// MARK: - Dua Reader

/// Displays the current dua large and centered, honoring the user's script and
/// text-size preferences. Scrolls if a long dua exceeds the available height.
struct DuaReaderView: View {
    let dua: Dua?
    let isEmptyQueue: Bool

    @Environment(AppSettings.self) private var settings

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                if let dua {
                    content(for: dua)
                } else if isEmptyQueue {
                    emptyState
                }
            }
            .frame(maxWidth: 640)
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            .frame(maxWidth: .infinity, minHeight: 320)
        }
    }

    @ViewBuilder
    private func content(for dua: Dua) -> some View {
        Text(dua.title.uppercased())
            .font(AppTheme.sans(14, weight: .bold))
            .tracking(1.5)
            .foregroundStyle(AppTheme.gold)

        if settings.showArabic {
            Text(dua.arabic)
                .font(AppTheme.arabicFont(settings.textSize))
                .foregroundStyle(AppTheme.primaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(12)
                .environment(\.layoutDirection, .rightToLeft)
        }

        if settings.showTransliteration {
            Text(dua.transliteration)
                .font(AppTheme.transliterationFont(settings.textSize))
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
        }

        if settings.showEnglish {
            Text(dua.english)
                .font(AppTheme.englishFont(settings.textSize))
                .foregroundStyle(AppTheme.primaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
        }

        if let reference = dua.reference {
            Text(reference)
                .font(AppTheme.sans(14, weight: .medium))
                .foregroundStyle(AppTheme.secondaryText)
                .padding(.top, 4)
        }

        if !settings.hasAtLeastOneScript {
            Text("All scripts are hidden — enable at least one in Settings.")
                .font(AppTheme.sans(15, weight: .medium))
                .foregroundStyle(.orange)
                .multilineTextAlignment(.center)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "hands.and.sparkles")
                .font(.system(size: 44))
                .foregroundStyle(AppTheme.accent)
            Text("No duas selected")
                .font(AppTheme.serif(23, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
            Text("Use the counter and make your own dua, or go back to add some to your queue.")
                .font(AppTheme.sans(17, weight: .medium))
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
    }
}
