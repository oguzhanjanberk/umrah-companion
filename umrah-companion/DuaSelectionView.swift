//
//  DuaSelectionView.swift
//  Umrah Companion
//
//  Before a session begins the user browses the categorized library and taps to
//  build a personal queue, then starts the ritual.
//

import SwiftUI

struct DuaSelectionView: View {
    let mode: PilgrimageMode

    @Environment(QueueStore.self) private var queues
    @State private var startSession = false

    /// Show the mode's own category first, then the rest.
    private var orderedCategories: [DuaCategory] {
        let featured = mode.featuredCategory
        return [featured] + DuaCategory.allCases.filter { $0 != featured }
    }

    private var selectedCount: Int { queues.count(for: mode) }

    var body: some View {
        ZStack(alignment: .bottom) {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Text("Tap duas to add them to your queue. They'll appear in the order you pick them.")
                        .font(AppTheme.sans(16, weight: .medium))
                        .foregroundStyle(AppTheme.secondaryText)
                        .padding(.top, 4)

                    ForEach(orderedCategories) { category in
                        categorySection(category)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 130)   // clear the pinned start bar
            }

            startBar
        }
        .preferredColorScheme(.light)
        .navigationTitle(mode.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if selectedCount > 0 {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") { queues.clear(mode) }
                        .foregroundStyle(AppTheme.accent)
                }
            }
        }
        .fullScreenCover(isPresented: $startSession) {
            SessionView(mode: mode, queue: queues.duas(for: mode))
        }
    }

    // MARK: Category section

    private func categorySection(_ category: DuaCategory) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(category.rawValue, systemImage: category.systemImage)
                .font(AppTheme.serif(22, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)

            ForEach(DuaLibrary.duas(in: category)) { dua in
                duaRow(dua)
            }
        }
    }

    private func duaRow(_ dua: Dua) -> some View {
        let selected = queues.contains(dua, in: mode)
        return Button {
            queues.toggle(dua, in: mode)
            Haptics.tap()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 26))
                    .foregroundStyle(selected ? AppTheme.accent : AppTheme.secondaryText.opacity(0.5))

                VStack(alignment: .leading, spacing: 4) {
                    Text(dua.title)
                        .font(AppTheme.serif(19, weight: .medium))
                        .foregroundStyle(AppTheme.primaryText)
                    Text(dua.english)
                        .font(AppTheme.sans(15, weight: .regular))
                        .foregroundStyle(AppTheme.secondaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(selected ? AppTheme.accentSoft : AppTheme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selected ? AppTheme.accent : AppTheme.secondaryText.opacity(0.15),
                            lineWidth: selected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: Start bar

    private var startBar: some View {
        VStack(spacing: 0) {
            Divider()
            Button {
                startSession = true
            } label: {
                HStack {
                    Image(systemName: mode.systemImage)
                    Text(selectedCount > 0 ? "Begin \(mode.title) · \(selectedCount) duas" : "Begin \(mode.title)")
                }
                .font(AppTheme.serif(22, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(RoundedRectangle(cornerRadius: 18).fill(AppTheme.accent))
                .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
        .background(.ultraThinMaterial)
    }
}
