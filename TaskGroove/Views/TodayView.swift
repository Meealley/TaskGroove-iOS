//
//  TodayView.swift
//  GreetingsApp
//
//  Created by Oyewale Favour on 12/10/2025.
//

import SwiftUI

struct TodayView: View {
    @State private var tasks = [
        Tasks(title: "Review pull requests", isCompleted: false, priority: .high),
        Tasks(title: "Team standup meeting", isCompleted: true, priority: .medium),
        Tasks(title: "Update documentation", isCompleted: false, priority: .low),
        Tasks(title: "Code review for Sarah", isCompleted: false, priority: .high)
    ]
    
    private var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.05), .purple.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Progress Card
                        VStack(spacing: 15) {
                            HStack {
                                Text("Today's Progress")
                                    .font(.dmsansBold(size: 20))
                                Spacer()
                                Text("\(completedTasksCount)/\(tasks.count)")
                                    .font(.dmsans(size: 16))
                                    .foregroundColor(.secondary)
                            }
                            
                            ProgressView(value: Double(completedTasksCount), total: Double(tasks.count))
                                .tint(.blue)
                        }
                        .padding(20)
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.05), radius: 5)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Tasks List
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Tasks")
                                .font(.dmsansBold(size: 20))
                                .padding(.horizontal, 20)
                            
                            ForEach(tasks.indices, id: \.self) { index in
                                TaskRow(task: $tasks[index])
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Add new task
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                    }
                }
            }
        }
    }
}

struct Tasks: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var priority: Priority
    
    enum Priority {
        case high, medium, low
        
        var color: Color {
            switch self {
            case .high: return .red
            case .medium: return .orange
            case .low: return .green
            }
        }
    }
}

struct TaskRow: View {
    @Binding var task: Tasks
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                withAnimation {
                    task.isCompleted.toggle()
                }
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.dmsans(size: 16))
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(task.priority.color)
                        .frame(width: 8, height: 8)
                    
                    Text(task.priority == .high ? "High Priority" : task.priority == .medium ? "Medium" : "Low")
                        .font(.dmsans(size: 12))
                        .foregroundColor(.secondary)
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

#Preview {
    TodayView()
}
