//
//  LiveActivityManager.swift
//  LiveActivitySample
//
//  Created by HuyPG on 24/2/25.
//

import ActivityKit
import SwiftUI

/// Manages Live Activities for the application, providing methods to start, update, and end activities.
@available(iOS 17.0, *)
class LiveActivityManager {
    /// Singleton instance of the LiveActivityManager.
    static let shared = LiveActivityManager()
    
    /// Holds the current Live Activity instance, if any.
    private var currentActivity: Activity<LiveActivityAttributes>?
    
    /// Private initializer to enforce singleton pattern.
    private init() {}
    
    /// Retrieves the currently active Live Activity, if it exists.
    /// - Returns: The current Activity instance, or nil if no activity is active.
    func getCurrentActivity() -> Activity<LiveActivityAttributes>? {
        return currentActivity
    }
    
    /// Starts a new Live Activity with the provided JSON data, using default values if not specified.
    /// - Parameter json: Optional JSON dictionary containing activity data (activityType, content, staleDate, gameName).
    func startActivity(json: [String: Any] = [:]) {
        // Check if Live Activities are enabled on the device
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities are not enabled")
            return
        }
        
        Task {
            // End the current activity if it exists
            if let activity = currentActivity {
                await activity.end(dismissalPolicy: .immediate)
            }
            
            // Create attributes from JSON, using defaults if not provided
            let attributes = LiveActivityAttributes(json: json)
            
            // Create default content state with values from JSON or defaults
            let defaultState = LiveActivityAttributes.ContentState(
                timeout: (json["content"] as? [String: Any])?["timeout"] as? TimeInterval ?? LiveActivityAttributes.ContentState.preview.timeout,
                title: (json["content"] as? [String: Any])?["title"] as? String ?? LiveActivityAttributes.ContentState.preview.title, // Default "Default Title"
                subtitle: (json["content"] as? [String: Any])?["subtitle"] as? String ?? LiveActivityAttributes.ContentState.preview.subtitle, // Optional, nil if not provided
                textColor: (json["content"] as? [String: Any])?["textColor"] as? String ?? LiveActivityAttributes.ContentState.preview.textColor ?? "white", // Default "white"
                icon: (json["content"] as? [String: Any])?["icon"] as? String ?? LiveActivityAttributes.ContentState.preview.icon ?? "star", // Default "star" (SF Symbol)
                iconColor: (json["content"] as? [String: Any])?["iconColor"] as? String ?? LiveActivityAttributes.ContentState.preview.iconColor ?? "green", // Default "green"
                progressValue: (json["content"] as? [String: Any])?["progressValue"] as? Float ?? LiveActivityAttributes.ContentState.preview.progressValue, // Optional, nil if not provided
                progressColor: (json["content"] as? [String: Any])?["progressColor"] as? String ?? LiveActivityAttributes.ContentState.preview.progressColor ?? "green", // Default "green"
                progressLabelColor: (json["content"] as? [String: Any])?["progressLabelColor"] as? String ?? LiveActivityAttributes.ContentState.preview.progressLabelColor ?? "green", // Default "green"
                endTimestamp: (json["content"] as? [String: Any])?["endTimestamp"] as? Int ?? LiveActivityAttributes.ContentState.preview.endTimestamp, // Optional, nil if not provided
                countdownLabel: (json["content"] as? [String: Any])?["countdownLabel"] as? String ?? LiveActivityAttributes.ContentState.preview.countdownLabel, // Optional, nil if not provided
                countdownColor: (json["content"] as? [String: Any])?["countdownColor"] as? String ?? LiveActivityAttributes.ContentState.preview.countdownColor ?? "black", // Default "black"
                ctaText: (json["content"] as? [String: Any])?["ctaText"] as? String ?? LiveActivityAttributes.ContentState.preview.ctaText, // Optional, nil if not provided
                ctaColor: (json["content"] as? [String: Any])?["ctaColor"] as? String ?? LiveActivityAttributes.ContentState.preview.ctaColor ?? "black" // Default "black"
            )
            
            // Create activity content with the state and stale date (default 1 hour)
            let content = ActivityContent(
                state: defaultState,
                staleDate: (json["staleDate"] as? String).flatMap { ISO8601DateFormatter().date(from: $0) } ?? Date().addingTimeInterval(3600)
            )
            
            do {
                // Request the Live Activity with attributes and content
                let activity = try Activity.request(
                    attributes: attributes,
                    content: content,
                    pushType: nil
                )
                self.currentActivity = activity
                print("Live Activity started: \(attributes.activityType)")
                
                // Schedule automatic end based on timeout
                if let timeout = defaultState.timeout {
                    Task {
                        try? await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000)) // Convert seconds to nanoseconds
                        await endActivityIfExists()
                    }
                }
            } catch {
                print("Error starting Live Activity: \(error)")
            }
        }
    }
    
    /// Updates the current Live Activity with the provided JSON data, using current values as fallback.
    /// - Parameter json: Optional JSON dictionary containing updated activity data.
    func updateActivity(json: [String: Any] = [:]) {
        Task {
            // Check if there is a current activity to update
            guard let currentActivity = currentActivity else { return }
            
            // Create updated content state with values from JSON or current state
            let defaultState = LiveActivityAttributes.ContentState(
                timeout: (json["content"] as? [String: Any])?["timeout"] as? TimeInterval ?? LiveActivityAttributes.ContentState.preview.timeout,
                title: (json["content"] as? [String: Any])?["title"] as? String ?? currentActivity.content.state.title, // Keep old value if not provided
                subtitle: (json["content"] as? [String: Any])?["subtitle"] as? String ?? currentActivity.content.state.subtitle,
                textColor: (json["content"] as? [String: Any])?["textColor"] as? String ?? currentActivity.content.state.textColor ?? LiveActivityAttributes.ContentState.preview.textColor ?? "white",
                icon: (json["content"] as? [String: Any])?["icon"] as? String ?? currentActivity.content.state.icon ?? LiveActivityAttributes.ContentState.preview.icon ?? "star",
                iconColor: (json["content"] as? [String: Any])?["iconColor"] as? String ?? currentActivity.content.state.iconColor ?? LiveActivityAttributes.ContentState.preview.iconColor ?? "green",
                progressValue: (json["content"] as? [String: Any])?["progressValue"] as? Float ?? currentActivity.content.state.progressValue,
                progressColor: (json["content"] as? [String: Any])?["progressColor"] as? String ?? currentActivity.content.state.progressColor ?? LiveActivityAttributes.ContentState.preview.progressColor ?? "green",
                progressLabelColor: (json["content"] as? [String: Any])?["progressLabelColor"] as? String ?? currentActivity.content.state.progressLabelColor ?? LiveActivityAttributes.ContentState.preview.progressLabelColor ?? "green",
                endTimestamp: (json["content"] as? [String: Any])?["endTimestamp"] as? Int ?? currentActivity.content.state.endTimestamp,
                countdownLabel: (json["content"] as? [String: Any])?["countdownLabel"] as? String ?? currentActivity.content.state.countdownLabel,
                countdownColor: (json["content"] as? [String: Any])?["countdownColor"] as? String ?? currentActivity.content.state.countdownColor ?? LiveActivityAttributes.ContentState.preview.countdownColor ?? "black",
                ctaText: (json["content"] as? [String: Any])?["ctaText"] as? String ?? currentActivity.content.state.ctaText,
                ctaColor: (json["content"] as? [String: Any])?["ctaColor"] as? String ?? currentActivity.content.state.ctaColor ?? LiveActivityAttributes.ContentState.preview.ctaColor ?? "black"
            )
            
            // Create updated activity content with the new state and stale date
            let content = ActivityContent(
                state: defaultState,
                staleDate: (json["staleDate"] as? String).flatMap { ISO8601DateFormatter().date(from: $0) } ?? currentActivity.content.staleDate ?? Date().addingTimeInterval(3600) // Default 1 hour
            )
            
            await currentActivity.update(content)
            print("Live Activity updated: \(currentActivity.attributes.activityType)")
        }
    }
    
    /// Ends all active Live Activities immediately.
    func endAllActivities() {
        Task {
            // Iterate through all active activities and end them
            for activity in Activity<LiveActivityAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }
            currentActivity = nil
            print("All Live Activities ended")
        }
    }
    
    private func endActivityIfExists() {
        Task {
            guard let activity = currentActivity else { return }
            await activity.end(dismissalPolicy: .immediate)
            currentActivity = nil
            print("Live Activity ended due to timeout")
        }
    }
}
