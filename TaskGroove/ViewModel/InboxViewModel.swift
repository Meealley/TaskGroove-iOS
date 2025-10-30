//
//  InboxViewModel.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import SwiftUI

@MainActor
final class InboxViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    @Published var selectedViewStyle: ViewStyle = .list
    @Published var selectedFilter: FilterOptions = .all
    @Published var showViewSheet = false
    @Published var showTaskSheet = false
    @Published var isLoading = false
    @Published var showCompletedTasks: Bool = false
    @Published var completedTaskDisplayLimit: Int = 50
    @Published var isLoadingMoreCompleted = false
    
    private let tasksKey = "SavedTasks"
    
    init() {
        loadTasks()
    }
    
    
    // MARK: - Computed Properties
    var activeTasks: [ TaskItem] {
        tasks.filter { !$0.isCompleted }
    }
    
    var completedTasks: [TaskItem] {
        tasks.filter { $0.isCompleted }
            .sorted { ($0.dueDate ?? Date.distantPast) > ($1.dueDate ?? Date.distantPast)}
    }
    
    var visibleCompletedTasks: [TaskItem] {
        Array(completedTasks.prefix(completedTaskDisplayLimit))
    }
    
    var hasMoreCompletedTasks: Bool {
        completedTasks.count > completedTaskDisplayLimit
    }
    
    var remainingCompletedTasksCount: Int {
        max(0, completedTasks.count - completedTaskDisplayLimit)
    }
    
    // MARK: - Load Tasks
    /// Loads tasks from UserDefaults or generates sample data if none exist
    func loadTasks() {
        isLoading = true
        
        // Try to load from UserDefaults first
        if let savedTasks = loadTasksFromStorage() {
            self.tasks = savedTasks
            self.isLoading = false
        } else {
            // If no saved tasks, generate sample data
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.tasks = self?.generateSampleTasks() ?? []
                self?.saveTasks() // Save the sample data
                self?.isLoading = false
            }
        }
    }
    
    // MARK: - Persistence
    /// Save tasks to UserDefaults
    private func saveTasks() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(tasks)
            UserDefaults.standard.set(data, forKey: tasksKey)
        } catch {
            print("Error saving tasks: \(error.localizedDescription)")
        }
    }
    
    /// Load tasks from UserDefaults
    private func loadTasksFromStorage() -> [TaskItem]? {
        guard let data = UserDefaults.standard.data(forKey: tasksKey) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let tasks = try decoder.decode([TaskItem].self, from: data)
            return tasks
        } catch {
            print("Error loading tasks: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Clear all saved tasks (useful for testing)
    func clearAllTasks() {
        tasks = []
        UserDefaults.standard.removeObject(forKey: tasksKey)
    }
    
    // MARK: - Generate Sample Data
    private func generateSampleTasks() -> [TaskItem] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            // Today's tasks
            TaskItem(
                name: "Review meetings",
                description: "Check in with Oluwasegun",
                priority: .high,
                isCompleted: false,
                dueDate: today
            ),
            TaskItem(
                name: "Code review",
                description: "Review authentication module",
                priority: .high,
                isCompleted: false,
                dueDate: today
            ),
            TaskItem(
                name: "Team standup",
                description: "Daily sync at 10 AM",
                priority: .medium,
                isCompleted: true,
                dueDate: today
            ),
            TaskItem(
                name: "Update documentation",
                description: "Add API endpoints docs",
                priority: .low,
                isCompleted: false,
                dueDate: today
            ),
            
            // Tomorrow's tasks
            TaskItem(
                name: "Lunch",
                description: "Get food from Chowdeck",
                priority: .medium,
                isCompleted: false,
                dueDate: calendar.date(byAdding: .day, value: 1, to: today)
            ),
            TaskItem(
                name: "Client presentation",
                description: "Present Q4 roadmap",
                priority: .high,
                isCompleted: false,
                dueDate: calendar.date(byAdding: .day, value: 1, to: today)
            ),
            
            // This week
            TaskItem(
                name: "Design sprint review",
                description: "Review new app designs",
                priority: .medium,
                isCompleted: false,
                dueDate: calendar.date(byAdding: .day, value: 3, to: today)
            ),
            TaskItem(
                name: "Deploy to staging",
                description: "Test new features",
                priority: .high,
                isCompleted: false,
                dueDate: calendar.date(byAdding: .day, value: 4, to: today)
            ),
            TaskItem(
                name: "Team building event",
                description: "Friday social at 5 PM",
                priority: .low,
                isCompleted: false,
                dueDate: calendar.date(byAdding: .day, value: 5, to: today)
            ),
            
            // Next week
            TaskItem(
                name: "Sprint planning",
                description: "Plan next 2-week sprint",
                priority: .high,
                isCompleted: false,
                dueDate: calendar.date(byAdding: .day, value: 7, to: today)
            ),
            TaskItem(
                name: "Performance reviews",
                description: "Submit team evaluations",
                priority: .medium,
                isCompleted: false,
                dueDate: calendar.date(byAdding: .day, value: 10, to: today)
            ),
            
            // Further out
            TaskItem(
                name: "Annual company retreat",
                description: "Book travel and accommodation",
                priority: .medium,
                isCompleted: false,
                dueDate: calendar.date(byAdding: .day, value: 30, to: today)
            ),
            TaskItem(
                name: "Q1 Budget planning",
                description: "Prepare department budget",
                priority: .high,
                isCompleted: false,
                dueDate: calendar.date(byAdding: .day, value: 45, to: today)
            ),
            
            // Overdue tasks
            TaskItem(
                name: "File expense reports",
                description: "Submit September expenses",
                priority: .high,
                isCompleted: false,
                dueDate: calendar.date(byAdding: .day, value: -2, to: today)
            ),
            TaskItem(
                name: "Complete training module",
                description: "Security awareness training",
                priority: .medium,
                isCompleted: false,
                dueDate: calendar.date(byAdding: .day, value: -5, to: today)
            ),
            
            // No due date
            TaskItem(
                name: "Research new frameworks",
                description: "Evaluate SwiftUI alternatives",
                priority: .low,
                isCompleted: false,
                dueDate: nil
            ),
            TaskItem(
                name: "Organize bookmarks",
                description: "Clean up saved articles",
                priority: .low,
                isCompleted: false,
                dueDate: nil
            )
        ]
    }
    
    // MARK: - Computed Property for Filtered Tasks
    // MARK: - Computed Property for Filtered Tasks
    var filteredTasks: [TaskItem] {
        let today = Date()
        let calendar = Calendar.current
        
        // Get only active (non-completed) tasks
        let activeTasksList = tasks.filter { !$0.isCompleted }
        
        var filtered: [TaskItem]
        
        switch selectedFilter {
        case .all:
            filtered = activeTasksList
        case .today:
            filtered = activeTasksList.filter {
                guard let dueDate = $0.dueDate else { return false }
                return calendar.isDate(dueDate, inSameDayAs: today)
            }
        case .tomorrow:
            filtered = activeTasksList.filter {
                guard let dueDate = $0.dueDate else { return false }
                guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else { return false }
                return calendar.isDate(dueDate, inSameDayAs: tomorrow)
            }
        case .thisWeek:
            filtered = activeTasksList.filter {
                guard let dueDate = $0.dueDate else { return false }
                return calendar.isDate(dueDate, equalTo: today, toGranularity: .weekOfYear)
            }
        case .nextWeek:
            filtered = activeTasksList.filter {
                guard let dueDate = $0.dueDate else { return false }
                guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: today) else { return false }
                return calendar.isDate(dueDate, equalTo: nextWeek, toGranularity: .weekOfYear)
            }
        case .thisMonth:
            filtered = activeTasksList.filter {
                guard let dueDate = $0.dueDate else { return false }
                return calendar.isDate(dueDate, equalTo: today, toGranularity: .month)
            }
        case .nextMonth:
            filtered = activeTasksList.filter {
                guard let dueDate = $0.dueDate else { return false }
                guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: today) else { return false }
                return calendar.isDate(dueDate, equalTo: nextMonth, toGranularity: .month)
            }
        case .noDate:
            filtered = activeTasksList.filter { $0.dueDate == nil }
        }
        
        return filtered
    }
    
