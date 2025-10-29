//
//  TodayView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 12/10/2025.
//

import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel = InboxViewModel()
    @State private var taskToReschedule: TaskItem?
    @State private var showUndoToast = false
    @State private var undoMessage = ""
    @State private var lastRescheduledTask: (task: TaskItem, oldDate: Date?)?
    @State private var triggerDismiss = false
    @State private var showOverdueTasks = true
    @State private var selectedTask: TaskItem? // For detail sheet
    @State private var taskToEdit: TaskItem? // For edit sheet
    
    private var overdueTasks: [TaskItem] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return viewModel.tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            let taskDate = calendar.startOfDay(for: dueDate)
            return taskDate < today && !task.isCompleted
        }
        .sorted { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) }
    }
    
    private var todayTasks: [TaskItem] {
        let calendar = Calendar.current
        
        return viewModel.tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return calendar.isDateInToday(dueDate)
        }
        .sorted { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) }
    }
    
    private var completedTasksCount: Int {
        todayTasks.filter { $0.isCompleted }.count
    }
    
    private var todayDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM • EEEE"
        return formatter.string(from: Date())
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
                        // Progress Card (only for today's tasks)
                        if !todayTasks.isEmpty {
                            progressCard
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                        }
                        
                        // Overdue Section
                        if !overdueTasks.isEmpty {
                            overdueSection
                                .padding(.horizontal, 20)
                        }
                        
                        // Today Section
                        todaySection
                            .padding(.horizontal, 20)
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.bottom, 100)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                // Floating Action Button
                Button {
                    viewModel.showTaskSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                        .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .overlay(alignment: .bottom) {
                // Undo Toast
                if showUndoToast {
                    UndoToastView(
                        message: undoMessage,
                        triggerDismiss: $triggerDismiss,
                        onUndo: undoReschedule,
                        onDismiss: {
                            showUndoToast = false
                            triggerDismiss = false
                        }
                    )
                    .padding(.bottom, 100)
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await refreshTasks()
            }
            .sheet(isPresented: $viewModel.showTaskSheet) {
                CreateTaskSheet(viewModel: viewModel)
                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.3)])
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.disabled)
                    .interactiveDismissDisabled(false)
            }
            .sheet(item: $taskToReschedule) { task in
                RescheduleDateSheet(
                    task: task,
                    onReschedule: { newDate in
                        rescheduleTask(task, to: newDate)
                    }
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
            // Task Detail Sheet
            .sheet(item: $selectedTask) { task in
                TaskDetailSheet(
                    task: task,
                    onEdit: {
                        selectedTask = nil
                        // Small delay to allow first sheet to dismiss
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            taskToEdit = task
                        }
                    },
                    onDelete: {
                        viewModel.deleteTask(task)
                    },
                    onToggleComplete: {
                        viewModel.toggleCompletion(for: task)
                    },
                    onReschedule: {
                        selectedTask = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            taskToReschedule = task
                        }
                    }
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
            // Edit Task Sheet
            .sheet(item: $taskToEdit) { task in
                EditTaskSheet(task: task) { updatedTask in
                    viewModel.updateTask(updatedTask)
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    // MARK: - Progress Card
    private var progressCard: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Today's Progress")
                    .font(.dmsansBold(size: 20))
                Spacer()
                Text("\(completedTasksCount)/\(todayTasks.count)")
                    .font(.dmsans(size: 16))
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: Double(completedTasksCount), total: Double(todayTasks.count))
                .tint(.blue)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    // MARK: - Overdue Section
    private var overdueSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 12) {
                Text("Overdue")
                    .font(.dmsansBold(size: 18))
                    .foregroundColor(.red)
                
                Text("\(overdueTasks.count)")
                    .font(.dmsans(size: 14))
                    .foregroundColor(.red.opacity(0.7))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                
                Spacer()
                
                // Reschedule All Button
                Button {
                    // Show reschedule sheet for first overdue task
                    if let firstOverdueTask = overdueTasks.first {
                        taskToReschedule = firstOverdueTask
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 14))
                        Text("Reschedule")
                            .font(.dmsans(size: 14))
                    }
                    .foregroundColor(.red)
                }
                
                // Toggle Button
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showOverdueTasks.toggle()
                    }
                } label: {
                    Image(systemName: showOverdueTasks ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                }
            }
            
            // Overdue Tasks List
            if showOverdueTasks {
                VStack(spacing: 0) {
                    ForEach(overdueTasks) { task in
                        TaskListCard(
                            task: task,
                            onToggle: { viewModel.toggleCompletion(for: task) },
                            onReschedule: {
                                taskToReschedule = task
                            },
                            onDelete: { viewModel.deleteTask(task) },
                            onTap: {
                                selectedTask = task
                            },
                            isOverdue: true
                        )
                        .padding(.vertical, 6)
                        
                        if task.id != overdueTasks.last?.id {
                            MenuDivider()
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
    
    // MARK: - Today Section
    private var todaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Today Header
            HStack {
                Text(todayDateString)
                    .font(.dmsansBold(size: 18))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            // Today Tasks List
            if todayTasks.isEmpty {
                emptyStateView
                    .padding(.top, 20)
            } else {
                VStack(spacing: 0) {
                    ForEach(todayTasks) { task in
                        TaskListCard(
                            task: task,
                            onToggle: { viewModel.toggleCompletion(for: task) },
                            onReschedule: {
                                taskToReschedule = task
                            },
                            onDelete: { viewModel.deleteTask(task) },
                            onTap: {
                                selectedTask = task
                            }
                        )
                        .padding(.vertical, 6)
                        
                        if task.id != todayTasks.last?.id {
                            MenuDivider()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 60))
                .foregroundColor(.green.opacity(0.5))
            
            Text("All caught up!")
                .font(.dmsans(weight: .semibold, size: 20))
                .foregroundColor(.primary)
            
            Text("No tasks scheduled for today")
                .font(.dmsans(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - Refresh Tasks
    @MainActor
    private func refreshTasks() async {
        await viewModel.refreshTasks()
    }
    
    // MARK: - Reschedule Logic
    private func rescheduleTask(_ task: TaskItem, to newDate: Date) {
        let calendar = Calendar.current
        let oldDate = task.dueDate ?? Date()
        
        let oldComponents = calendar.dateComponents([.year, .month, .day], from: oldDate)
        let newComponents = calendar.dateComponents([.year, .month, .day], from: newDate)
        
        if oldComponents == newComponents {
            return
        }
        
        lastRescheduledTask = (task, task.dueDate)
        viewModel.rescheduleTask(task, to: newDate)
        
        let dateFormatter = DateFormatter()
        
        if calendar.isDateInToday(newDate) {
            undoMessage = "Scheduled for Today"
        } else if calendar.isDateInTomorrow(newDate) {
            undoMessage = "Scheduled for Tomorrow"
        } else {
            dateFormatter.dateFormat = "MMM d"
            undoMessage = "Scheduled for \(dateFormatter.string(from: newDate))"
        }
        
        showUndoToast = true
        triggerDismiss = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            triggerDismiss = true
        }
    }
    
    private func undoReschedule() {
        guard let (task, oldDate) = lastRescheduledTask else { return }
        
        viewModel.rescheduleTask(task, to: oldDate)
        showUndoToast = false
        triggerDismiss = false
        lastRescheduledTask = nil
    }
}

#Preview {
    TodayView()
}
