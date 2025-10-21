//
//  CreateTaskSheet.swift
//  TaskGroove
//
//  Redesigned with inline editing approach
//

import SwiftUI

struct CreateTaskSheet: View {
    @ObservedObject var viewModel: InboxViewModel
    @StateObject private var createViewModel = CreateTaskViewModel()
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTaskNameFocused: Bool
    @State private var showDatePicker = false
    @State private var showPriorityPicker = false
    @State private var showReminderPicker = false
    @State private var showProjectPicker = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Main Content
                    VStack(spacing: 16) {
                        // Task Input Card
                        taskInputSection
                        
                        // Quick Action Pills - Closer to input
                        quickActionPills
                            .padding(.horizontal, 20)
                            .padding(.bottom, 8)
                    }
                    
                    Spacer()
                    
                    // Bottom Send Button
                    bottomActionBar
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showDatePicker) {
                DatePickerSheet(
                    selectedDate: $createViewModel.dueDate,
                    onDismiss: { showDatePicker = false }
                )
                .presentationDetents([.height(800)])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showPriorityPicker) {
                PriorityPickerSheet(
                    selectedPriority: $createViewModel.selectedPriority,
                    onDismiss: { showPriorityPicker = false }
                )
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showReminderPicker) {
                ReminderPickerSheet(
                    reminderTime: $createViewModel.reminder,
                    onDismiss: { showReminderPicker = false }
                )
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
            }
            .onAppear {
                // Delay slightly to ensure sheet is presented before focusing
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isTaskNameFocused = true
                }
            }
        }
    }
    
    // MARK: - Task Input Section
    private var taskInputSection: some View {
        VStack(spacing: 5) {
            // Header with Cancel
            HStack {
                
                Text("Inbox")
                    .font(.dmsansBold(size: 24))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            // Task Input Area
            VStack(spacing: 8) {
                // Task with checkbox
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                        .frame(width: 24, height: 24)
                        .padding(.top, 2)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        TextField("Task Name", text: $createViewModel.taskName)
                            .font(.dmsans(size: 18))
                            .foregroundColor(.primary)
                            .focused($isTaskNameFocused)
                        
                        TextField("Description", text: $createViewModel.taskDescription, axis: .vertical)
                            .font(.dmsans(size: 14))
                            .foregroundColor(.secondary)
                            .lineLimit(1...3)
                    }
                }
                .padding(.horizontal, 20)
                
                // Date Label (if selected)
                if createViewModel.dueDate != Date() {
                    HStack {
                        Spacer()
                            .frame(width: 36) // Align with text
                        
                        DateChip(date: createViewModel.dueDate)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                }
            }
            .padding(.bottom, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    // MARK: - Project Section
    private var projectSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Books") // Or dynamic project name
                .font(.dmsansBold(size: 18))
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
            
            // Could add a horizontal scroll of projects here
        }
    }
    
    // MARK: - Quick Action Pills
    private var quickActionPills: some View {
        HStack(spacing: 10) {
            ActionPill(
                icon: "calendar",
                title: "Date",
                color: .blue,
                isActive: createViewModel.dueDate != Date()
            ) {
                showDatePicker = true
            }
            
            DMSansMenuButton(
                icon: "flag",
                title: "Priority",
                items: TaskItem.Priority.allCases.map { priority in
                    DMSansMenuButton.MenuItem(
                        title: priority.rawValue.capitalized,
                        icon: "flag.fill",
                        color: UIColor(priority.color),
                        isDestructive: false,
                        action: {
                            createViewModel.selectedPriority = priority
                        }
                    )
                },
                tintColor: UIColor(createViewModel.selectedPriority.color)
            )
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(createViewModel.selectedPriority.color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(createViewModel.selectedPriority.color.opacity(0.2), lineWidth: 1)
                    )
            )
            .frame(width: 90, height: 36)
            
            
//            ActionPill(
//                icon: "flag",
//                title: "Priority",
//                color: .orange,
//                isActive: createViewModel.selectedPriority != .low
//            ) {
//                showPriorityPicker = true
//            }
            
            ActionPill(
                icon: "bell",
                title: "Reminders",
                color: .purple,
                isActive: false
            ) {
                showReminderPicker = true
            }
            
            ActionPill(
                icon: "ellipsis",
                title: nil,
                color: .gray,
                isActive: false
            ) {
                // Show more options
            }
        }
    }
    
    // MARK: - Bottom Action Bar
    private var bottomActionBar: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 16) {
                // Project Selector
                Button(action: { showProjectPicker = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "tray")
                            .font(.system(size: 16))
                        Text("Inbox")
                            .font(.dmsans(size: 14))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Send Button
                Button(action: saveTask) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(createViewModel.isFormValid ? .blue : .gray.opacity(0.3))
                }
                .disabled(!createViewModel.isFormValid)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
    }
    
    // MARK: - Save Task
    private func saveTask() {
        let newTask = createViewModel.createTask()
        viewModel.addTask(newTask)
        createViewModel.resetForm()
        dismiss()
    }
}