//    var filteredTasks: [TaskItem] {
//        let today = Date()
//        let calendar = Calendar.current
//        
//        switch selectedFilter {
//        case .all:
//            return tasks
//        case .today:
//            return tasks.filter {
//                guard let dueDate = $0.dueDate else { return false }
//                return calendar.isDate(dueDate, inSameDayAs: today)
//            }
//        case .tomorrow:
//            return tasks.filter {
//                guard let dueDate = $0.dueDate else { return false }
//                guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else { return false }
//                return calendar.isDate(dueDate, inSameDayAs: tomorrow)
//            }
//        case .thisWeek:
//            return tasks.filter {
//                guard let dueDate = $0.dueDate else { return false }
//                return calendar.isDate(dueDate, equalTo: today, toGranularity: .weekOfYear)
//            }
//        case .nextWeek:
//            return tasks.filter {
//                guard let dueDate = $0.dueDate else { return false }
//                guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: today) else { return false }
//                return calendar.isDate(dueDate, equalTo: nextWeek, toGranularity: .weekOfYear)
//            }
//        case .thisMonth:
//            return tasks.filter {
//                guard let dueDate = $0.dueDate else { return false }
//                return calendar.isDate(dueDate, equalTo: today, toGranularity: .month)
//            }
//        case .nextMonth:
//            return tasks.filter {
//                guard let dueDate = $0.dueDate else { return false }
//                guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: today) else { return false }
//                return calendar.isDate(dueDate, equalTo: nextMonth, toGranularity: .month)
//            }
//        case .noDate:
//            return tasks.filter { $0.dueDate == nil }
//        }
//    }
    
    // MARK: - Task Operations
    func addTask(_ task: TaskItem) {
        tasks.insert(task, at: 0)
        saveTasks()
    }
    
    func toggleCompletion(for task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
            
            // Play sound based on action
                   if tasks[index].isCompleted {
                       // Task was just completed - play completion sound
                       SoundManager.shared.playCompletionSound()
                   } else {
                       // Task was uncompleted - play uncomplete sound
                       SoundManager.shared.playUncompleteSound()
                   }
            
            objectWillChange.send()
        }
    }
    
    func rescheduleTask(_ task: TaskItem, to newDate: Date?) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            var updatedTask = tasks[index]
            updatedTask.dueDate = newDate
            tasks[index] = updatedTask
            saveTasks()
        }
    }
    
    func deleteTask(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func updateTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }
    
    // MARK: - Load more Completed Tasks
    func loadMoreCompletedTasks()  {
        isLoadingMoreCompleted = true
        
        // Simulate loading delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.completedTaskDisplayLimit += 50
            self?.isLoadingMoreCompleted = false
        }
    }
    
    // MARK: - Refresh
    /// Call this from pull-to-refresh
    func refreshTasks() async {
        isLoading = true
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Reload tasks (in production, this would fetch from server)
        tasks = loadTasksFromStorage() ?? []
        
        isLoading = false
    }
}
