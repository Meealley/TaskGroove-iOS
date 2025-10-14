//
//  OnboardingPage.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 14/10/2025.
//

import Foundation
import SwiftUI


struct OnboardingPage {
    let imageName: String
    let title: String
    let description: String
    let color: Color
    
    static let pages: [OnboardingPage] = [
        OnboardingPage(imageName: "welcome", title: "Welcome to TaskGroove", description: "Plan, Track and manage all your daily tasks in one place", color: .blue),
        OnboardingPage(imageName: "add-task", title: "Prioritize What Matters", description: "Focus on your most important goals with smart reminders and priority", color: .green),
        OnboardingPage(imageName: "", title: "Track your progress", description: "Visualize your achievements and stay motivated as you move closer to your goals", color: .purple)
        
        ]
}

