//
//  TaskCalendarCard.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import SwiftUI

struct TaskCalendarCard: View {
    let task: TaskItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            VStack {
                Text(task.dueDate?.formatted(.dateTime.day()) ?? "—")
                    .font(.dmsansBold(size: 20))
                Text(task.dueDate?.formatted(.dateTime.month(.abbreviated)) ?? "No Date")
                    .font(.dmsans(size: 12))
                    .foregroundColor(.secondary)
            }
            .frame(width: 60, height: 60)
            .background(task.priority.color.opacity(0.2))
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .font(.dmsans(size: 16))
                    .strikethrough(task.isCompleted)
                
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.dmsans(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}
