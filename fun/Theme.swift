//
//  Theme.swift
//  Umrah Companion
//
//  A deliberately minimal, high-contrast palette and font helpers tuned for
//  reading in bright outdoor sunlight, plus lightweight haptic feedback.
//

import SwiftUI

#if os(iOS)
import UIKit
#endif

/// Central place for colors and fonts so the whole app stays consistent.
enum AppTheme {

    // High-contrast light palette: near-white ground, true-black text.
    static let background = Color(red: 0.99, green: 0.99, blue: 0.97)
    static let surface = Color.white
    static let primaryText = Color.black
    static let secondaryText = Color(white: 0.34)
    static let accent = Color(red: 0.02, green: 0.42, blue: 0.30)   // deep green
    static let accentSoft = Color(red: 0.02, green: 0.42, blue: 0.30).opacity(0.12)

    // Base point sizes (before the user's text-size multiplier is applied).
    private static let arabicBase: CGFloat = 34
    private static let transliterationBase: CGFloat = 21
    private static let englishBase: CGFloat = 21

    static func arabicFont(_ size: TextSize) -> Font {
        .system(size: arabicBase * size.scale, weight: .bold)
    }

    static func transliterationFont(_ size: TextSize) -> Font {
        .system(size: transliterationBase * size.scale, weight: .semibold).italic()
    }

    static func englishFont(_ size: TextSize) -> Font {
        .system(size: englishBase * size.scale, weight: .medium)
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
