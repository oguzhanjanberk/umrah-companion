//
//  Models.swift
//  Umrah Companion
//
//  Core data models, user settings, and the per-mode dua queue store.
//

import SwiftUI

// MARK: - Dua

/// A single supplication with its Arabic script, transliteration, and English meaning.
struct Dua: Identifiable, Hashable, Codable {
    let id: String
    let category: DuaCategory
    let title: String
    let arabic: String
    let transliteration: String
    let english: String
    /// Optional source (Qur'an reference or hadith collection).
    let reference: String?
}

// MARK: - Categories

/// Groupings shown in the dua library picker.
enum DuaCategory: String, CaseIterable, Identifiable, Codable {
    case tawaf = "Tawaf"
    case sai = "Sa'i"
    case dhikr = "Dhikr"
    case supplications = "Supplications"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .tawaf: return "arrow.trianglehead.clockwise"
        case .sai: return "arrow.left.and.right"
        case .dhikr: return "circle.hexagonpath"
        case .supplications: return "hands.and.sparkles"
        }
    }
}

// MARK: - Pilgrimage Mode

/// The two ritual modes. Both count to seven but differ in labels and imagery.
enum PilgrimageMode: String, CaseIterable, Identifiable, Codable {
    case tawaf
    case sai

    var id: String { rawValue }

    var title: String {
        switch self {
        case .tawaf: return "Tawaf"
        case .sai: return "Sa'i"
        }
    }

    var subtitle: String {
        switch self {
        case .tawaf: return "Circling the Ka'bah — 7 circuits"
        case .sai: return "Between Safa & Marwah — 7 laps"
        }
    }

    /// Name of a single counted unit (used in the counter label).
    var unitName: String {
        switch self {
        case .tawaf: return "Circuit"
        case .sai: return "Lap"
        }
    }

    /// Every mode here completes at seven.
    var target: Int { 7 }

    var systemImage: String {
        switch self {
        case .tawaf: return "arrow.trianglehead.clockwise"
        case .sai: return "figure.walk"
        }
    }

    /// The category most relevant to this mode, surfaced first in the picker.
    var featuredCategory: DuaCategory {
        switch self {
        case .tawaf: return .tawaf
        case .sai: return .sai
        }
    }
}

// MARK: - Text Size

/// Discrete text sizes — large stepped targets are easier to set one-handed than a slider.
enum TextSize: String, CaseIterable, Identifiable, Codable {
    case small
    case medium
    case large
    case extraLarge

    var id: String { rawValue }

    var label: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        case .extraLarge: return "Extra Large"
        }
    }

    var scale: CGFloat {
        switch self {
        case .small: return 0.85
        case .medium: return 1.0
        case .large: return 1.25
        case .extraLarge: return 1.55
        }
    }
}

// MARK: - Settings

/// App-wide display preferences, persisted to `UserDefaults`.
@Observable
final class AppSettings {
    var showArabic: Bool { didSet { defaults.set(showArabic, forKey: Keys.arabic) } }
    var showTransliteration: Bool { didSet { defaults.set(showTransliteration, forKey: Keys.translit) } }
    var showEnglish: Bool { didSet { defaults.set(showEnglish, forKey: Keys.english) } }
    var textSize: TextSize { didSet { defaults.set(textSize.rawValue, forKey: Keys.textSize) } }
    var keepScreenAwake: Bool { didSet { defaults.set(keepScreenAwake, forKey: Keys.awake) } }

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let arabic = "showArabic"
        static let translit = "showTransliteration"
        static let english = "showEnglish"
        static let textSize = "textSize"
        static let awake = "keepScreenAwake"
    }

    init() {
        // Default everything on for a first run; otherwise restore saved values.
        if defaults.object(forKey: Keys.arabic) == nil {
            showArabic = true
            showTransliteration = true
            showEnglish = true
            textSize = .large
            keepScreenAwake = true
        } else {
            showArabic = defaults.bool(forKey: Keys.arabic)
            showTransliteration = defaults.bool(forKey: Keys.translit)
            showEnglish = defaults.bool(forKey: Keys.english)
            textSize = TextSize(rawValue: defaults.string(forKey: Keys.textSize) ?? "") ?? .large
            keepScreenAwake = defaults.bool(forKey: Keys.awake)
        }
    }

    /// At least one script must be visible, or the reader would be blank.
    var hasAtLeastOneScript: Bool {
        showArabic || showTransliteration || showEnglish
    }
}

// MARK: - Queue Store

/// Holds the user's chosen dua queue for each mode, persisted as ordered id lists.
@Observable
final class QueueStore {
    private var tawafIDs: [String] { didSet { defaults.set(tawafIDs, forKey: Keys.tawaf) } }
    private var saiIDs: [String] { didSet { defaults.set(saiIDs, forKey: Keys.sai) } }

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let tawaf = "queue.tawaf"
        static let sai = "queue.sai"
    }

    init() {
        tawafIDs = defaults.stringArray(forKey: Keys.tawaf) ?? []
        saiIDs = defaults.stringArray(forKey: Keys.sai) ?? []
    }

    private func ids(for mode: PilgrimageMode) -> [String] {
        mode == .tawaf ? tawafIDs : saiIDs
    }

    private func setIDs(_ ids: [String], for mode: PilgrimageMode) {
        if mode == .tawaf { tawafIDs = ids } else { saiIDs = ids }
    }

    func contains(_ dua: Dua, in mode: PilgrimageMode) -> Bool {
        ids(for: mode).contains(dua.id)
    }

    /// Appends on select, removes on deselect — selection order is preserved.
    func toggle(_ dua: Dua, in mode: PilgrimageMode) {
        var current = ids(for: mode)
        if let index = current.firstIndex(of: dua.id) {
            current.remove(at: index)
        } else {
            current.append(dua.id)
        }
        setIDs(current, for: mode)
    }

    func count(for mode: PilgrimageMode) -> Int {
        ids(for: mode).count
    }

    func clear(_ mode: PilgrimageMode) {
        setIDs([], for: mode)
    }

    /// Resolves the stored ids to actual duas, dropping any that no longer exist.
    func duas(for mode: PilgrimageMode) -> [Dua] {
        ids(for: mode).compactMap { DuaLibrary.byID[$0] }
    }
}
