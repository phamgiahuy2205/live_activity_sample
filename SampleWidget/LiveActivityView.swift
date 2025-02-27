//
//  LiveActivityView.swift
//  LiveActivitySample
//
//  Created by HuyPG on 24/2/25.
//

import SwiftUI
import ActivityKit
import WidgetKit

/// A view representing a Live Activity for real-time updates in iOS 17+.
@available(iOS 17.0, *)
struct LiveActivityView: View {
    let context: ActivityViewContext<LiveActivityAttributes> // Data from the Live Activity
    @State private var animateProgress = false
    @State private var animateCountdown = false
    @State private var remainingSeconds: Int?
    
    var body: some View {
        ZStack {
            switch context.attributes.activityType {
            case "alert":
                alertView
            case "progress":
                progressView
            case "countdown":
                countdownView
            default:
                alertView
            }
        }
        .onAppear {
            // Start animations for progress and countdown on view appearance
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animateProgress = true
                animateCountdown = true
            }
        }
    }
    
    /// View for alert-type Live Activity, displayed as a horizontal layout.
    private var alertView: some View {
        HStack(spacing: 12) {
            iconView
                .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 6) {
                Text(context.state.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(ColorUtils.colorFromName(context.state.textColor))
                    .lineLimit(1)
                if let subtitle = context.state.subtitle {
                    Text(subtitle)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ColorUtils.colorFromName(context.state.textColor).opacity(0.9))
                        .lineLimit(2)
                }
            }
            Spacer()
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
    }
    
    /// View for progress-type Live Activity, displayed as a vertical layout with a progress bar.
    private var progressView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 12) {
                iconView
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 6) {
                    Text(context.state.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorUtils.colorFromName(context.state.textColor))
                        .lineLimit(2)
                    if let subtitle = context.state.subtitle {
                        Text(subtitle)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(ColorUtils.colorFromName(context.state.textColor).opacity(0.9))
                            .lineLimit(2)
                    }
                }
                Spacer()
            }
            Spacer()
            if let progress = context.state.progressValue {
                ProgressView(value: progress)
                    .progressViewStyle(.linear)
                    .tint(ColorUtils.colorFromName(context.state.progressColor))
                    .cornerRadius(10)
                    .padding(0)
                    .scaleEffect(animateProgress ? 1.05 : 1.0) // Add scale animation for progress
                    .animation(.easeInOut(duration: 0.8), value: animateProgress)
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(ColorUtils.colorFromName(context.state.progressLabelColor))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .activityBackgroundTint(Color.black)
        .background(Color.black)
    }
    
    /// View for countdown-type Live Activity, displayed as a vertical layout with a countdown timer.
    private var countdownView: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 12) {
                    iconView
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(context.state.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(ColorUtils.colorFromName(context.state.textColor))
                            .lineLimit(1)
                        if let subtitle = context.state.subtitle {
                            Text(subtitle)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(ColorUtils.colorFromName(context.state.textColor).opacity(0.9))
                                .lineLimit(2)
                        }
                    }
                    Spacer()
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 24)
            }
            .activityBackgroundTint(Color.black)
            .background(Color.black)
            VStack {
                if let endTimestamp = context.state.endTimestamp {
                    let remaining = max(0, endTimestamp - Int(Date().timeIntervalSince1970))
                    let minutes = remaining / 60
                    let seconds = remaining % 60
                    Text(String(format: "%02d:%02d", minutes, seconds))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(ColorUtils.colorFromName(context.state.countdownColor)) // Default countdown color to yellow
                        .frame(maxWidth: .infinity, alignment: .center)
                        .scaleEffect(animateCountdown ? 1.1 : 1.0) // Add scale animation for countdown
                        .animation(.easeInOut(duration: 0.5), value: animateCountdown)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                }
            }
            .activityBackgroundTint(Color.gray.opacity(0.1))
            .background(Color.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// Starts a timer to update the countdown every second.
    private func startCountdownTimer() {
        guard context.attributes.activityType == "countdown", let endTimestamp = context.state.endTimestamp else { return }
        remainingSeconds = max(0, endTimestamp - Int(Date().timeIntervalSince1970))
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            guard let currentEnd = context.state.endTimestamp else {
                timer.invalidate()
                remainingSeconds = nil
                return
            }
            remainingSeconds = max(0, currentEnd - Int(Date().timeIntervalSince1970))
            if remainingSeconds == 0 {
                timer.invalidate()
            }
        }
    }
    
    /// Stops the countdown timer when the view disappears.
    private func stopCountdownTimer() {
        remainingSeconds = nil
    }
    
    /// Builds the icon view, supporting both SF Symbols and custom assets.
    @ViewBuilder
    public var iconView: some View {
        if let icon = context.state.icon {
            if icon.hasPrefix("AppIcon") { // Custom game logo
                Image(icon) // Assume asset name like "game_logo1"
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(ColorUtils.colorFromName(context.state.iconColor))
            } else { // SF Symbol
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(ColorUtils.colorFromName(context.state.iconColor).opacity(0.9))
            }
        }
    }
}

