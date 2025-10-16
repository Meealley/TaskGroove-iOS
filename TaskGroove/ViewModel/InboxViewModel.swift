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
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        // Sample Tasks
        tasks = [
            TaskItem(
                name: "Review meetings",
                description: "Check in with Oluwasegun",
                priority: .high,
                isCompleted: false,
                dueDate: Date()
            ),
            TaskItem(
                name: "Lunch",
                description: "Get food from Chowdeck",
                priority: .medium,
                isCompleted: false,
                dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())
            ),
            TaskItem(
                name: "Code review",
                description: "Review authentication module",
                priority: .high,
                isCompleted: false,
                dueDate: Date()
            ),
            TaskItem(
                name: "Team standup",
                description: "Daily sync at 10 AM",
                priority: .medium,
                isCompleted: true,
                dueDate: Date()
            )
        ]
    }
    
    // MARK: - Computed Property for Filtered Tasks
    var filteredTasks: [TaskItem] {
        let today = Date()
        let calendar = Calendar.current
        
        switch selectedFilter {
        case .all:
            return tasks
        case .today:
            return tasks.filter {
                guard let dueDate = $0.dueDate else { return false }
                return calendar.isDate(dueDate, inSameDayAs: today)
            }
        case .tomorrow:
            return tasks.filter {
                guard let dueDate = $0.dueDate else { return false }
                guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else { return false }
                return calendar.isDate(dueDate, inSameDayAs: tomorrow)
            }
        case .thisWeek:
            return tasks.filter {
                guard let dueDate = $0.dueDate else { return false }
                return calendar.isDate(dueDate, equalTo: today, toGranularity: .weekOfYear)
            }
        case .nextWeek:
            return tasks.filter {
                guard let dueDate = $0.dueDate else { return false }
                guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: today) else { return false }
                return calendar.isDate(dueDate, equalTo: nextWeek, toGranularity: .weekOfYear)
            }
        case .thisMonth:
            return tasks.filter {
                guard let dueDate = $0.dueDate else { return false }
                return calendar.isDate(dueDate, equalTo: today, toGranularity: .month)
            }
        case .nextMonth:
            return tasks.filter {
                guard let dueDate = $0.dueDate else { return false }
                guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: today) else { return false }
                return calendar.isDate(dueDate, equalTo: nextMonth, toGranularity: .month)
            }
        case .noDate:
            return tasks.filter { $0.dueDate == nil }
        }
    }
    
    // MARK: - Task Operations
    func addTask(_ task: TaskItem) {
        tasks.insert(task, at: 0)
    }
    
    func toggleCompletion(for task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func deleteTask(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }
}
