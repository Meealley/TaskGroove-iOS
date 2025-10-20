//
//  TaskListCard.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

//import SwiftUI
//
//struct TaskListCard: View {
//    let task: TaskItem
//    let onToggle: () -> Void
//    
//    var body: some View {
//        HStack(spacing: 15) {
//            Button(action: onToggle) {
//                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
//                    .font(.system(size: 24))
//                    .foregroundColor(task.isCompleted ? .green : .gray)
//            }
//            
//            VStack(alignment: .leading, spacing: 4) {
//                Text(task.name)
//                    .font(.dmsans(size: 16))
//                    .strikethrough(task.isCompleted)
//                    .foregroundColor(task.isCompleted ? .secondary : .primary)
//                
//                if !task.description.isEmpty {
//                    Text(task.description)
//                        .font(.dmsans(size: 14))
//                        .foregroundColor(.secondary)
//                        .lineLimit(2)
//                }
//                
//                HStack(spacing: 8) {
//                    Circle()
//                        .fill(task.priority.color)
//                        .frame(width: 8, height: 8)
//                    
//                    Text(task.priority.rawValue)
//                        .font(.dmsans(size: 12))
//                        .foregroundColor(.secondary)
//                    
//                    if let dueDate = task.dueDate {
//                        Text("•")
//                            .foregroundColor(.secondary)
//                        Text(dueDate.formatted(.dateTime.month().day()))
//                            .font(.dmsans(size: 12))
//                            .foregroundColor(.secondary)
//                    }
//                }
//            }
//            
//            Spacer()
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.05), radius: 5)
//    }
//}


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
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
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
                        Text(dueDate.formatted(.dateTime.month().day()))
                            .font(.dmsans(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            VStack(spacing: 0) {
                Divider()
                    .opacity(0)
                Spacer()
                Divider()
                    .padding(.leading, 56)
            }
        )
    }
}
