//
//  SettingsView.swift
//  Umrah Companion
//
//  Text size and which scripts (Arabic / transliteration / English) to display,
//  with a live preview.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppSettings.self) private var settings
    @Environment(\.dismiss) private var dismiss

    /// A representative dua so the user sees their choices applied live.
    private let previewDua = DuaLibrary.byID["tawaf_corners"]!

    var body: some View {
        @Bindable var settings = settings

        NavigationStack {
            Form {
                Section("Display Language") {
                    Toggle("Arabic", isOn: $settings.showArabic)
                    Toggle("Transliteration", isOn: $settings.showTransliteration)
                    Toggle("English", isOn: $settings.showEnglish)

                    if !settings.hasAtLeastOneScript {
                        Text("Turn on at least one so duas remain readable.")
                            .font(.footnote)
                            .foregroundStyle(.orange)
                    }
                }

                Section("Text Size") {
                    Picker("Text Size", selection: $settings.textSize) {
                        ForEach(TextSize.allCases) { size in
                            Text(size.label).tag(size)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("During a Session") {
                    Toggle("Keep screen awake", isOn: $settings.keepScreenAwake)
                }

                Section("Preview") {
                    DuaReaderView(dua: previewDua, isEmptyQueue: false)
                        .frame(maxWidth: .infinity)
                        .listRowInsets(EdgeInsets())
                        .background(AppTheme.background)
                }

                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Umrah Companion")
                            .font(.headline)
                        Text("Works fully offline. No account, no tracking.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
