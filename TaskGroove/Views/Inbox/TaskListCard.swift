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
//                        .frame(width: min(-offset, 100))
                        .frame(width: abs(offset)) // <- allow dynamic growth
                }
            }
            
            // Main Card Content
            cardContent
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            isSwiping = true
                            offset = gesture.translation.width
                        }
                        .onEnded { gesture in
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
    }
    
    // MARK: - Reschedule Action View (Swipe Left)
//    private var rescheduleActionView: some View {
//        Button(action: {
//            withAnimation(.spring(response: 0.3)) {
//                offset = 0
//            }
//            onReschedule()
//        }) {
//            VStack(spacing: 6) {
//                Image(systemName: "clock.arrow.circlepath")
//                    .font(.system(size: 20, weight: .medium))
//                Text("Reschedule")
//                    .font(.dmsans(size: 11))
//            }
//            .foregroundColor(.white)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.blue)
//            .cornerRadius(12)
//        }
//        .buttonStyle(.plain)
//    }
    
    private var rescheduleActionView: some View {
        GeometryReader { geometry in
            // We’ll use the parent width to calculate proportional width
            let dragWidth = min(-offset, geometry.size.width * 0.9) // Limit to 90% of card width

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
                            .scaleEffect(Double(min(-offset / 150, 1.2))) // Slight grow while dragging
                            .animation(.easeInOut(duration: 0.2), value: offset)
                        Text("Reschedule")
                            .font(.dmsans(size: 11))
                            .opacity(Double(min(-offset / 80, 1))) // Fade in smoothly
                    }
                    .foregroundColor(.white)
                    .frame(width: dragWidth)
                    .frame(maxHeight: .infinity)
                    .background(Color.blue)
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
                Text("Delete")
                    .font(.dmsans(size: 11))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    TaskListCard(
        task: TaskItem(
            name: "Design App UI",
            description: "Finish onboarding screens and update icons",
            priority: .high, isCompleted: false,
            dueDate: Date()
        ),
        onToggle: {},
        onReschedule: {},
        onDelete: {}
    )
    .padding()
    .previewLayout(.sizeThatFits)
    .background(Color(.systemGroupedBackground))
}
