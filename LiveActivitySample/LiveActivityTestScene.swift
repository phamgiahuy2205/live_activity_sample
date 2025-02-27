//
//  LiveActivityTestScene.swift
//  LiveActivitySample
//
//  Created by HuyPG on 24/2/25.
//
//

import SwiftUI

@available(iOS 17.0, *)
struct LiveActivityTestScene: View {
    @State private var selectedType = "alert" // Default value: "alert"
    @State private var timeout = "60" // Default value: "alert"
    @State private var title = "Default Title" // Default value from LiveActivityManager
    @State private var subtitle = "" // Default empty, optional
    @State private var textColor = "white"
    @State private var icon = "star" // Default "star" (SF Symbol)
    @State private var iconColor = "green" // Default "green" (changed from "blue" to match preview)
    @State private var progressValue = "0.6" // Default 0.6 (60%) for progress, matches preview
    @State private var progressColor = "green" // Default "green" (changed from "orange" to match preview)
    @State private var progressLabelColor = "green" // Default "green" (changed from "orange" to match preview)
    @State private var endTimestamp = "\(Int(Date().timeIntervalSince1970) + 60)" // Default 60 seconds from now for countdown
    @State private var countdownLabel = "Countdown" // Default value from preview
    @State private var countdownColor = "black" // Default "black" (changed from "yellow" to match preview)
    @State private var ctaText = "Start Game" // Default value from preview
    @State private var ctaColor = "black" // Default "black" (changed from "red" to match preview)
    
