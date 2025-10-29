//
//  TaskListCard.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import SwiftUI

struct TaskListCard: View {
    let task: TaskItem
    let onToggle: () -> Void
    let onReschedule: () -> Void
    let onDelete: () -> Void
    let onTap: () -> Void // Add tap handler
    var isOverdue: Bool = false
    
    @State private var offset: CGFloat = 0
    @State private var isSwiping = false
    
    private let maxSwipeWidth: CGFloat = 100
    private let rescheduleThreshold: CGFloat = -100
    private let deleteThreshold: CGFloat = 100
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background Actions
            HStack(spacing: 0) {
                // Delete action (swipe right)
                if offset > 0 {
                    deleteActionView
                        .frame(width: min(offset, 100))
                }
                
                Spacer()
                
                // Reschedule action (swipe left)
                if offset < 0 {
                    rescheduleActionView
                        .frame(width: abs(offset)) // Allow dynamic growth
                }
            }
            
            // Main Card Content
            cardContent
                .offset(x: offset)
                .contentShape(Rectangle()) // Make entire card tappable
                .onTapGesture {
                    // Only trigger tap if not swiped
                    if offset == 0 {
                        onTap()
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { gesture in
                            let horizontalAmount = gesture.translation.width
                            let verticalAmount = gesture.translation.height
                            
                            // If swipe is more vertical, ignore it!
                            if abs(verticalAmount) > abs(horizontalAmount) {
                                return  // Let ScrollView handle vertical swipes
                            }
                            
                            // Only process horizontal swipes
                            isSwiping = true
                            offset = horizontalAmount
                        }
                        .onEnded { gesture in
                            let horizontalAmount = gesture.translation.width
                            let verticalAmount = gesture.translation.height
                            
                            // Only handle if it was a horizontal swipe
                            if abs(verticalAmount) > abs(horizontalAmount) {
                                isSwiping = false
                                return
                            }
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                // Check if threshold reached
                                if offset < rescheduleThreshold {
                                    // Trigger reschedule
                                    onReschedule()
                                    offset = 0
                                } else if offset > deleteThreshold {
                                    // Trigger delete
                                    onDelete()
                                    offset = 0
                                } else {
                                    // Reset
                                    offset = 0
                                }
                            }
                            isSwiping = false
                        }
                )
        }
    }
    
    // MARK: - Card Content
    private var cardContent: some View {
        HStack(spacing: 15) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain) // Prevent button from consuming tap gesture
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .font(.dmsans(size: 16))
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.dmsans(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(task.priority.color)
                        .frame(width: 8, height: 8)
                    
                    Text(task.priority.rawValue)
                        .font(.dmsans(size: 12))
                        .foregroundColor(.secondary)
                    
                    if let dueDate = task.dueDate {
                        Text("•")
                            .foregroundColor(.secondary)
                        HStack(spacing: 3) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                                .foregroundColor(dueDateColor(dueDate))
                            
                            Text(formatDueDate(dueDate))
                                .font(.dmsans(size: 12))
                                .foregroundColor(dueDateColor(dueDate))
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(.top, 6)
        .padding(.bottom, 3)
        .padding(.horizontal, 16)
        .background(
            ZStack {
                Color(.systemBackground)
                
                // Add subtle red tint for overdue tasks
                if isOverdue && !task.isCompleted {
                    Color.red.opacity(0.03)
                }
            }
        )
        .overlay(alignment: .topTrailing) {
            // Overdue badge
            if isOverdue && !task.isCompleted {
                Text("OVERDUE")
                    .font(.dmsans(weight: .bold, size: 9))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.red)
                    .cornerRadius(4)
                    .padding(8)
            }
        }
        .overlay(
            // Add red left border for overdue tasks
            isOverdue && !task.isCompleted ?
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.3), lineWidth: 2)
            : nil
        )
        .cornerRadius(12)
    }
    
    // MARK: - Reschedule Action View (Swipe Left)
    private var rescheduleActionView: some View {
        GeometryReader { geometry in
            // Limit to 90% of card width
            let dragWidth = min(-offset, geometry.size.width * 0.9)

            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    offset = 0
                }
                onReschedule()
            }) {
                HStack {
                    Spacer()
                    
                    VStack(spacing: 6) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(width: dragWidth)
                    .frame(maxWidth: .infinity, maxHeight: 77)
                    .background(isOverdue ? Color.orange : Color.blue)
                    .cornerRadius(12)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Delete Action View (Swipe Right)
    private var deleteActionView: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                offset = 0
            }
            onDelete()
        }) {
            VStack(spacing: 6) {
                Image(systemName: "trash.fill")
                    .font(.system(size: 20, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: 77)
            .background(Color.red)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Date Formatting
    
    /// Smart date formatting: Shows weekday for next 7 days, otherwise shows "MMM d"
    private func formatDueDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        // Check if it's today
        if calendar.isDateInToday(date) {
            return "Today"
        }
        
        // Check if it's tomorrow
        if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        }
        
        // Check if it's yesterday
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }
        
        // Check if it's within the next 7 days
        if let nextWeek = calendar.date(byAdding: .day, value: 7, to: now),
           date >= now && date < nextWeek {
            // Show weekday name (e.g., "Monday", "Tuesday")
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // Full weekday name
            return formatter.string(from: date)
        }
        
        // Check if it's within the past 7 days
        if let lastWeek = calendar.date(byAdding: .day, value: -7, to: now),
           date >= lastWeek && date < now {
            // Show "Last Monday", "Last Tuesday", etc.
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return "Last \(formatter.string(from: date))"
        }
        
        // For dates beyond 7 days, show "MMM d" (e.g., "Oct 25")
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    /// Color coding for due dates
    private func dueDateColor(_ date: Date) -> Color {
        let calendar = Calendar.current
        let now = Date()
        
        // Overdue - red
        if date < now && !calendar.isDateInToday(date) {
            return .red
        }
        
        // Today - green
        if calendar.isDateInToday(date) {
            return .green
        }
        
        // Tomorrow - yellow
        if calendar.isDateInTomorrow(date) {
            return .yellow
        }
        
        // Future - gray (default)
        return .secondary
    }
}

