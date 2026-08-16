//
//  Theme.swift
//  Umrah Companion
//
//  A calm, wellness-oriented palette (muted sage, warm sand, subtle gold) and a
//  serif-heading / sans-body type system, plus lightweight haptic feedback.
//

import SwiftUI

#if os(iOS)
import UIKit
#endif

/// Central place for colors and fonts so the whole app stays consistent.
enum AppTheme {

    // MARK: - Palette
    //
    // Muted, earthy, and easy on the eyes: warm sand grounds, soft sage green as
    // the primary accent, and an antique gold reserved for small highlights.

    /// Warm sand — the app background.
    static let background = Color(red: 0.96, green: 0.94, blue: 0.89)
    /// Soft warm off-white — cards and raised surfaces.
    static let surface = Color(red: 0.99, green: 0.98, blue: 0.95)
    /// Deep warm charcoal — primary text.
    static let primaryText = Color(red: 0.17, green: 0.17, blue: 0.15)
    /// Muted taupe — secondary text.
    static let secondaryText = Color(red: 0.44, green: 0.42, blue: 0.37)
    /// Soft sage/olive green — the primary accent.
    static let accent = Color(red: 0.35, green: 0.45, blue: 0.36)
    /// A translucent wash of the accent for selected/soft fills.
    static let accentSoft = Color(red: 0.35, green: 0.45, blue: 0.36).opacity(0.14)
    /// Muted antique gold — reserved for small, meaningful highlights.
    static let gold = Color(red: 0.74, green: 0.60, blue: 0.34)

    // MARK: - Typography
    //
    // Serif for headings/display, sans for body and UI. To adopt custom fonts,
    // add the files to the target + Info.plist and set the two names below — every
    // call site updates automatically.

    /// Custom serif family name, or `nil` to use the system serif (New York).
    static let serifFontName: String? = nil
    /// Custom sans family name, or `nil` to use the system sans (SF).
    static let sansFontName: String? = nil

    /// Serif type for headings, titles, and display numbers.
    static func serif(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        if let serifFontName {
            return .custom(serifFontName, size: size).weight(weight)
        }
        return .system(size: size, weight: weight, design: .serif)
    }

    /// Sans-serif type for body copy and UI labels.
    static func sans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        if let sansFontName {
            return .custom(sansFontName, size: size).weight(weight)
        }
        return .system(size: size, weight: weight, design: .default)
    }

    // MARK: - Dua reader fonts
    //
    // Base point sizes (before the user's text-size multiplier is applied).
    private static let arabicBase: CGFloat = 34
    private static let transliterationBase: CGFloat = 21
    private static let englishBase: CGFloat = 21

    static func arabicFont(_ size: TextSize) -> Font {
        // Arabic keeps the system face for correct script shaping.
        .system(size: arabicBase * size.scale, weight: .bold)
    }

    static func transliterationFont(_ size: TextSize) -> Font {
        sans(transliterationBase * size.scale, weight: .semibold).italic()
    }

    static func englishFont(_ size: TextSize) -> Font {
        sans(englishBase * size.scale, weight: .medium)
    }
}

/// Thin wrapper over the system haptic generators, no-op on platforms without them.
enum Haptics {
    static func tap() {
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        #endif
    }

    static func completion() {
        #if os(iOS)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }
}
