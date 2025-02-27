//
//  Utils.swift
//  LiveActivitySample
//
//  Created by HuyPG on 25/2/25.
//

import SwiftUI

/// Utility to convert SwiftUI color names to Color, defaulting to white.
struct ColorUtils {
    static func colorFromName(_ colorName: String?) -> Color {
        let name = colorName?.lowercased() ?? "white"
        
        switch name {
        case "gray": return .gray
        case "blue": return .blue
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "white": return .white
        case "black": return .black
        case "green": return .green
        case "purple": return .purple
        case "pink": return .pink
        case "clear": return .clear
        case "primary": return .primary
        case "secondary": return .secondary
        case "mint", "teal", "cyan", "indigo", "brown":
            if #available(iOS 15.0, *) {
                switch name {
                case "mint": return .mint
                case "teal": return .teal
                case "cyan": return .cyan
                case "indigo": return .indigo
                case "brown": return .brown
                default: return .white
                }
            } else {
                return fallbackColor(for: name)
            }
        default: return .white
        }
    }
    
    /// Provides fallback colors for iOS versions before 15.0.
    private static func fallbackColor(for name: String) -> Color {
        switch name {
        case "mint": return .green
        case "teal", "cyan": return .blue
        case "indigo": return .blue
        case "brown": return .gray
        default: return .white
        }
    }
}
