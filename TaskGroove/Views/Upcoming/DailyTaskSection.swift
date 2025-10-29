//
//  DailyTaskSection.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 28/10/2025.
//

import SwiftUI

struct DailyTaskSection: View {
    let date: Date
    let tasks: [TaskItem]
    let onToggle: (TaskItem) -> Void
    let onReschedule: (TaskItem) -> Void
    let onDelete: (TaskItem) -> Void
    let onTap: (TaskItem) -> Void
    
    private var dateString: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today • \(formatter.string(from: date))"
        } else if calendar.isDateInTomorrow(date) {
            formatter.dateFormat = "EEEE, MMM d"
            return "Tomorrow • \(formatter.string(from: date))"
        } else {
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: date)
        }
    }
    
    private var taskCountString: String {
        let count = tasks.count
        return count == 1 ? "1 task" : "\(count) tasks"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            // Date Header
            HStack {
                Text(dateString)
                    .font(.dmsansBold(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !tasks.isEmpty {
                    Text(taskCountString)
                        .font(.dmsans(size: 13))
                        .foregroundColor(.secondary)
                }
            }
            
            // Tasks List
            if tasks.isEmpty {
//                Text("No tasks scheduled")
//                    .font(.dmsans(size: 14))
//                    .foregroundColor(.secondary)
//                    .padding(.vertical, 20)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                Text("")
            } else {
                VStack(spacing: 0) {
                    ForEach(tasks) { task in
                        TaskListCard(
                            task: task,
                            onToggle: { onToggle(task) },
                            onReschedule: { onReschedule(task) },
                            onDelete: { onDelete(task) },
                            onTap: { onTap(task) }
                        )
                        .padding(.vertical, 1)
                        
                        if task.id != tasks.last?.id {
                            MenuDivider()
                        }
                    }
                }
            }
            
            // Bottom Divider
            Divider()
                .padding(.top, 12)
        }
    }
}

#Preview {
    DailyTaskSection(
        date: Date(),
        tasks: [
            TaskItem(
                name: "Design App UI",
                description: "Finish onboarding screens",
                priority: .high,
                isCompleted: false,
                dueDate: Date()
            ),
            TaskItem(
                name: "Team Meeting",
                description: "Quarterly review",
                priority: .medium,
                isCompleted: false,
                dueDate: Date()
            )
        ],
        onToggle: { _ in },
        onReschedule: { _ in },
        onDelete: { _ in },
        onTap: { _ in }
    )
    .padding()
}
