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
    @Published var dueDate = Date()
    @Published var showDatePicker = false
    @Published var reminder = Date()
    @Published var showReminderPicker = false
    @Published var showMoreOptions = false
    @Published var selectedLabels: Set<String> = []
    @Published var deadline = Date()
    @Published var location = ""
    
    let availableLabels = ["Work", "Personal", "Urgent", "Follow-up", "Ideas"]
    
    var isFormValid: Bool {
        !taskName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func createTask() -> TaskItem {
        TaskItem(
            name: taskName,
            description: taskDescription,
            priority: selectedPriority,
            isCompleted: false,
            dueDate: showDatePicker ? dueDate : nil,
            reminder: showReminderPicker ? reminder : nil,
            labels: Array(selectedLabels),
            location: location.isEmpty ? nil : location
        )
    }
    
    func resetForm() {
        taskName = ""
        taskDescription = ""
        selectedPriority = .none
        dueDate = Date()
        showDatePicker = false
        reminder = Date()
        showReminderPicker = false
        showMoreOptions = false
        selectedLabels = []
        deadline = Date()
        location = ""
    }
}
