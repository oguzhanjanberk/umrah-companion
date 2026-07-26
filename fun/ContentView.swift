//
//  ContentView.swift
//  Umrah Companion
//
//  Home screen: pick a mode (Tawaf or Sa'i) or open Settings.
//

import SwiftUI

struct ContentView: View {
    @Environment(QueueStore.self) private var queues
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Umrah Companion")
                            .font(.system(size: 32, weight: .heavy))
                            .foregroundStyle(AppTheme.primaryText)
                        Text("Count your circuits. Keep your duas close.")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(AppTheme.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 12)

                    Spacer()

                    ForEach(PilgrimageMode.allCases) { mode in
                        NavigationLink {
                            DuaSelectionView(mode: mode)
                        } label: {
                            modeCard(mode)
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .preferredColorScheme(.light)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(AppTheme.accent)
                    }
                    .accessibilityLabel("Settings")
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }

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
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppTheme.primaryText)
                Text(mode.subtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(AppTheme.secondaryText)
                if saved > 0 {
                    Text("\(saved) duas in your queue")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppTheme.accent)
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

#Preview {
    ContentView()
        .environment(AppSettings())
        .environment(QueueStore())
}
