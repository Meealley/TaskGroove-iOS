//
//  DailyFocusSection.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 21/10/2025.
//

import SwiftUI

struct DailyFocusSection: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12){
            SectionHeader(title: "Today's Focus", actionText: "View All",
            action: {
                // Navigate to full focus list
            }
            )
            
            VStack(spacing: 8) {
                ForEach(viewModel.focusTasks) {
                    task in
                    
                    FocusTaskRow(task: task)
                }
            }
        }
    }
}

struct FocusTaskRow: View {
    let task: FocusTask
    
    @State private var isCompleted: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            TaskCheckbox(isCompleted: $isCompleted, color: task.priority.color)
            
            TaskContent(task: task,
            isCompleted: isCompleted
            )
            
            Spacer()
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemBackground))
                
        )
    }
}


// MARK: - Task Checkbox
struct TaskCheckbox: View {
    @Binding var isCompleted: Bool
    let color: Color
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isCompleted.toggle()
            }
        }) {
            ZStack {
                Circle()
                    .stroke(color, lineWidth: 2)
                    .frame(width: 24, height: 24)
                
                Circle()
                    .fill(color)
                    .frame(width: 16, height: 16)
                    .scaleEffect(isCompleted ? 1 : 0.001)
                    .opacity(isCompleted ? 1 : 0)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Task Content
struct TaskContent: View {
    let task: FocusTask
    let isCompleted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.title)
                .font(.dmsans(size: 14))
                .foregroundColor(.primary)
                .strikethrough(isCompleted, color: .gray)
                .animation(.easeInOut(duration: 0.2), value: isCompleted)
            
            TaskMetadata(task: task)
        }
    }
}

// MARK: - Task Metadata
struct TaskMetadata: View {
    let task: FocusTask
    
    var body: some View {
        HStack(spacing: 8) {
            // Time estimate
            Label {
                Text(task.estimatedTime)
                    .font(.dmsans(size: 11))
            } icon: {
                Image(systemName: "clock")
                    .font(.system(size: 10))
            }
            .foregroundColor(.secondary)
            
            // Priority indicator
            HStack(spacing: 4) {
                Circle()
                    .fill(task.priority.color)
                    .frame(width: 6, height: 6)
                
                Text(task.priority.label)
                    .font(.dmsans(size: 11))
            }
            .foregroundColor(.secondary)
        }
    }
}

// MARK: - Empty Focus State
struct EmptyFocusState: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.green)
            
            Text("All caught up!")
                .font(.dmsans(weight: .medium, size: 16))
                .foregroundColor(.primary)
            
            Text("You've completed all your focus tasks for today")
                .font(.dmsans(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}


struct SectionHeader: View {
    let title: String
    var actionText: String? = nil
    var trailingIcon: String? = nil
    var iconColor: Color = .blue
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.dmsansBold(size: 20))
            
            Spacer()
            
            if let trailingIcon = trailingIcon {
                Button(action: { action?() }) {
                    Image(systemName: trailingIcon)
                        .foregroundColor(iconColor)
                }
            } else if let actionText = actionText {
                Button(action: { action?() }) {
                    Text(actionText)
                        .font(.dmsans(size: 14))
                        .foregroundColor(.blue)
                }
            }
        }
    }
}


#Preview {
    DailyFocusSection(
        viewModel: HomeViewModel()
    )
        .padding(.horizontal)
}
