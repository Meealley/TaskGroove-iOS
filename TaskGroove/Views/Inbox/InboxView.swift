////
////  InboxView.swift
////  TaskGroove
////
////  Created by Oyewale Favour on 16/10/2025.
////
//
//import SwiftUI
//
//struct InboxView: View {
//    @StateObject private var viewModel = InboxViewModel()
//    @StateObject private var authManager = AuthenticationManager()
//    @State private var navigationPath = NavigationPath()
//    @State private var showRescheduleSheet = false
//    @State private var taskToReschedule: TaskItem?
//    @State private var showUndoToast = false
//    @State private var undoMessage = ""
//    @State private var lastRescheduledTask: (task: TaskItem, oldDate: Date?)?
//    
//    private var userName: String {
//        if let displayName = authManager.user?.displayName, !displayName.isEmpty {
//            return displayName.components(separatedBy: " ").first ?? "User"
//        } else if let email = authManager.user?.email {
//            return email.components(separatedBy: "@").first?.capitalized ?? "User"
//        }
//        return "User"
//    }
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                // Content
//                ScrollView {
//                    VStack(spacing: 20) {
//                        tasksContent
//                            .padding(.horizontal, 20)
//                            .padding(.bottom, 80)
//                    }
//                    .padding(.bottom, 30)
//                }
//                
//                // Floating Action Button
//                floatingActionButton
//                
//                // Undo Toast
//                if showUndoToast {
//                    undoToastOverlay
//                }
//            }
//            .navigationTitle("Inbox")
//            .navigationBarTitleDisplayMode(.large)
//            .toolbar {
//                toolbarContent
//            }
//            .sheet(isPresented: $viewModel.showViewSheet) {
//                ViewFilterSheet(viewModel: viewModel)
//                    .presentationDragIndicator(.visible)
//            }
//            .sheet(isPresented: $viewModel.showTaskSheet) {
//                CreateTaskSheet(viewModel: viewModel)
//                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.5)])
//                    .presentationDragIndicator(.visible)
//                    .presentationBackgroundInteraction(.disabled)
//                    .interactiveDismissDisabled(false)
//            }
//            .sheet(isPresented: $showRescheduleSheet) {
//                if let task = taskToReschedule {
//                    RescheduleDateSheet(
//                        task: task,
//                        onReschedule: { newDate in
//                            rescheduleTask(task, to: newDate)
//                        }
//                    )
//                    .presentationDetents([.large])
//                    .presentationDragIndicator(.visible)
//                }
//            }
//        }
//    }
//    
//    // MARK: - Undo Toast Overlay
//    private var undoToastOverlay: some View {
//        VStack {
//            Spacer()
//            UndoToastView(
//                message: undoMessage,
//                onUndo: undoReschedule,
//                onDismiss: { showUndoToast = false }
//            )
//            .padding(.bottom, 100)
//            .padding(.horizontal, 20)
//            .transition(.move(edge: .bottom).combined(with: .opacity))
//        }
//    }
//    
//    // MARK: - Tasks Content
//    @ViewBuilder
//    private var tasksContent: some View {
//        switch viewModel.selectedViewStyle {
//        case .list:
//            listView
//        case .board:
//            boardView
//        case .calendar:
//            calendarView
//        }
//    }
//    
//    // MARK: - List View
//    private var listView: some View {
//        VStack(spacing: 12) {
//            ForEach(viewModel.filteredTasks) { task in
//                TaskListCard(
//                    task: task,
//                    onToggle: { viewModel.toggleCompletion(for: task) },
//                    onReschedule: {
//                        taskToReschedule = task
//                        showRescheduleSheet = true
//                    },
//                    onDelete: { viewModel.deleteTask(task) }
//                )
//            }
//        }
//    }
//    
//    // MARK: - Board View
//    private var boardView: some View {
//        LazyVGrid(columns: [
//            GridItem(.flexible(), spacing: 15),
//            GridItem(.flexible(), spacing: 15)
//        ], spacing: 15) {
//            ForEach(viewModel.filteredTasks) { task in
//                TaskBoardCard(
//                    task: task,
//                    onToggle: { viewModel.toggleCompletion(for: task) }
//                )
//            }
//        }
//    }
//    
//    // MARK: - Calendar View
//    private var calendarView: some View {
//        VStack(spacing: 15) {
//            ForEach(viewModel.filteredTasks) { task in
//                TaskCalendarCard(
//                    task: task,
//                    onToggle: { viewModel.toggleCompletion(for: task) }
//                )
//            }
//        }
//    }
//    
//    // MARK: - Floating Action Button
//    private var floatingActionButton: some View {
//        VStack {
//            Spacer()
//            HStack {
//                Spacer()
//                Button {
//                    viewModel.showTaskSheet = true
//                } label: {
//                    Image(systemName: "plus")
//                        .font(.system(size: 24, weight: .semibold))
//                        .foregroundColor(.white)
//                        .frame(width: 60, height: 60)
//                        .background(
//                            LinearGradient(
//                                colors: [.blue, .purple],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                        .clipShape(Circle())
//                        .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
//                }
//                .padding(.trailing, 20)
//                .padding(.bottom, 20)
//            }
//        }
//    }
//    
//    // MARK: - Toolbar Content
//    @ToolbarContentBuilder
//    private var toolbarContent: some ToolbarContent {
//        ToolbarItem(placement: .navigationBarTrailing) {
//            Button {
//                viewModel.showViewSheet = true
//            } label: {
//                Image(systemName: "rectangle.stack.fill")
//            }
//        }
//        
//        ToolbarItem(placement: .navigationBarTrailing) {
//            DMSansMenuButton(
//                icon: "ellipsis.circle",
//                title: nil,
//                items: [
//                    DMSansMenuButton.MenuItem(
//                        title: "Activity",
//                        icon: "chart.bar.fill",
//                        color: .label,
//                        isDestructive: false,
//                        action: {
//                            navigationPath.append("Activity")
//                        }
//                    ),
//                    DMSansMenuButton.MenuItem(
//                        title: "Add Section",
//                        icon: "square.on.square.squareshape.controlhandles",
//                        color: .label,
//                        isDestructive: false,
//                        action: {
//                            navigationPath.append("AddSection")
//                        }
//                    ),
//                    DMSansMenuButton.MenuItem(
//                        title: "Comments",
//                        icon: "message",
//                        color: .label,
//                        isDestructive: false,
//                        action: {
//                            navigationPath.append("Comments")
//                        }
//                    )
//                ],
//                tintColor: .label
//            )
//        }
//    }
//    
//    // MARK: - Reschedule Logic
//    private func rescheduleTask(_ task: TaskItem, to newDate: Date) {
//        // Check if date actually changed
//        let calendar = Calendar.current
//        let oldDate = task.dueDate ?? Date()
//        
//        // Compare only the date components (ignoring time)
//        let oldComponents = calendar.dateComponents([.year, .month, .day], from: oldDate)
//        let newComponents = calendar.dateComponents([.year, .month, .day], from: newDate)
//        
//        // If dates are the same, don't do anything
//        if oldComponents == newComponents {
//            return
//        }
//        
//        // Store old date for undo
//        lastRescheduledTask = (task, task.dueDate)
//        
//        // Update the task
//        viewModel.rescheduleTask(task, to: newDate)
//        
//        // Format the date for the message
//        let dateFormatter = DateFormatter()
//        
//        if calendar.isDateInToday(newDate) {
//            undoMessage = "Scheduled for Today"
//        } else if calendar.isDateInTomorrow(newDate) {
//            undoMessage = "Scheduled for Tomorrow"
//        } else {
//            dateFormatter.dateFormat = "MMM d"
//            undoMessage = "Scheduled for \(dateFormatter.string(from: newDate))"
//        }
//        
//        // Show toast
//        withAnimation(.spring(response: 0.3)) {
//            showUndoToast = true
//        }
//        
//        // Auto-dismiss after 5 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            withAnimation(.spring(response: 0.3)) {
//                showUndoToast = false
//            }
//        }
//    }
//    
//    private func undoReschedule() {
//        guard let (task, oldDate) = lastRescheduledTask else { return }
//        
//        // Revert to old date
//        viewModel.rescheduleTask(task, to: oldDate)
//        
//        // Hide toast
//        withAnimation(.spring(response: 0.3)) {
//            showUndoToast = false
//        }
//        
//        lastRescheduledTask = nil
//    }
//}
//
//// MARK: - Reschedule Date Sheet
//struct RescheduleDateSheet: View {
//    let task: TaskItem
//    let onReschedule: (Date) -> Void
//    @Environment(\.dismiss) var dismiss
//    @State private var selectedDate: Date
//    @State private var selectedQuickOption: QuickDateOption?
//    
//    init(task: TaskItem, onReschedule: @escaping (Date) -> Void) {
//        self.task = task
//        self.onReschedule = onReschedule
//        // Initialize with task's due date immediately
//        _selectedDate = State(initialValue: task.dueDate ?? Date())
//    }
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 16) {
//                    taskInfoHeader
//                    quickOptionsSection
//                    calendarSection
//                }
//                .padding(.bottom, 20)
//            }
//            .background(Color(.systemGroupedBackground))
//            .navigationTitle("Reschedule")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                toolbarItems
//            }
//        }
//    }
//    
//    // MARK: - Task Info Header
//    private var taskInfoHeader: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text(task.name)
//                .font(.dmsansBold(size: 18))
//                .foregroundColor(.primary)
//            
//            if let currentDate = task.dueDate {
//                HStack(spacing: 4) {
//                    Image(systemName: "calendar")
//                        .font(.system(size: 12))
//                    Text("Currently: \(currentDate.formatted(.dateTime.month().day()))")
//                        .font(.dmsans(size: 14))
//                }
//                .foregroundColor(.secondary)
//            }
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding(.horizontal, 20)
//        .padding(.top, 16)
//    }
//    
//    // MARK: - Quick Options Section
//    private var quickOptionsSection: some View {
//        VStack(spacing: 0) {
//            ForEach(QuickDateOption.allCases, id: \.self) { option in
//                quickOptionButton(for: option)
//                
//                if option != QuickDateOption.allCases.last {
//                    Divider()
//                        .padding(.leading, 66)
//                }
//            }
//        }
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .padding(.horizontal)
//    }
//    
//    // MARK: - Quick Option Button
//    private func quickOptionButton(for option: QuickDateOption) -> some View {
//        Button(action: {
//            selectedQuickOption = option
//            selectedDate = option.date
//        }) {
//            HStack(spacing: 16) {
//                Image(systemName: option.icon)
//                    .font(.system(size: 20))
////                    .foregroundColor(option.iconColor)
//                    .frame(width: 30)
//                
//                Text(option.title)
//                    .font(.dmsans(size: 16))
//                    .foregroundColor(.primary)
//                
//                Spacer()
//                
//                Text(option.dayText)
//                    .font(.dmsans(size: 14))
//                    .foregroundColor(.secondary)
//            }
//            .padding(.horizontal, 20)
//            .padding(.vertical, 14)
//            .background(
//                selectedQuickOption == option ? Color.blue.opacity(0.1) : Color.clear
//            )
//        }
//    }
//    
//    // MARK: - Calendar Section
//    private var calendarSection: some View {
//        DatePicker("", selection: $selectedDate, displayedComponents: [.date])
//            .datePickerStyle(.graphical)
//            .padding(.horizontal)
//    }
//    
//    // MARK: - Toolbar Items
//    @ToolbarContentBuilder
//    private var toolbarItems: some ToolbarContent {
//        ToolbarItem(placement: .navigationBarLeading) {
//            Button("Cancel") {
//                dismiss()
//            }
//            .font(.dmsans())
//        }
//        
//        ToolbarItem(placement: .navigationBarTrailing) {
//            Button("Done") {
//                onReschedule(selectedDate)
//                dismiss()
//            }
//            .font(.dmsansBold())
//            .foregroundColor(.blue)
//        }
//    }
//}
//
//// MARK: - Undo Toast View
//struct UndoToastView: View {
//    let message: String
//    let onUndo: () -> Void
//    let onDismiss: () -> Void
//    
//    var body: some View {
//        HStack(spacing: 12) {
//            Image(systemName: "calendar.badge.checkmark")
//                .font(.system(size: 18))
//                .foregroundColor(.white)
//            
//            Text(message)
//                .font(.dmsans(size: 15))
//                .foregroundColor(.white)
//            
//            Spacer()
//            
//            Button(action: onUndo) {
//                Text("Undo")
//                    .font(.dmsansBold(size: 15))
//                    .foregroundColor(.white)
//            }
//            
//            Button(action: onDismiss) {
//                Image(systemName: "xmark")
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(.white.opacity(0.8))
//            }
//        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 14)
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.black.opacity(0.85))
//        )
//        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
//    }
//}
//
//// MARK: - Quick Date Option
////enum QuickDateOption: CaseIterable {
////    case today, tomorrow, thisWeekend, nextWeek
////    
////    var title: String {
////        switch self {
////        case .today: return "Today"
////        case .tomorrow: return "Tomorrow"
////        case .thisWeekend: return "This Weekend"
////        case .nextWeek: return "Next Week"
////        }
////    }
////    
////    var icon: String {
////        switch self {
////        case .today: return "calendar"
////        case .tomorrow: return "sun.max"
////        case .thisWeekend: return "sofa"
////        case .nextWeek: return "calendar.badge.plus"
////        }
////    }
////    
////    var iconColor: Color {
////        switch self {
////        case .today: return .green
////        case .tomorrow: return .orange
////        case .thisWeekend: return .blue
////        case .nextWeek: return .purple
////        }
////    }
////    
////    var date: Date {
////        let calendar = Calendar.current
////        switch self {
////        case .today:
////            return Date()
////        case .tomorrow:
////            return calendar.date(byAdding: .day, value: 1, to: Date())!
////        case .thisWeekend:
////            let weekday = calendar.component(.weekday, from: Date())
////            let daysUntilSaturday = (7 - weekday + 7) % 7
////            return calendar.date(byAdding: .day, value: daysUntilSaturday == 0 ? 7 : daysUntilSaturday, to: Date())!
////        case .nextWeek:
////            return calendar.date(byAdding: .weekOfYear, value: 1, to: Date())!
////        }
////    }
////    
////    var dayText: String {
////        let formatter = DateFormatter()
////        formatter.dateFormat = "EEE"
////        return formatter.string(from: date)
////    }
////}
//
//#Preview {
//    InboxView()
//}



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
            ZStack {
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        tasksContent
                            .padding(.horizontal, 20)
                            .padding(.bottom, 80)
                    }
                    .padding(.bottom, 30)
                }
                
                // Floating Action Button
                floatingActionButton
                
                // Undo Toast
                if showUndoToast {
                    undoToastOverlay
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
                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.5)])
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
    
    // MARK: - Undo Toast Overlay
    private var undoToastOverlay: some View {
        VStack {
            Spacer()
            UndoToastView(
                message: undoMessage,
                onUndo: undoReschedule,
                onDismiss: { showUndoToast = false }
            )
            .padding(.bottom, 100)
            .padding(.horizontal, 20)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
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
        VStack(spacing: 12) {
            ForEach(viewModel.filteredTasks) { task in
                TaskListCard(
                    task: task,
                    onToggle: { viewModel.toggleCompletion(for: task) },
                    onReschedule: {
                        taskToReschedule = task
                    },
                    onDelete: { viewModel.deleteTask(task) }
                )
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
    
    // MARK: - Floating Action Button
    private var floatingActionButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
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
        }
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
        
        // Show toast
        withAnimation(.spring(response: 0.3)) {
            showUndoToast = true
        }
        
        // Auto-dismiss after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.spring(response: 0.3)) {
                showUndoToast = false
            }
        }
    }
    
    private func undoReschedule() {
        guard let (task, oldDate) = lastRescheduledTask else { return }
        
        // Revert to old date
        viewModel.rescheduleTask(task, to: oldDate)
        
        // Hide toast
        withAnimation(.spring(response: 0.3)) {
            showUndoToast = false
        }
        
        lastRescheduledTask = nil
    }
}

// MARK: - TaskItem Extension for Sheet Presentation
//extension TaskItem: Identifiable {}

#Preview {
    InboxView()
}
