//
//  TaskDetailSheet.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 27/10/2025.
//

import SwiftUI

struct TaskDetailSheet: View {
    let task: TaskItem
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onToggleComplete: () -> Void
    let onReschedule: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Task Title and Completion
                    HStack(spacing: 15) {
                        Button(action: {
                            onToggleComplete()
                            dismiss()
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 28))
                                .foregroundColor(task.isCompleted ? .green : .gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Button(action: onEdit) {
                                HStack {
                                    Text(task.name)
                                        .font(.dmsans(size: 18))
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .buttonStyle(.plain)
                            
                            if !task.description.isEmpty {
                                Text(task.description)
                                    .font(.dmsans(size: 14))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 15)
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Project Section
                    TaskDetailRow(
                        icon: "tray.fill",
                        title: "Inbox",
                        iconColor: .blue
                    )
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Due Date Section
                    if let dueDate = task.dueDate {
                        Button(action: onReschedule) {
                            TaskDetailRow(
                                icon: "calendar",
                                title: formatDueDate(dueDate),
                                iconColor: dueDateColor(dueDate),
                                showChevron: true
                            )
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                            .padding(.horizontal, 20)
                    }
                    
                    // Priority Section
                    TaskDetailRow(
                        icon: "flag.fill",
                        title: task.priority.rawValue,
                        iconColor: task.priority.color
                    )
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Reminders Button
                    Button(action: {}) {
                        TaskDetailRow(
                            icon: "bell",
                            title: "Reminders",
                            iconColor: .purple,
                            showChevron: true
                        )
                    }
                    .buttonStyle(.plain)
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Sub-tasks Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Sub-tasks")
                                .font(.dmsansBold(size: 16))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        
                        Button(action: {}) {
                            HStack(spacing: 10) {
                                Image(systemName: "plus")
                                    .font(.system(size: 16))
                                    .foregroundColor(.blue)
                                
                                Text("Add Sub-task")
                                    .font(.dmsans(size: 15))
                                    .foregroundColor(.blue)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Comment Section
                    HStack(spacing: 12) {
                        Image(systemName: "paperclip")
                            .font(.system(size: 18))
                            .foregroundColor(.secondary)
                        
                        Text("Comment")
                            .font(.dmsans(size: 15))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    
                    Spacer()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: onEdit) {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: {
                            onDelete()
                            dismiss()
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 20))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    // MARK: - Date Formatting
    private func formatDueDate(_ date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        }
        
        if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        }
        
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    private func dueDateColor(_ date: Date) -> Color {
        let calendar = Calendar.current
        let now = Date()
        
        if date < now && !calendar.isDateInToday(date) {
            return .red
        }
        
        if calendar.isDateInToday(date) {
            return .green
        }
        
        return .purple
    }
}

// MARK: - Task Detail Row Component
struct TaskDetailRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    var showChevron: Bool = false
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            Text(title)
                .font(.dmsans(size: 15))
                .foregroundColor(.primary)
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color(.systemBackground))
    }
}

#Preview {
    TaskDetailSheet(
        task: TaskItem(
            name: "Design App UI",
            description: "Finish onboarding screens and create prototypes",
            priority: .high,
            isCompleted: false,
            dueDate: Date()
        ),
        onEdit: {},
        onDelete: {},
        onToggleComplete: {},
        onReschedule: {}
    )
}