@available(iOS 17.0, *)
struct LiveActivityConfiguration: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(
            for: LiveActivityAttributes.self, // Specify the generic type Attributes
            content: { context in
                LiveActivityView(context: context)
            },
            dynamicIsland: { context in
                DynamicIsland {
                    DynamicIslandExpandedRegion(.leading) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(context.state.title)
                                .frame(maxWidth: 230, alignment: .leading)
                                .lineLimit(1, reservesSpace: false)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(ColorUtils.colorFromName(context.state.textColor))
                            if let subtitle = context.state.subtitle {
                                Text(subtitle)
                                    .padding(.vertical, 4)
                                    .frame(maxWidth: 230, alignment: .leading)
                                    .lineLimit(2, reservesSpace: false)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(ColorUtils.colorFromName(context.state.textColor).opacity(0.9))
                            }
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        .dynamicIsland(verticalPlacement: .belowIfTooWide)
                        .frame(minHeight: 80)
                    }
                    DynamicIslandExpandedRegion(.center) {
                        EmptyView()
                    }
                    DynamicIslandExpandedRegion(.trailing) {
                        VStack(alignment: .center) {
                            LiveActivityView(context: context).iconView
                                .frame(width: 70, height: 70)
                        }
                        .frame(maxHeight: .infinity)
                    }
                    DynamicIslandExpandedRegion(.bottom) { // Move progress and countdown to bottom
                        switch context.attributes.activityType {
                        case "alert":
                            EmptyView()
                            
                        case "progress":
                            if let progress = context.state.progressValue {
                                VStack(alignment: .leading, spacing: 4) {
                                    ProgressView(value: progress)
                                        .frame(height: 8)
                                        .cornerRadius(10)
                                        .progressViewStyle(.linear)
                                        .tint(ColorUtils.colorFromName(context.state.progressColor)) // Default progress color to yellow
                                        .padding(.horizontal, 4)
                                    Text("\(Int(progress * 100))%")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(ColorUtils.colorFromName(context.state.progressLabelColor))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .frame(minHeight: 22)
                            } else {
                                EmptyView()
                            }
                            
                        case "countdown":
                            if let endTimestamp = context.state.endTimestamp {
                                VStack(alignment: .leading, spacing: 0) {
                                    let remaining = max(0, endTimestamp - Int(Date().timeIntervalSince1970))
                                    let minutes = remaining / 60
                                    let seconds = remaining % 60
                                    Text(String(format: "%02d:%02d", minutes, seconds))
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(ColorUtils.colorFromName(context.state.countdownColor))
                                }
                                .frame(minHeight: 20)
                            }
                            
                        default:
                            EmptyView()
                        }
                    }
                } compactLeading: {
                    if context.attributes.activityType == "progress" {
                        LiveActivityView(context: context).iconView
                            .frame(width: 20, height: 20) // Smaller size for compactLeading
                    } else {
                        EmptyView() // Do not display anything for other types
                    }
                } compactTrailing: {
                    if context.attributes.activityType == "progress", let progress = context.state.progressValue {
                        ProgressView(value: progress)
                            .progressViewStyle(.circular) // Use circular style for progress
                            .tint(ColorUtils.colorFromName(context.state.progressColor)) // Default progress color to yellow
                            .scaleEffect(0.7) // Reduce size to fit compactTrailing (approximately 16x16)
                            .frame(width: 22, height: 22) // Ensure size fits compactTrailing
                    } else if context.attributes.activityType == "countdown", let endTimestamp = context.state.endTimestamp {
                        let remaining = max(0, endTimestamp - Int(Date().timeIntervalSince1970))
                        let minutes = remaining / 60
                        let seconds = remaining % 60
                        Text(String(format: "%02d:%02d", minutes, seconds))
                            .font(.caption)
                            .foregroundColor(ColorUtils.colorFromName(context.state.countdownColor)) // Keep countdown text as is
                    } else {
                        LiveActivityView(context: context).iconView
                            .frame(width: 20, height: 20)
                    }
                } minimal: {
                    if context.attributes.activityType == "progress", let progress = context.state.progressValue {
                        ProgressView(value: progress)
                            .progressViewStyle(.circular) // Use circular style for progress
                            .tint(ColorUtils.colorFromName(context.state.progressColor)) // Default progress color to yellow
                            .scaleEffect(0.7) // Reduce size to fit minimal (approximately 16x16)
                            .frame(width: 22, height: 22) // Ensure size fits minimal
                    } else {
                        LiveActivityView(context: context).iconView
                            .frame(width: 20, height: 20) // Keep icon for other types
                    }
                }
                .keylineTint(.green)
            }
        )
    }
}