#Preview {
    VStack(spacing: 20) {
        // Overdue Task
        TaskListCard(
            task: TaskItem(
                name: "Overdue Project",
                description: "This should have been done yesterday",
                priority: .high,
                isCompleted: false,
                dueDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())
            ),
            onToggle: {},
            onReschedule: {},
            onDelete: {},
            onTap: {},
            isOverdue: true
        )
        
        // Today
        TaskListCard(
            task: TaskItem(
                name: "Design App UI",
                description: "Finish onboarding screens",
                priority: .high,
                isCompleted: false,
                dueDate: Date()
            ),
            onToggle: {},
            onReschedule: {},
            onDelete: {},
            onTap: {}
        )
        
        // Tomorrow
        TaskListCard(
            task: TaskItem(
                name: "Team Meeting",
                description: "Quarterly review",
                priority: .medium,
                isCompleted: false,
                dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())
            ),
            onToggle: {},
            onReschedule: {},
            onDelete: {},
            onTap: {}
        )
        
        // Next Week
        TaskListCard(
            task: TaskItem(
                name: "Submit Report",
                description: "Q4 analytics",
                priority: .low,
                isCompleted: false,
                dueDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())
            ),
            onToggle: {},
            onReschedule: {},
            onDelete: {},
            onTap: {}
        )
        
        // Far Future
        TaskListCard(
            task: TaskItem(
                name: "Annual Review",
                description: "Prepare presentation",
                priority: .medium,
                isCompleted: false,
                dueDate: Calendar.current.date(byAdding: .day, value: 30, to: Date())
            ),
            onToggle: {},
            onReschedule: {},
            onDelete: {},
            onTap: {}
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
