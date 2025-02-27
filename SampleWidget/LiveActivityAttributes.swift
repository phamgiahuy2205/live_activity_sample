//
//  LiveActivityAttributes.swift
//  LiveActivitySample
//
//  Created by HuyPG on 24/2/25.
//

import ActivityKit
import Foundation
import SwiftUI

/// Represents the attributes for a Live Activity, defining the structure and data for real-time updates in iOS 17+.
@available(iOS 17.0, *)
struct LiveActivityAttributes: ActivityAttributes {
    /// Defines the content state for the Live Activity, including all dynamic data.
    public struct ContentState: Codable, Hashable {
        /// The timeout duration in seconds after which the activity automatically ends, optional (default 60 seconds = 1 min).
        let timeout: TimeInterval?
        
        /// The main title of the Live Activity, required.
        let title: String
        
        /// The subtitle of the Live Activity, optional.
        let subtitle: String?
        
        /// The color for title and subtitle, using SwiftUI color names (e.g., "gray", "blue", "red", "orange", "yellow", "white", "black"), defaulting to "gray".
        let textColor: String?
        
        /// The icon name (SF Symbol or custom asset), optional.
        let icon: String?
        
        /// The color for the icon, using SwiftUI color names, defaulting to "blue".
        let iconColor: String?
        
        /// The progress value (0.0 to 1.0), used only for "progress" activity type, optional.
        let progressValue: Float?
        
        /// The color for the progress bar, using SwiftUI color names, defaulting to "orange".
        let progressColor: String?
        
        /// The color for the progress label, using SwiftUI color names, defaulting to "orange".
        let progressLabelColor: String?
        
        /// The Unix timestamp for the end time, used only for "countdown" activity type, optional.
        let endTimestamp: Int?
        
        /// The label describing the countdown, used only for "countdown" activity type, optional.
        let countdownLabel: String?
        
        /// The color for the countdown, using SwiftUI color names, defaulting to "yellow".
        let countdownColor: String?
        
        /// The call-to-action text, optional; if empty or nil, no button is displayed.
        let ctaText: String?
        
        /// The color for the CTA button, using SwiftUI color names, defaulting to "red".
        let ctaColor: String?
        
        /// Provides a preview state for testing and development.
        static var preview: ContentState {
            ContentState(
                timeout: 60,
                title: "Default Title",
                subtitle: "Tap to interact!",
                textColor: "white",
                icon: "star",
                iconColor: "green",
                progressValue: 0,
                progressColor: "green",
                progressLabelColor: "green",
                endTimestamp: Int(Date().timeIntervalSince1970) + 60, // Default 60 seconds from now
                countdownLabel: "Countdown",
                countdownColor: "green",
                ctaText: "Start Game",
                ctaColor: "blue"
            )
        }
    }
    
    /// The type of activity ("alert", "progress", "countdown"), required.
    let activityType: String
    
    /// The name of the game associated with the Live Activity, required.
    let gameName: String
    
    /// Unique identifier for the Live Activity type.
    static let liveActivityType = "com.yourcompany.GameLiveActivity"
}

/// Extension to initialize LiveActivityAttributes from JSON data.
@available(iOS 17.0, *)
extension LiveActivityAttributes {
    /// Initializes the attributes from a JSON dictionary.
    /// - Parameter json: A dictionary containing JSON data.
    init(json: [String: Any]) {
        self.activityType = json["activityType"] as? String ?? "alert"
        self.gameName = json["gameName"] as? String ?? "Game Name"
    }
    
    /// Creates a ContentState instance from JSON data.
    /// - Parameter json: A dictionary containing JSON data for the content state.
    /// - Returns: An optional ContentState instance, or nil if the JSON is invalid.
    static func contentState(from json: [String: Any]) -> ContentState? {
        guard let content = json["content"] as? [String: Any] else { return nil }
        return ContentState(
            timeout: content["timeout"] as? TimeInterval,
            title: content["title"] as? String ?? "",
            subtitle: content["subtitle"] as? String,
            textColor: content["textColor"] as? String,
            icon: content["icon"] as? String,
            iconColor: content["iconColor"] as? String,
            progressValue: content["progressValue"] as? Float,
            progressColor: content["progressColor"] as? String,
            progressLabelColor: content["progressLabelColor"] as? String,
            endTimestamp: content["endTimestamp"] as? Int,
            countdownLabel: content["countdownLabel"] as? String,
            countdownColor: content["countdownColor"] as? String,
            ctaText: content["ctaText"] as? String,
            ctaColor: content["ctaColor"] as? String
        )
    }
}
