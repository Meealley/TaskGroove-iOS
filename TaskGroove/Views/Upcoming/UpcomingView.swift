//
//  UpcomingView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

import SwiftUI

struct UpcomingView: View {
    @ObservedObject var viewModel: InboxViewModel
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var isCalendarExpanded = true
    @State private var scrollViewOffset: CGFloat = 0
    @State private var currentVisibleDate = Date()
    @State private var taskToReschedule: TaskItem?
    @State private var showUndoToast = false
    @State private var undoMessage = ""
    @State private var lastRescheduledTask: (task: TaskItem, oldDate: Date?)?
    @State private var triggerDismiss = false
    @State private var selectedTask: TaskItem?
    @State private var taskToEdit: TaskItem?
    
    // Dynamic: Generate dates for 20 months from today
    private var allDates: [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        
        // Start from today
        let today = calendar.startOfDay(for: Date())
        
        // End date: 20 months from today
        guard let endDate = calendar.date(byAdding: .month, value: 20, to: today) else {
            return []
        }
        
        var currentDate = today
        
        while currentDate <= endDate {
            dates.append(currentDate)
            
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        
        return dates
    }
    
    // Get tasks for a specific date
    private func tasksForDate(_ date: Date) -> [TaskItem] {
        let calendar = Calendar.current
        return viewModel.tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }
        .sorted { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Month/Year Selector (Tappable)
                    MonthYearHeader(
                        currentMonth: $currentMonth,
                        isExpanded: $isCalendarExpanded,
                        currentVisibleDate: currentVisibleDate
                    )
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Animated Calendar - Full or Compact
                    Group {
                        if isCalendarExpanded {
                            CalendarGridView(
                                currentMonth: $currentMonth,
                                selectedDate: $selectedDate,
                                currentVisibleDate: $currentVisibleDate,
                                viewModel: viewModel
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 20)
                        } else {
                            CompactCalendarView(
                                currentMonth: $currentMonth,
                                selectedDate: $selectedDate,
                                currentVisibleDate: $currentVisibleDate,
                                viewModel: viewModel
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 15)
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: isCalendarExpanded)
                    
                    // Divider
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .padding(.horizontal)
                        .padding(.top, isCalendarExpanded ? 0 : 10)
                    
                    // Daily Tasks List with scroll tracking
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                ForEach(allDates, id: \.self) { date in
                                    DailyTaskSection(
                                        date: date,
                                        tasks: tasksForDate(date),
                                        onToggle: { task in
                                            viewModel.toggleCompletion(for: task)
                                        },
                                        onReschedule: { task in
                                            taskToReschedule = task
                                        },
                                        onDelete: { task in
                                            viewModel.deleteTask(task)
                                        },
                                        onTap: { task in
                                            selectedTask = task
                                        }
                                    )
                                    .id(date)
                                    .padding(.horizontal)
                                    .padding(.top, 20)
                                    .background(
                                        GeometryReader { geometry in
                                            let minY = geometry.frame(in: .named("scrollView")).minY
                                            Color.clear
                                                .preference(
                                                    key: VisibleDatePreferenceKey.self,
                                                    value: [VisibleDateData(date: date, minY: minY)]
                                                )
                                        }
                                    )
                                }
                            }
                            .coordinateSpace(name: "scrollView")
                        }
                        .onPreferenceChange(VisibleDatePreferenceKey.self) { values in
                            // Find the date closest to the top (between 0 and 150)
                            if let topDate = values
                                .filter({ $0.minY >= 0 && $0.minY <= 150 })
                                .sorted(by: { $0.minY < $1.minY })
                                .first?.date {
                                
                                // Update current visible date (for month header tracking)
                                if !Calendar.current.isDate(currentVisibleDate, inSameDayAs: topDate) {
                                    currentVisibleDate = topDate
                                }
                                
                                // Update current month if needed
                                let calendar = Calendar.current
                                if !calendar.isDate(currentMonth, equalTo: topDate, toGranularity: .month) {
                                    currentMonth = topDate
                                }
                            }
                        }
                        .onChange(of: selectedDate) { _, newDate in
                            // Scroll to selected date when calendar date is tapped
                            withAnimation {
                                proxy.scrollTo(newDate, anchor: .top)
                            }
                        }
                        .onAppear {
                            // Scroll to today on initial load
                            let today = Calendar.current.startOfDay(for: Date())
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                proxy.scrollTo(today, anchor: .top)
                            }
                        }
                    }
                    
                    Spacer()
                }
                
                // Undo Toast
                if showUndoToast {
                    VStack {
                        Spacer()
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
            }
            .navigationTitle("Upcoming")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "calendar")
                        .foregroundColor(.orange)
                        .font(.title2)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.orange)
                        .font(.title3)
                }
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
            .sheet(item: $selectedTask) { task in
                TaskDetailSheet(
                    task: task,
                    onEdit: {
                        selectedTask = nil
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
            .sheet(item: $taskToEdit) { task in
                EditTaskSheet(task: task) { updatedTask in
                    viewModel.updateTask(updatedTask)
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        }
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

// Preference key for tracking visible dates in task list
struct VisibleDateData: Equatable {
    let date: Date
    let minY: CGFloat
}

struct VisibleDatePreferenceKey: PreferenceKey {
    static var defaultValue: [VisibleDateData] = []
    
    static func reduce(value: inout [VisibleDateData], nextValue: () -> [VisibleDateData]) {
        value.append(contentsOf: nextValue())
    }
}

#Preview {
    UpcomingContainerView()
}
