//
//  HomeViewModel.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 21/10/2025.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    // Task Statistics
    @Published var activeTasks = 12
    @Published var completedToday = 5
    @Published var weeklyGoalProgress = 0.75
    @Published var projectsCount = 3
    @Published var goalsCount = 4
    @Published var focusHours = 3.5
    
    // Motivational Content
    @Published var dailyQuote = "The secret of getting ahead is getting started."
    @Published var quoteAuthor = "Mark Twain"
    
    // Focus Tasks
    @Published var focusTasks: [FocusTask] = [
        FocusTask(title: "Complete failover documentations", priority: .high, estimatedTime: "5h"),
        FocusTask(title: "Follow up on MSSQL RfQ", priority: .medium, estimatedTime: "2h"),
        FocusTask(title: "Prepare weekly report", priority: .medium, estimatedTime: "45m")
    ]
    
    
    // Recent Achievements
    @Published var achievements: [Achievement] = [
        Achievement(title: "Task Master", description: "Completed 45 tasks", icon: "star.fill", date: Date()),
        Achievement(title: "Streak Keeper", description: "7-day streak", icon: "flame.fill", date: Date().addingTimeInterval(-86400))
    ]
    
    // MARK: - Methods
    
    func loadDashboardData() {
        // Loads data from your data source
        // This would typically fetch data from CoreData, Firebase etc
    }
    
    func updateTaskCount() {
        // Update active task count
    }
    
    func fetchDailyQuote() {
        // Fetch a new motivational quote
    }
    
    func calculateWeeklyProgress() {
        // Calculate weekly goal progress
    }
}
