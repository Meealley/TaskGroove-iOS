//
//  TaskRowView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

import SwiftUI

struct TaskRowView: View {
    
    let task: DayTask
    @State private var isCompleted = false
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCompleted.toggle()
                }
            }) {
                Circle()
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .fill(task.categoryColor)
                            .frame(width: 16, height: 16)
                            .opacity(isCompleted ? 1 : 0)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.dmsans(size: 16))
                    .foregroundStyle(.primary)
                    .strikethrough(isCompleted, color: .gray)
                
                HStack(spacing: 5) {
                    Text(task.description)
                        .font(.dmsans(size: 14))
                        .foregroundStyle(.gray)
                    
                    if task.subtasks > 0 {
                        HStack(spacing: 3) {
                            Image(systemName: "text.badge.checkmark")
                                .font(.dmsans(size: 12))
                            Text("\(task.subtasks)")
                                 .font(.dmsans(size: 14))
                        }
                        .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Text("Inbox / \(task.category)")
                         .font(.dmsans(size: 12))
                         .foregroundStyle(.gray.opacity(0.6))
                }
            }
        }
        .padding(.leading, 5)
    }
}

#Preview {
    // Mock data for preview
    let sampleTask = DayTask(
        date: Date(), title: "Finish SwiftUI Layout",
        description: "Adjust the calendar animation and fix alignment",
        category: "Work",
        categoryColor: .blue,
        subtasks: 3,
        isCompleted: false
    )
    
    TaskRowView(task: sampleTask)
        .padding()
        .previewLayout(.sizeThatFits)
}