    let types = ["alert", "progress", "countdown"]
    let iconOptions = [
        "star", "play.circle", "clock", "arrow.down.circle", // Basic icons
        "info.circle.fill", "exclamationmark.triangle.fill", "checkmark.circle.fill", // Alert-related icons
        "arrow.up.circle.fill", "arrow.right.circle.fill", "arrow.left.circle.fill", // Progress/direction icons
        "timer", "hourglass", "stopwatch", // Countdown/time icons
        "heart.fill", "bolt.fill", "flame.fill", // General activity icons
        "gift.fill", "trophy.fill", "lightbulb.fill" // Additional engaging icons
    ]
    let colorOptions = ["gray", "blue", "red", "orange", "yellow", "white", "black", "green", "cyan"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) { // Increased spacing for better readability
                    // Activity Type Section
                    VStack(spacing: 8) {
                        Text("Activity Type")
                            .font(.title3)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                        Picker("Select Activity Type (e.g., Alert)", selection: $selectedType) {
                            ForEach(types, id: \.self) { type in
                                Text(type.capitalized).tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal, 16)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        HStack {
                            Text("Timeout (seconds, e.g., 300)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        TextField("", text: $timeout, prompt: Text("Enter seconds (e.g., 300)"))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding(.horizontal, 16)
                    }
                    
                    // Data Section
                    VStack(spacing: 16) {
                        Text("Activity Details")
                            .font(.title3)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                        
                        // Title
                        HStack {
                            Text("Title (e.g., 'New Event')")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        TextField("", text: $title, prompt: Text("Enter title here"))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 16)
                        
                        // Subtitle
                        HStack {
                            Text("Subtitle (e.g., 'Tap to join')")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        TextField("", text: $subtitle, prompt: Text("Optional description"))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 16)
                        
                        // Text Color
                        HStack {
                            Text("Text Color (e.g., White)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        Picker("Select Color", selection: $textColor) {
                            ForEach(colorOptions, id: \.self) { color in
                                Text(color.capitalized).tag(color)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal, 16)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        // Icon
                        HStack {
                            Text("Icon (e.g., Star)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        Picker("Select Icon", selection: $icon) {
                            ForEach(iconOptions, id: \.self) { option in
                                HStack {
                                    if option.hasPrefix("game_") {
                                        Image(option)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                    } else {
                                        Image(systemName: option)
                                            .frame(width: 20, height: 20)
                                    }
                                    Text(option)
                                }.tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal, 16)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        // Icon Color
                        HStack {
                            Text("Icon Color (e.g., Green)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        Picker("Select Color", selection: $iconColor) {
                            ForEach(colorOptions, id: \.self) { color in
                                Text(color.capitalized).tag(color)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal, 16)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        // Progress Fields (if progress selected)
                        if selectedType == "progress" {
                            // Progress Value
                            HStack {
                                Text("Progress (0.0-1.0, e.g., 0.6)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            TextField("", text: $progressValue, prompt: Text("Enter 0.0-1.0"))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .padding(.horizontal, 16)
                            
                            // Progress Label
                            HStack {
                                Text("Progress Label (e.g., 'Loading')")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            
                            // Progress Color
                            HStack {
                                Text("Progress Color (e.g., Green)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            Picker("Select Color", selection: $progressColor) {
                                ForEach(colorOptions, id: \.self) { color in
                                    Text(color.capitalized).tag(color)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal, 16)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            // Progress Label Color
                            HStack {
                                Text("Progress Label Color (e.g., Green)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            Picker("Select Color", selection: $progressLabelColor) {
                                ForEach(colorOptions, id: \.self) { color in
                                    Text(color.capitalized).tag(color)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal, 16)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        
                        // Countdown Fields (if countdown selected)
                        if selectedType == "countdown" {
                            // End Timestamp
                            HStack {
                                Text("End Timestamp (e.g., 1719456000)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            TextField("", text: $endTimestamp, prompt: Text("Unix timestamp"))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .padding(.horizontal, 16)
                            
                            // Countdown Label
                            HStack {
                                Text("Countdown Label (e.g., 'Time Left')")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            TextField("", text: $countdownLabel, prompt: Text("Optional label"))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 16)
                            
                            // Countdown Color
                            HStack {
                                Text("Countdown Color (e.g., Black)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            Picker("Select Color", selection: $countdownColor) {
                                ForEach(colorOptions, id: \.self) { color in
                                    Text(color.capitalized).tag(color)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal, 16)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        
                        // CTA Text
                        HStack {
                            Text("CTA Text (e.g., 'Start Now')")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        TextField("", text: $ctaText, prompt: Text("Call to action text"))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 16)
                        
                        // CTA Color
                        HStack {
                            Text("CTA Color (e.g., Black)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        Picker("Select Color", selection: $ctaColor) {
                            ForEach(colorOptions, id: \.self) { color in
                                Text(color.capitalized).tag(color)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal, 16)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    
                    // Actions Section
                    VStack(spacing: 12) {
                        Text("Actions")
                            .font(.title3)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                        
                        Button("Start Activity") {
                            startActivity()
                            showSystemToast(message: "Started activity: \(title)")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        
                        Button("Update Activity") {
                            updateActivity()
                            showSystemToast(message: "Updated activity: \(title)")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        
                        Button("Delete Activity") {
                            LiveActivityManager.shared.endAllActivities()
                            showSystemToast(message: "Deleted all activities!")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 20) // Increased bottom padding to avoid keyboard overlap
                }
                .navigationTitle("Live Activity Test")
            }
            .onTapGesture { // Hide keyboard when tapping outside
                hideKeyboard()
            }
        }
    }
    
    private func buildJson() -> [String: Any] {
        var content: [String: Any] = [
            "title": title,
            "subtitle": subtitle.isEmpty ? nil : subtitle,
            "textColor": textColor.isEmpty ? nil : textColor,
            "icon": icon.isEmpty ? nil : icon,
            "iconColor": iconColor.isEmpty ? nil : iconColor,
            "timeout": timeout.isEmpty ? nil : TimeInterval(timeout)
        ]
        
        if selectedType == "progress", let progress = Float(progressValue) {
            content["progressValue"] = progress
        }
        if !progressColor.isEmpty { content["progressColor"] = progressColor }
        if !progressLabelColor.isEmpty { content["progressLabelColor"] = progressLabelColor }
        
        if selectedType == "countdown", let timestamp = Int(endTimestamp) {
            content["endTimestamp"] = timestamp
        }
        if !countdownLabel.isEmpty { content["countdownLabel"] = countdownLabel }
        if !countdownColor.isEmpty { content["countdownColor"] = countdownColor }
        
        if !ctaText.isEmpty { content["ctaText"] = ctaText }
        if !ctaColor.isEmpty { content["ctaColor"] = ctaColor }
        
        // Add timeout if provided
        if let timeout = Int(timeout), timeout > 0 {
            return [
                "activityType": selectedType,
                "content": content,
                "staleDate": ISO8601DateFormatter().string(from: Date().addingTimeInterval(3600)),
                "gameName": "Game Name",
            ].compactMapValues { $0 }
        }
        
        return [
            "activityType": selectedType,
            "content": content,
            "staleDate": ISO8601DateFormatter().string(from: Date().addingTimeInterval(3600)),
            "gameName": "Game Name" // Add gameName as required by LiveActivityAttributes
        ].compactMapValues { $0 }
    }
    
    private func startActivity() {
        LiveActivityManager.shared.startActivity(json: buildJson())
    }
    
    private func updateActivity() {
        LiveActivityManager.shared.updateActivity(json: buildJson())
    }
    
    // Function to hide keyboard when tapping outside
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func showSystemToast(message: String) {
        let toast = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        toast.view.alpha = 0.8
        toast.view.layer.cornerRadius = 10
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(toast, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                toast.dismiss(animated: true)
            }
        }
    }
}

// Add preview to test the interface
@available(iOS 17.0, *)
#Preview {
    LiveActivityTestScene()
}
