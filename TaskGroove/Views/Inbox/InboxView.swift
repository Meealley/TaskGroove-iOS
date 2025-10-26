//
//  InboxView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import SwiftUI

struct InboxView: View {
    @StateObject private var viewModel = InboxViewModel()
    @StateObject private var authManager = AuthenticationManager()
    @State private var navigationPath = NavigationPath()
    @State private var taskToReschedule: TaskItem?
    @State private var showUndoToast = false
    @State private var undoMessage = ""
    @State private var lastRescheduledTask: (task: TaskItem, oldDate: Date?)?
    @State private var triggerDismiss = false
    
    private var userName: String {
        if let displayName = authManager.user?.displayName, !displayName.isEmpty {
            return displayName.components(separatedBy: " ").first ?? "User"
        } else if let email = authManager.user?.email {
            return email.components(separatedBy: "@").first?.capitalized ?? "User"
        }
        return "User"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    tasksContent
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100) // Extra padding for FAB
                }
            }
            .refreshable {
                await refreshTasks()
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
            .overlay {
                // Loading indicator (non-blocking, only on initial empty state)
                if viewModel.isLoading && viewModel.tasks.isEmpty {
                    VStack {
                        ProgressView("Loading tasks...")
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                }
            }
            .overlay(alignment: .bottom) {
                // Undo Toast with built-in animation
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
            .navigationTitle("Inbox")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                toolbarContent
            }
            .sheet(isPresented: $viewModel.showViewSheet) {
                ViewFilterSheet(viewModel: viewModel)
                    .presentationDragIndicator(.visible)
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
        }
    }
    
    // MARK: - Refresh Tasks
    @MainActor
    private func refreshTasks() async {
        await viewModel.refreshTasks()
    }
    
    // MARK: - Tasks Content
    @ViewBuilder
    private var tasksContent: some View {
        switch viewModel.selectedViewStyle {
        case .list:
            listView
        case .board:
            boardView
        case .calendar:
            calendarView
        }
    }
    
    // MARK: - List View
    private var listView: some View {
        VStack(spacing: 0) {
            if viewModel.filteredTasks.isEmpty {
                emptyStateView
                    .padding(.top, 60)
            } else {
                ForEach(viewModel.filteredTasks) { task in
                    TaskListCard(
                        task: task,
                        onToggle: { viewModel.toggleCompletion(for: task) },
                        onReschedule: {
                            taskToReschedule = task
                        },
                        onDelete: { viewModel.deleteTask(task) }
                    )
                    .padding(.vertical, 6)
                    
                    if task.id != viewModel.filteredTasks.last?.id {
                        MenuDivider()
                    }
                }
            }
        }
    }
    
    // MARK: - Board View
    private var boardView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 15),
            GridItem(.flexible(), spacing: 15)
        ], spacing: 15) {
            ForEach(viewModel.filteredTasks) { task in
                TaskBoardCard(
                    task: task,
                    onToggle: { viewModel.toggleCompletion(for: task) }
                )
            }
        }
    }
    
    // MARK: - Calendar View
    private var calendarView: some View {
        VStack(spacing: 15) {
            ForEach(viewModel.filteredTasks) { task in
                TaskCalendarCard(
                    task: task,
                    onToggle: { viewModel.toggleCompletion(for: task) }
                )
            }
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No tasks yet")
                .font(.dmsans(weight: .semibold, size: 20))
                .foregroundColor(.primary)
            
            Text("Tap the + button to create your first task")
                .font(.dmsans(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Toolbar Content
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.showViewSheet = true
            } label: {
                Image(systemName: "rectangle.stack.fill")
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            DMSansMenuButton(
                icon: "ellipsis.circle",
                title: nil,
                items: [
                    DMSansMenuButton.MenuItem(
                        title: "Activity",
                        icon: "chart.bar.fill",
                        color: .label,
                        isDestructive: false,
                        action: {
                            navigationPath.append("Activity")
                        }
                    ),
                    DMSansMenuButton.MenuItem(
                        title: "Add Section",
                        icon: "square.on.square.squareshape.controlhandles",
                        color: .label,
                        isDestructive: false,
                        action: {
                            navigationPath.append("AddSection")
                        }
                    ),
                    DMSansMenuButton.MenuItem(
                        title: "Comments",
                        icon: "message",
                        color: .label,
                        isDestructive: false,
                        action: {
                            navigationPath.append("Comments")
                        }
                    )
                ],
                tintColor: .label
            )
        }
    }
    
    // MARK: - Reschedule Logic
    private func rescheduleTask(_ task: TaskItem, to newDate: Date) {
        // Check if date actually changed
        let calendar = Calendar.current
        let oldDate = task.dueDate ?? Date()
        
        // Compare only the date components (ignoring time)
        let oldComponents = calendar.dateComponents([.year, .month, .day], from: oldDate)
        let newComponents = calendar.dateComponents([.year, .month, .day], from: newDate)
        
        // If dates are the same, don't do anything
        if oldComponents == newComponents {
            return
        }
        
        // Store old date for undo
        lastRescheduledTask = (task, task.dueDate)
        
        // Update the task
        viewModel.rescheduleTask(task, to: newDate)
        
        // Format the date for the message
        let dateFormatter = DateFormatter()
        
        if calendar.isDateInToday(newDate) {
            undoMessage = "Scheduled for Today"
        } else if calendar.isDateInTomorrow(newDate) {
            undoMessage = "Scheduled for Tomorrow"
        } else {
            dateFormatter.dateFormat = "MMM d"
            undoMessage = "Scheduled for \(dateFormatter.string(from: newDate))"
        }
        
        // Show toast (animation handled by toast itself)
        showUndoToast = true
        triggerDismiss = false
        
        // Auto-dismiss after 5 seconds - trigger animation first
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            triggerDismiss = true
        }
    }
    
    private func undoReschedule() {
        guard let (task, oldDate) = lastRescheduledTask else { return }
        
        // Revert to old date
        viewModel.rescheduleTask(task, to: oldDate)
        
        // Hide toast (animation handled by toast itself)
        showUndoToast = false
        triggerDismiss = false
        
        lastRescheduledTask = nil
    }
}

#Preview {
    InboxView()
}
