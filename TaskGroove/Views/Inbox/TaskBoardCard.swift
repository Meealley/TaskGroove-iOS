//
//  TaskBoardCard.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import SwiftUI

struct TaskBoardCard: View {
    let task: TaskItem
    let onToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Button(action: onToggle) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20))
                        .foregroundColor(task.isCompleted ? .green : .gray)
                }
                
                Spacer()
                
                Circle()
                    .fill(task.priority.color)
                    .frame(width: 8, height: 8)
            }
            
            Text(task.name)
                .font(.dmsansBold(size: 14))
                .lineLimit(2)
                .strikethrough(task.isCompleted)
            
            if !task.description.isEmpty {
                Text(task.description)
                    .font(.dmsans(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            if let dueDate = task.dueDate {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 10))
                    Text(dueDate.formatted(.dateTime.month().day()))
                        .font(.dmsans(size: 10))
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}
