//
//  ContentView.swift
//  Umrah Companion
//
//  Root tab navigation: Home (dashboard), Duas (library), and Settings. The
//  active ritual is presented full-screen over the tabs from the Home flow.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            Tab("Duas", systemImage: "book") {
                DuaLibraryView()
            }
            Tab("Settings", systemImage: "gearshape") {
                SettingsView()
            }
        }
        .tint(AppTheme.accent)
    }
}

// MARK: - Home (Dashboard)

struct HomeView: View {
    @Environment(QueueStore.self) private var queues
    @Environment(SessionStore.self) private var sessions

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        header
                        streakCard
                        statsGrid

                        VStack(alignment: .leading, spacing: 14) {
                            Text("Begin a Ritual")
                                .font(AppTheme.serif(22, weight: .semibold))
                                .foregroundStyle(AppTheme.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ForEach(PilgrimageMode.allCases) { mode in
                                NavigationLink {
                                    DuaSelectionView(mode: mode)
                                } label: {
                                    modeCard(mode)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }
            .preferredColorScheme(.light)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: Header

    private var header: some View {
        VStack(spacing: 8) {
            Text("Umrah Companion")
                .font(AppTheme.serif(34, weight: .bold))
                .foregroundStyle(AppTheme.primaryText)
            Text("Count your circuits. Keep your duas close.")
                .font(AppTheme.sans(17, weight: .medium))
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 4)
    }

    // MARK: Streak hero card

    private var streakCard: some View {
        let streak = sessions.currentStreak
        return HStack(spacing: 18) {
            Image(systemName: "flame.fill")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(AppTheme.gold)
                .frame(width: 68, height: 68)
                .background(Circle().fill(.white.opacity(0.18)))

            VStack(alignment: .leading, spacing: 4) {
                Text(streak == 1 ? "1 day streak" : "\(streak) day streak")
                    .font(AppTheme.serif(27, weight: .bold))
                    .foregroundStyle(.white)
                Text(lastSessionText)
                    .font(AppTheme.sans(15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))
            }

            Spacer(minLength: 0)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(AppTheme.accent))
        .shadow(color: AppTheme.accent.opacity(0.25), radius: 10, y: 5)
    }

    private var lastSessionText: String {
        guard let date = sessions.lastSessionDate else {
            return "Start your first session today"
        }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return "Last session " + formatter.localizedString(for: date, relativeTo: Date())
    }

    // MARK: Stats grid

    private var statsGrid: some View {
        let columns = [
            GridItem(.flexible(), spacing: 14),
            GridItem(.flexible(), spacing: 14),
        ]
        return LazyVGrid(columns: columns, spacing: 14) {
            StatCard(
                icon: PilgrimageMode.tawaf.systemImage,
                value: "\(sessions.completedCount(for: .tawaf))",
                label: "Tawafs completed"
            )
            StatCard(
                icon: PilgrimageMode.sai.systemImage,
                value: "\(sessions.completedCount(for: .sai))",
                label: "Sa'i completed"
            )
            StatCard(
                icon: "arrow.trianglehead.clockwise",
                value: "\(sessions.totalCount(for: .tawaf))",
                label: "Circuits counted"
            )
            StatCard(
                icon: "arrow.left.and.right",
                value: "\(sessions.totalCount(for: .sai))",
                label: "Laps counted"
            )
        }
    }

    // MARK: Mode card

    private func modeCard(_ mode: PilgrimageMode) -> some View {
        let saved = queues.count(for: mode)
        return HStack(spacing: 20) {
            Image(systemName: mode.systemImage)
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 76, height: 76)
                .background(Circle().fill(AppTheme.accent))

            VStack(alignment: .leading, spacing: 6) {
                Text(mode.title)
                    .font(AppTheme.serif(28, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)
                Text(mode.subtitle)
                    .font(AppTheme.sans(16, weight: .medium))
                    .foregroundStyle(AppTheme.secondaryText)
                if saved > 0 {
                    Text("\(saved) duas in your queue")
                        .font(AppTheme.sans(14, weight: .semibold))
                        .foregroundStyle(AppTheme.gold)
                }
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppTheme.secondaryText)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(AppTheme.surface))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(AppTheme.secondaryText.opacity(0.15)))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

// MARK: - Stat Card

/// A compact dashboard tile: an icon, a large value, and a caption.
private struct StatCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 44, height: 44)
                .background(Circle().fill(AppTheme.accentSoft))

            Text(value)
                .font(AppTheme.serif(34, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
                .monospacedDigit()

            Text(label)
                .font(AppTheme.sans(14, weight: .semibold))
                .foregroundStyle(AppTheme.secondaryText)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20).fill(AppTheme.surface))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(AppTheme.secondaryText.opacity(0.15)))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
    }
}

#Preview {
    ContentView()
        .environment(AppSettings())
        .environment(QueueStore())
        .environment(SessionStore())
}