@available(iOS 17.0, *)
extension LiveActivityAttributes {
    /// Preview data for an alert-type Live Activity.
    static var previewAlert: LiveActivityAttributes {
        LiveActivityAttributes(activityType: "alert", gameName: "Game Hub")
    }
    
    /// Preview data for a progress-type Live Activity.
    static var previewProgress: LiveActivityAttributes {
        LiveActivityAttributes(activityType: "progress", gameName: "Game Hub")
    }
    
    /// Preview data for a countdown-type Live Activity.
    static var previewCountdown: LiveActivityAttributes {
        LiveActivityAttributes(activityType: "countdown", gameName: "Game Hub")
    }
}

// Update previews to match common content, with default text color as white
@available(iOS 17.0, *)
#Preview("Alert", as: .content, using: LiveActivityAttributes.previewAlert) {
    LiveActivityConfiguration()
} contentStates: {
    LiveActivityAttributes.ContentState(
        timeout: 60,
        title: "New Game Alert",
        subtitle: "Exciting update available now!",
        textColor: "white",
        icon: "bell.fill",
        iconColor: "blue",
        progressValue: nil,
        progressColor: "green",
        progressLabelColor: "green",
        endTimestamp: nil,
        countdownLabel: nil,
        countdownColor: "yellow",
        ctaText: "Check Now",
        ctaColor: "blue"
    )
}

@available(iOS 17.0, *)
#Preview("Progress", as: .content, using: LiveActivityAttributes.previewProgress) {
    LiveActivityConfiguration()
} contentStates: {
    LiveActivityAttributes.ContentState(
        timeout: 60,
        title: "Level Up Progress",
        subtitle: "Completing level 5 of 10",
        textColor: "white",
        icon: "arrow.up.circle.fill",
        iconColor: "green",
        progressValue: 0.5, // 50% progress
        progressColor: "green",
        progressLabelColor: "white",
        endTimestamp: nil,
        countdownLabel: nil,
        countdownColor: "yellow",
        ctaText: "Continue",
        ctaColor: "green"
    )
}

@available(iOS 17.0, *)
#Preview("Countdown", as: .content, using: LiveActivityAttributes.previewCountdown) {
    LiveActivityConfiguration()
} contentStates: {
    LiveActivityAttributes.ContentState(
        timeout: 60,
        title: "Event Countdown",
        subtitle: "Hurry, event starts soon!",
        textColor: "white",
        icon: "clock.fill",
        iconColor: "red",
        progressValue: nil,
        progressColor: "green",
        progressLabelColor: "white",
        endTimestamp: Int(Date().timeIntervalSince1970) + 300, // 5 minutes from now
        countdownLabel: "Time Left",
        countdownColor: "yellow",
        ctaText: "Join Now",
        ctaColor: "red"
    )
}
