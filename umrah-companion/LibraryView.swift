//
//  LibraryView.swift
//  Umrah Companion
//
//  The "Duas" tab: a standalone, browsable reference to every dua in the app,
//  independent of any session. Tap a dua to read it in full.
//

import SwiftUI

struct DuaLibraryView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        Text("Browse every dua in the app. Tap one to read it in full.")
                            .font(AppTheme.sans(16, weight: .medium))
                            .foregroundStyle(AppTheme.secondaryText)
                            .padding(.top, 4)

                        ForEach(DuaCategory.allCases) { category in
                            categorySection(category)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
            .preferredColorScheme(.light)
            .navigationTitle("Duas")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func categorySection(_ category: DuaCategory) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(category.rawValue, systemImage: category.systemImage)
                .font(AppTheme.serif(22, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)

            ForEach(DuaLibrary.duas(in: category)) { dua in
                NavigationLink {
                    DuaDetailView(dua: dua)
                } label: {
                    duaRow(dua)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func duaRow(_ dua: Dua) -> some View {
        HStack(spacing: 14) {
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

            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(AppTheme.secondaryText.opacity(0.5))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(AppTheme.surface))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppTheme.secondaryText.opacity(0.15)))
    }
}

// MARK: - Detail

/// Reads a single dua in full. As a reference it always shows every script,
/// regardless of the session display preferences.
struct DuaDetailView: View {
    let dua: Dua

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text(dua.category.rawValue.uppercased())
                        .font(AppTheme.sans(13, weight: .bold))
                        .tracking(1.5)
                        .foregroundStyle(AppTheme.gold)
                    Text(dua.title)
                        .font(AppTheme.serif(26, weight: .semibold))
                        .foregroundStyle(AppTheme.primaryText)
                        .multilineTextAlignment(.center)
                }

                Text(dua.arabic)
                    .font(AppTheme.arabicFont(.large))
                    .foregroundStyle(AppTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(12)
                    .environment(\.layoutDirection, .rightToLeft)

                Text(dua.transliteration)
                    .font(AppTheme.transliterationFont(.medium))
                    .foregroundStyle(AppTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)

                Divider()
                    .padding(.horizontal, 40)

                Text(dua.english)
                    .font(AppTheme.englishFont(.medium))
                    .foregroundStyle(AppTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)

                if let reference = dua.reference {
                    Text(reference)
                        .font(AppTheme.sans(14, weight: .medium))
                        .foregroundStyle(AppTheme.secondaryText)
                        .padding(.top, 4)
                }
            }
            .frame(maxWidth: 640)
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.background)
        .preferredColorScheme(.light)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DuaLibraryView()
}