// MARK: - Action Pill Component
struct ActionPill: View {
    let icon: String
    let title: String?
    let color: Color
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                
                if let title = title {
                    Text(title)
                        .font(.dmsans(size: 14))
                }
            }
            .foregroundColor(isActive ? .white : color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isActive ? color : color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(color.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Date Chip
struct DateChip: View {
    let date: Date
    
    private var dateText: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            return date.formatted(.dateTime.month(.abbreviated).day())
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
                .font(.system(size: 10))
            Text(dateText)
                .font(.dmsans(size: 12))
        }
        .foregroundColor(.orange)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.orange.opacity(0.1))
        )
    }
}


//  Enhanced Date Picker with functional search

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    let onDismiss: () -> Void
    
    @State private var tempDate = Date()
    @State private var selectedQuickOption: QuickDateOption?
    @State private var searchText = ""
    @State private var isSearching = false
    @FocusState private var searchFieldFocused: Bool
    @State private var showTimePicker = false
    @State private var selectedTime: Date = Date()
    
    // Search suggestions based on input
    // Updated
    private var searchSuggestions: [DateSuggestion] {
        if searchText.isEmpty { return [] }

        let lowercased = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        var suggestions: [DateSuggestion] = []

        // MARK: - Natural Keywords
        if lowercased.contains("today") {
            suggestions.append(DateSuggestion(text: "Today", date: Date()))
        }
        if lowercased.contains("tomorrow") {
            suggestions.append(DateSuggestion(text: "Tomorrow", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!))
        }
        if lowercased.contains("next week") {
            suggestions.append(DateSuggestion(text: "Next Week", date: Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!))
        }
        if lowercased.contains("weekend") {
            suggestions.append(DateSuggestion(text: "This Weekend", date: nextWeekday(7)))
        }

        // Weekday recognition
        let weekdays = [
            "monday": 2, "tuesday": 3, "wednesday": 4,
            "thursday": 5, "friday": 6, "saturday": 7, "sunday": 1
        ]
        for (day, num) in weekdays where lowercased.contains(day) {
            suggestions.append(DateSuggestion(text: "Next \(day.capitalized)", date: nextWeekday(num)))
        }

        // MARK: - Date Parsing (e.g. "nov 13", "13 november 2025", "10/21")
        let dateFormats = [
            "MMMM d, yyyy", "MMMM d yyyy", "MMMM d", "MMM d", "MMM d yyyy",
            "d MMM yyyy", "d MMM", "MM/dd/yyyy", "MM/dd", "dd/MM/yyyy", "dd/MM"
        ]

        for format in dateFormats {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = .current

            if let parsedDate = formatter.date(from: lowercased.capitalized) {
                let df = DateFormatter()
                df.dateFormat = "MMMM d, yyyy"
                let displayText = df.string(from: parsedDate)
                suggestions.append(DateSuggestion(text: displayText, date: parsedDate))
                break
            }
        }

        // MARK: - Month-only matches ("november" -> 1st of that month)
        let months = [
            "january", "february", "march", "april", "may", "june",
            "july", "august", "september", "october", "november", "december"
        ]
        for (index, month) in months.enumerated() where lowercased.contains(month) {
            if let date = dateForMonth(index + 1) {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM d"
                suggestions.append(DateSuggestion(text: formatter.string(from: date), date: date))
            }
        }

        return suggestions
    }

    
    enum QuickDateOption: CaseIterable {
        case today, tomorrow, thisWeekend, nextWeek
        
        var title: String {
            switch self {
            case .today: return "Today"
            case .tomorrow: return "Tomorrow"
            case .thisWeekend: return "This Weekend"
            case .nextWeek: return "Next Week"
            }
        }
        
        var icon: String {
            switch self {
            case .today: return "calendar"
            case .tomorrow: return "sun.max"
            case .thisWeekend: return "sofa"
            case .nextWeek: return "calendar.badge.plus"
            }
        }
        
        var date: Date {
            let calendar = Calendar.current
            switch self {
            case .today:
                return Date()
            case .tomorrow:
                return calendar.date(byAdding: .day, value: 1, to: Date())!
            case .thisWeekend:
                let weekday = calendar.component(.weekday, from: Date())
                let daysUntilSaturday = (7 - weekday + 7) % 7
                return calendar.date(byAdding: .day, value: daysUntilSaturday == 0 ? 7 : daysUntilSaturday, to: Date())!
            case .nextWeek:
                return calendar.date(byAdding: .weekOfYear, value: 1, to: Date())!
            }
        }
        
        var dayText: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            return formatter.string(from: date)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main Content
                ScrollView {
                    VStack(spacing: 0) {
                        if !isSearching {
                            // Regular view when not searching
                            regularDatePickerContent
                        }
                    }
                }
                .opacity(isSearching ? 0 : 1)
                
                // Search Results Overlay
                if isSearching {
                    searchResultsView
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss()
                    }
                    .font(.dmsans())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        selectedDate = tempDate
                        onDismiss()
                    }
                    .font(.dmsansBold())
                    .foregroundColor(.blue)
                }
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Type a date"
            )
            .onSubmit(of: .search) {
                // Handle search submission
                if let firstSuggestion = searchSuggestions.first {
                    tempDate = firstSuggestion.date
                    searchText = ""
                    searchFieldFocused = false
                }
            }
            .onChange(of: searchText) { newValue in
                isSearching = !newValue.isEmpty
            }
        }
    }
    
    // MARK: - Regular Content
    private var regularDatePickerContent: some View {
        VStack(spacing: 16) {
            // Quick Options
            VStack(spacing: 0) {
                ForEach(QuickDateOption.allCases, id: \.self) { option in
                    Button(action: {
                        selectedQuickOption = option
                        tempDate = option.date
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: option.icon)
                                .font(.system(size: 20))
                                .foregroundColor(iconColor(for: option))
                                .frame(width: 30)
                            
                            Text(option.title)
                                .font(.dmsans(size: 16))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text(option.dayText)
                                .font(.dmsans(size: 14))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            selectedQuickOption == option ? Color.blue.opacity(0.1) : Color.clear
                        )
                    }
                    
                    if option != QuickDateOption.allCases.last {
                        Divider()
                            .padding(.leading, 66)
                    }
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.top, 16)
            
            // Calendar
            DatePicker("", selection: $tempDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding(.horizontal)
            
            // Time Options
            Button(action: { showTimePicker.toggle() }) {
                HStack(spacing: 12) {
                    Image(systemName: "clock")
                        .foregroundColor(.secondary)
                    Text("Time")
                        .font(.dmsans(size: 16))
                    Spacer()
                    Text(showTimePicker ? selectedTime.formatted(.dateTime.hour().minute()) : "None")
                        .font(.dmsans(size: 14))
                        .foregroundColor(.secondary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            
            if showTimePicker {
                DatePicker("", selection: $selectedTime, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .frame(height: 150)
                    .padding(.horizontal)
            }
            
            // Repeat Options
            Button(action: {}) {
                HStack(spacing: 12) {
                    Image(systemName: "repeat")
                        .foregroundColor(.secondary)
                    Text("Repeat")
                        .font(.dmsans(size: 16))
                    Spacer()
                    Text("None")
                        .font(.dmsans(size: 14))
                        .foregroundColor(.secondary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Search Results View
    private var searchResultsView: some View {
        VStack(alignment: .leading, spacing: 0) {
            if searchSuggestions.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.questionmark")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No date matches")
                        .font(.dmsans(size: 16))
                        .foregroundColor(.secondary)
                    
                    Text("Try typing 'tomorrow', 'next Monday', or a specific date")
                        .font(.dmsans(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(searchSuggestions) { suggestion in
                            Button(action: {
                                tempDate = suggestion.date
                                searchText = ""
                                isSearching = false
                                searchFieldFocused = false
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(suggestion.text)
                                            .font(.dmsans(size: 16))
                                            .foregroundColor(.primary)
                                        
                                        Text(suggestion.date.formatted(.dateTime.weekday(.wide).month().day()))
                                            .font(.dmsans(size: 14))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray.opacity(0.5))
                                }
                                .padding()
                                .background(Color(.systemBackground))
                            }
                            
                            Divider()
                        }
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Helper Functions
    private func iconColor(for option: QuickDateOption) -> Color {
        switch option {
        case .today: return .green
        case .tomorrow: return .orange
        case .thisWeekend: return .blue
        case .nextWeek: return .purple
        }
    }
    
    private func nextWeekday(_ weekday: Int) -> Date {
        let calendar = Calendar.current
        let today = Date()
        let currentWeekday = calendar.component(.weekday, from: today)
        
        var daysToAdd = weekday - currentWeekday
        if daysToAdd <= 0 {
            daysToAdd += 7
        }
        
        return calendar.date(byAdding: .day, value: daysToAdd, to: today)!
    }
    
    private func dateForMonth(_ month: Int) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.month = month
        
        // If the month has passed this year, use next year
        if month < calendar.component(.month, from: Date()) {
            components.year = (components.year ?? 0) + 1
        }
        
        return calendar.date(from: components)
    }
}

// MARK: - Date Suggestion Model
struct DateSuggestion: Identifiable {
    let id = UUID()
    let text: String
    let date: Date
}

#Preview {
    DatePickerSheet(
        selectedDate: .constant(Date()),
        onDismiss: {}
    )
}



// MARK: - Priority Picker Sheet
struct PriorityPickerSheet: View {
    @Binding var selectedPriority: TaskItem.Priority
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ForEach(TaskItem.Priority.allCases, id: \.self) { priority in
                    Button(action: {
                        selectedPriority = priority
                        onDismiss()
                    }) {
                        HStack {
                            Image(systemName: "flag.fill")
                                .foregroundColor(priority.color)
                            
                            Text(priority.rawValue)
                                .font(.dmsans(size: 16))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if selectedPriority == priority {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Priority")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDismiss()
                    }
                    .font(.dmsansBold())
                }
            }
        }
    }
}

// MARK: - Reminder Picker Sheet
struct ReminderPickerSheet: View {
    @Binding var reminderTime: Date
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss()
                    }
                    .font(.dmsans())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onDismiss()
                    }
                    .font(.dmsansBold())
                }
            }
        }
    }
}

#Preview {
    CreateTaskSheet(viewModel: InboxViewModel())
}
