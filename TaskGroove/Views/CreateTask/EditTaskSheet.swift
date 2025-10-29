//
//  EditTaskSheet.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 27/10/2025.
//

import SwiftUI

struct EditTaskSheet: View {
    let task: TaskItem
    let onSave: (TaskItem) -> Void
    @Environment(\.dismiss) var dismiss
    
    @State private var taskName: String
    @State private var taskDescription: String
    @State private var selectedPriority: TaskItem.Priority
    @State private var dueDate: Date
    @State private var hasDueDate: Bool
    @State private var reminderDate: Date
    @State private var hasReminder: Bool
    @State private var location: String
    @State private var labels: [String]
    @State private var newLabel: String = ""
    @State private var showDeleteAlert = false
    
    init(task: TaskItem, onSave: @escaping (TaskItem) -> Void) {
        self.task = task
        self.onSave = onSave
        
        // Initialize state from task
        _taskName = State(initialValue: task.name)
        _taskDescription = State(initialValue: task.description)
        _selectedPriority = State(initialValue: task.priority)
        _dueDate = State(initialValue: task.dueDate ?? Date())
        _hasDueDate = State(initialValue: task.dueDate != nil)
        _reminderDate = State(initialValue: task.reminder ?? Date())
        _hasReminder = State(initialValue: task.reminder != nil)
        _location = State(initialValue: task.location ?? "")
        _labels = State(initialValue: task.labels)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Task Name Section
                Section {
                    TextField("Task name", text: $taskName, axis: .vertical)
                        .font(.dmsans(size: 16))
                        .lineLimit(3...6)
                } header: {
                    Text("Task Name")
                        .font(.dmsans(size: 13))
                }
                
                // MARK: - Description Section
                Section {
                    TextField("Add description", text: $taskDescription, axis: .vertical)
                        .font(.dmsans(size: 15))
                        .foregroundColor(.primary)
                        .lineLimit(4...8)
                } header: {
                    Text("Description")
                        .font(.dmsans(size: 13))
                }
                
                // MARK: - Due Date Section
                Section {
                    Toggle(isOn: $hasDueDate) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.purple)
                            Text("Due Date")
                                .font(.dmsans(size: 15))
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    
                    if hasDueDate {
                        DatePicker(
                            "Select Date",
                            selection: $dueDate,
                            displayedComponents: [.date]
                        )
                        .font(.dmsans(size: 15))
                        .datePickerStyle(.graphical)
                    }
                } header: {
                    Text("Schedule")
                        .font(.dmsans(size: 13))
                }
                
                // MARK: - Reminder Section
                Section {
                    Toggle(isOn: $hasReminder) {
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.orange)
                            Text("Reminder")
                                .font(.dmsans(size: 15))
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                    
                    if hasReminder {
                        DatePicker(
                            "Remind me at",
                            selection: $reminderDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .font(.dmsans(size: 15))
                    }
                }
                
                // MARK: - Priority Section
                Section {
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(TaskItem.Priority.allCases, id: \.self) { priority in
                            HStack(spacing: 8) {
                                Image(systemName: "flag.fill")
                                    .foregroundColor(priority.color)
                                    .font(.system(size: 12))
                                Text(priority.rawValue)
                                    .font(.dmsans(size: 15))
                            }
                            .tag(priority)
                        }
                    }
                    .pickerStyle(.menu)
                    .font(.dmsans(size: 15))
                } header: {
                    Text("Priority")
                        .font(.dmsans(size: 13))
                }
                
                // MARK: - Location Section
                Section {
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.blue)
                        TextField("Add location", text: $location)
                            .font(.dmsans(size: 15))
                    }
                } header: {
                    Text("Location")
                        .font(.dmsans(size: 13))
                }
                
                // MARK: - Labels Section
                Section {
                    // Existing Labels
                    if !labels.isEmpty {
                        ForEach(labels, id: \.self) { label in
                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 12))
                                Text(label)
                                    .font(.dmsans(size: 15))
                                
                                Spacer()
                                
                                Button(action: {
                                    removeLabel(label)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    
                    // Add New Label
                    HStack {
                        Image(systemName: "tag")
                            .foregroundColor(.green)
                        TextField("Add label", text: $newLabel)
                            .font(.dmsans(size: 15))
                            .onSubmit {
                                addLabel()
                            }
                        
                        if !newLabel.isEmpty {
                            Button(action: addLabel) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                } header: {
                    Text("Labels")
                        .font(.dmsans(size: 13))
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.dmsans(size: 16))
                    .foregroundColor(.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .font(.dmsansBold(size: 16))
                    .foregroundColor(.blue)
                    .disabled(taskName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    // MARK: - Label Management
    private func addLabel() {
        let trimmedLabel = newLabel.trimmingCharacters(in: .whitespaces)
        guard !trimmedLabel.isEmpty, !labels.contains(trimmedLabel) else { return }
        
        withAnimation {
            labels.append(trimmedLabel)
            newLabel = ""
        }
    }
    
    private func removeLabel(_ label: String) {
        withAnimation {
            labels.removeAll { $0 == label }
        }
    }
    
    // MARK: - Save Task
    private func saveTask() {
        // Create updated task with all changes
        var updatedTask = task
        updatedTask.name = taskName.trimmingCharacters(in: .whitespaces)
        updatedTask.description = taskDescription.trimmingCharacters(in: .whitespaces)
        updatedTask.priority = selectedPriority
        updatedTask.dueDate = hasDueDate ? dueDate : nil
        updatedTask.reminder = hasReminder ? reminderDate : nil
        updatedTask.location = location.trimmingCharacters(in: .whitespaces).isEmpty ? nil : location.trimmingCharacters(in: .whitespaces)
        updatedTask.labels = labels
        
        // Call the save callback
        onSave(updatedTask)
        
        // Dismiss sheet
        dismiss()
    }
}

#Preview {
    EditTaskSheet(
        task: TaskItem(
            name: "Design App UI",
            description: "Finish onboarding screens and create prototypes",
            priority: .high,
            isCompleted: false,
            dueDate: Date(),
            reminder: Date(),
            labels: ["Work", "Design"],
            location: "Office"
        ),
        onSave: { _ in }
    )
}
