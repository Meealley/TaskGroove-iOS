//
//  CreateTaskViewModel.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import SwiftUI

@MainActor
final class CreateTaskViewModel: ObservableObject {
    @Published var taskName = ""
    @Published var taskDescription = ""
    @Published var selectedPriority: TaskItem.Priority = .none
    @Published var dueDate: Date? = nil
    @Published var showDatePicker = false
    @Published var reminder: Date? = nil
    @Published var showReminderPicker = false
    @Published var showMoreOptions = false
    @Published var selectedLabels: Set<String> = []
    @Published var deadline = Date()
    @Published var location = ""
    @Published var defaultDate: Date? = nil
    
    let availableLabels = ["Work", "Personal", "Urgent", "Follow-up", "Ideas"]
    
    var isFormValid: Bool {
        !taskName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // Check if date was actually set
    var hasDateSet: Bool {
        dueDate != nil
    }
    
    // Set default date
    func setDefaultDate(_ date: Date?) {
        self.defaultDate = date
        self.dueDate = date
    }
    
    func createTask() -> TaskItem {
        TaskItem(
            name: taskName,
            description: taskDescription,
            priority: selectedPriority,
            isCompleted: false,
            dueDate: dueDate,
            reminder: reminder,
            labels: Array(selectedLabels),
            location: location.isEmpty ? nil : location
        )
    }
    
    func resetForm() {
        taskName = ""
        taskDescription = ""
        selectedPriority = .none
        dueDate = defaultDate // Had to reset to default date instead of nil
        showDatePicker = false
        reminder = nil
        showReminderPicker = false
        showMoreOptions = false
        selectedLabels = []
        deadline = Date()
        location = ""
    }
}
