//
//  CreateTaskSheet.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import SwiftUI

struct CreateTaskSheet: View {
    @ObservedObject var viewModel: InboxViewModel
    @StateObject private var createViewModel = CreateTaskViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Task Name
                    taskNameField
                    
                    // Description
                    descriptionField
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Quick Actions
                    VStack(spacing: 12) {
                        dateSection
                        prioritySection
                        reminderSection
                        moreOptionsButton
                        
                        if createViewModel.showMoreOptions {
                            moreOptionsContent
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 30)
                }
                .padding(.top, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.dmsans())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .font(.dmsansBold())
                    .disabled(!createViewModel.isFormValid)
                }
            }
        }
    }
    
    // MARK: - Task Name Field
    private var taskNameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Task Name")
                .font(.dmsans(size: 14))
                .foregroundColor(.secondary)
            
            TextField("Enter task name", text: $createViewModel.taskName)
                .font(.dmsans(size: 16))
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Description Field
    private var descriptionField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.dmsans(size: 14))
                .foregroundColor(.secondary)
            
            TextField("Add description", text: $createViewModel.taskDescription, axis: .vertical)
                .font(.dmsans(size: 16))
                .lineLimit(3...6)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Date Section
    private var dateSection: some View {
        VStack(spacing: 0) {
            Button {
                createViewModel.showDatePicker.toggle()
            } label: {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                        .frame(width: 30)
                    
                    Text("Date")
                        .font(.dmsans(size: 16))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if createViewModel.showDatePicker {
                        Text(createViewModel.dueDate.formatted(.dateTime.month().day()))
                            .font(.dmsans(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
            }
            
            if createViewModel.showDatePicker {
                DatePicker("", selection: $createViewModel.dueDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Priority Section
    private var prioritySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "flag.fill")
                    .foregroundColor(.orange)
                    .frame(width: 30)
                
                Text("Priority")
                    .font(.dmsans(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            
            HStack(spacing: 10) {
                ForEach(TaskItem.Priority.allCases, id: \.self) { priority in
                    Button {
                        createViewModel.selectedPriority = priority
                    } label: {
                        Text(priority.rawValue)
                            .font(.dmsans(size: 14))
                            .foregroundColor(createViewModel.selectedPriority == priority ? .white : priority.color)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(createViewModel.selectedPriority == priority ? priority.color : priority.color.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
    
    // MARK: - Reminder Section
    private var reminderSection: some View {
        VStack(spacing: 0) {
            Button {
                createViewModel.showReminderPicker.toggle()
            } label: {
                HStack {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.purple)
                        .frame(width: 30)
                    
                    Text("Reminder")
                        .font(.dmsans(size: 16))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if createViewModel.showReminderPicker {
                        Text(createViewModel.reminder.formatted(.dateTime.hour().minute()))
                            .font(.dmsans(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
            }
            
            if createViewModel.showReminderPicker {
                DatePicker("", selection: $createViewModel.reminder, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
            }
        }
    }
    
    // MARK: - More Options Button
    private var moreOptionsButton: some View {
        Button {
            withAnimation {
                createViewModel.showMoreOptions.toggle()
            }
        } label: {
            HStack {
                Image(systemName: "ellipsis.circle.fill")
                    .foregroundColor(.gray)
                    .frame(width: 30)
                
                Text("More Options")
                    .font(.dmsans(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: createViewModel.showMoreOptions ? "chevron.up" : "chevron.down")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
        }
    }
    
    // MARK: - More Options Content
    private var moreOptionsContent: some View {
        VStack(spacing: 12) {
            // Labels
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundColor(.green)
                        .frame(width: 30)
                    
                    Text("Labels")
                        .font(.dmsans(size: 16))
                        .foregroundColor(.primary)
                }
                
                FlowLayout(spacing: 8) {
                    ForEach(createViewModel.availableLabels, id: \.self) { label in
                        Button {
                            if createViewModel.selectedLabels.contains(label) {
                                createViewModel.selectedLabels.remove(label)
                            } else {
                                createViewModel.selectedLabels.insert(label)
                            }
                        } label: {
                            Text(label)
                                .font(.dmsans(size: 13))
                                .foregroundColor(createViewModel.selectedLabels.contains(label) ? .white : .primary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(createViewModel.selectedLabels.contains(label) ? Color.blue : Color.blue.opacity(0.2))
                                .cornerRadius(15)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            
            // Deadline
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.red)
                        .frame(width: 30)
                    
                    Text("Deadline")
                        .font(.dmsans(size: 16))
                        .foregroundColor(.primary)
                }
                
                DatePicker("", selection: $createViewModel.deadline, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            
            // Location
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.pink)
                        .frame(width: 30)
                    
                    Text("Location")
                        .font(.dmsans(size: 16))
                        .foregroundColor(.primary)
                }
                
                TextField("Add location", text: $createViewModel.location)
                    .font(.dmsans(size: 14))
                    .padding(.vertical, 8)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
        }
    }
    
    // MARK: - Save Task
    private func saveTask() {
        let newTask = createViewModel.createTask()
        viewModel.addTask(newTask)
        createViewModel.resetForm()
        dismiss()
    }
}
