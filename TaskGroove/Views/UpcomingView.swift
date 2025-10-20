import SwiftUI

struct UpcomingView: View {
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var isCalendarExpanded = true
    @State private var scrollViewOffset: CGFloat = 0
    @State private var currentVisibleDate = Date()
    @State private var tasks: [DayTask] = [
        DayTask(date: Date(), title: "Get books", category: "Books", categoryColor: .blue, subtasks: 2, isCompleted: false),
        DayTask(date: Date().addingTimeInterval(86400), title: "Team Meeting", category: "Work", categoryColor: .purple, subtasks: 0, isCompleted: false),
        DayTask(date: Date().addingTimeInterval(86400 * 3), title: "Project Deadline", category: "Projects", categoryColor: .red, subtasks: 5, isCompleted: false)
    ]
    
    // Generate dates for the next 365 days
    private var allDates: [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        for dayOffset in 0..<365 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: calendar.startOfDay(for: Date())) {
                dates.append(date)
            }
        }
        return dates
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
//                Color.black.ignoresSafeArea()
                
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
                    if isCalendarExpanded {
                        CalendarGridView(
                            currentMonth: $currentMonth,
                            selectedDate: $selectedDate,
                            currentVisibleDate: $currentVisibleDate
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 20)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                    } else {
                        CompactCalendarView(
                            currentMonth: $currentMonth,
                            selectedDate: $selectedDate,
                            currentVisibleDate: $currentVisibleDate
                        )
                        .padding(.vertical, 15)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                    }
                    
                    // Divider
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .padding(.horizontal)
                    
                    // Daily Tasks List with Scroll Detection
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(allDates, id: \.self) { date in
                                    DailySection(
                                        date: date,
                                        tasks: tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
                                    )
                                    .id(date)
                                    .padding(.horizontal)
                                    .padding(.top, 20)
                                    .background(
                                        GeometryReader { geometry in
                                            Color.clear
                                                .preference(
                                                    key: ScrollOffsetPreferenceKey.self,
                                                    value: [ScrollOffsetData(date: date, offset: geometry.frame(in: .named("scroll")).minY)]
                                                )
                                        }
                                    )
                                }
                            }
                            .coordinateSpace(name: "scroll")
                            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { values in
                                // Find the date that's currently at the top of the view
                                if let topDate = values
                                    .filter({ $0.offset > -100 && $0.offset < 200 })
                                    .sorted(by: { abs($0.offset) < abs($1.offset) })
                                    .first?.date {
                                    
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        currentVisibleDate = topDate
                                        
                                        // Update current month if needed
                                        let calendar = Calendar.current
                                        if !calendar.isDate(currentMonth, equalTo: topDate, toGranularity: .month) {
                                            currentMonth = topDate
                                        }
                                        
                                        // Update selected date
                                        selectedDate = topDate
                                    }
                                }
                            }
                        }
                        .onChange(of: selectedDate) { newDate in
                            // Scroll to selected date when calendar date is tapped
                            withAnimation {
                                proxy.scrollTo(newDate, anchor: .top)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Upcoming")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
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
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct MonthYearHeader: View {
    @Binding var currentMonth: Date
    @Binding var isExpanded: Bool
    let currentVisibleDate: Date
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(monthYearString)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.orange)
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 14))
                    .foregroundColor(.orange)
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CalendarGridView: View {
    @Binding var currentMonth: Date
    @Binding var selectedDate: Date
    @Binding var currentVisibleDate: Date
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekDays = ["S", "M", "T", "W", "T", "F", "S"]
    
    private var monthDates: [CalendarDate] {
        generateMonthDates()
    }
    
    var body: some View {
        VStack(spacing: 15) {
            // Week days header
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar grid
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(monthDates) { calendarDate in
                    CalendarDayView(
                        calendarDate: calendarDate,
                        isSelected: isSameDay(calendarDate.date, currentVisibleDate),
                        isToday: isSameDay(calendarDate.date, Date())
                    ) {
                        selectedDate = calendarDate.date
                    }
                }
            }
        }
    }
    
    private func generateMonthDates() -> [CalendarDate] {
        var dates: [CalendarDate] = []
        let calendar = Calendar.current
        
        guard let monthRange = calendar.range(of: .day, in: .month, for: currentMonth),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)) else {
            return dates
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth) - 1
        
        // Add empty days before month starts
        for _ in 0..<firstWeekday {
            dates.append(CalendarDate(date: Date(), day: "", isCurrentMonth: false))
        }
        
        // Add days of the month
        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                dates.append(CalendarDate(date: date, day: "\(day)", isCurrentMonth: true))
            }
        }
        
        // Add days from next month to complete the grid
        let remainingDays = 42 - dates.count
        if let lastDayOfMonth = calendar.date(byAdding: .day, value: monthRange.count - 1, to: firstOfMonth) {
            for i in 1...remainingDays {
                if let nextMonthDate = calendar.date(byAdding: .day, value: i, to: lastDayOfMonth) {
                    let day = calendar.component(.day, from: nextMonthDate)
                    dates.append(CalendarDate(date: nextMonthDate, day: "\(day)", isCurrentMonth: false))
                }
            }
        }
        
        return dates
    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

struct CalendarDate: Identifiable {
    let id = UUID()
    let date: Date
    let day: String
    let isCurrentMonth: Bool
}

struct CalendarDayView: View {
    let calendarDate: CalendarDate
    let isSelected: Bool
    let isToday: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(calendarDate.day)
                .font(.system(size: 16, weight: isToday ? .semibold : .regular))
                .foregroundColor(textColor)
                .frame(width: 36, height: 36)
                .background(backgroundColor)
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if isToday && isSelected {
            return .white
        } else if isToday {
            return .orange
        } else if isSelected && calendarDate.isCurrentMonth {
            return .white
        } else if !calendarDate.isCurrentMonth {
            return .gray.opacity(0.5)
        } else {
            return .white.opacity(0.9)
        }
    }
    
    private var backgroundColor: Color {
        if isToday && isSelected {
            return .orange
        } else if isSelected && calendarDate.isCurrentMonth {
            return .orange.opacity(0.7)
        }
        return .clear
    }
}

// Compact Calendar View (Horizontal Scrollable)
struct CompactCalendarView: View {
    @Binding var currentMonth: Date
    @Binding var selectedDate: Date
    @Binding var currentVisibleDate: Date
    
    @State private var scrollViewProxy: ScrollViewProxy?
    
    private var weekDays: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.shortWeekdaySymbols.map { String($0.prefix(1)) }
    }
    
    private var monthDates: [Date] {
        generateCurrentWeekAndSurrounding()
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(monthDates, id: \.self) { date in
                        CompactDayView(
                            date: date,
                            isSelected: isSameDay(date, currentVisibleDate),
                            isToday: isSameDay(date, Date())
                        ) {
                            selectedDate = date
                            currentVisibleDate = date
                        }
                        .id(date)
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                scrollViewProxy = proxy
                // Scroll to current visible date on appear
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        proxy.scrollTo(currentVisibleDate, anchor: .center)
                    }
                }
            }
            .onChange(of: currentVisibleDate) { newDate in
                withAnimation {
                    proxy.scrollTo(newDate, anchor: .center)
                }
            }
        }
    }
    
    private func generateCurrentWeekAndSurrounding() -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        
        // Generate 60 days before and after current date
        for dayOffset in -60...60 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: currentVisibleDate) {
                dates.append(calendar.startOfDay(for: date))
            }
        }
        
        return dates
    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

struct CompactDayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let action: () -> Void
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(String(dayFormatter.string(from: date).prefix(1)))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)
                
                Text(dateFormatter.string(from: date))
                    .font(.system(size: 16, weight: isToday ? .bold : .medium))
                    .foregroundColor(textColor)
                    .frame(width: 32, height: 32)
                    .background(backgroundColor)
                    .clipShape(Circle())
            }
            .frame(width: 44)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if isToday && isSelected {
            return .white
        } else if isToday {
            return .orange
        } else if isSelected {
            return .white
        } else {
            return .white.opacity(0.9)
        }
    }
    
    private var backgroundColor: Color {
        if isToday && isSelected {
            return .orange
        } else if isSelected {
            return .orange.opacity(0.7)
        }
        return .clear
    }
}

struct DailySection: View {
    let date: Date
    let tasks: [DayTask]
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }
    
    private func dateSection(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "\(dateFormatter.string(from: date)) · Today · \(dayFormatter.string(from: date))"
        } else if calendar.isDateInTomorrow(date) {
            return "\(dateFormatter.string(from: date)) · Tomorrow · \(dayFormatter.string(from: date))"
        } else {
            return "\(dateFormatter.string(from: date)) · \(dayFormatter.string(from: date))"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(dateSection(for: date))
                .font(.dmsans(weight: .semibold, size: 18))
                .foregroundColor(.white.opacity(0.7))
            
            if tasks.isEmpty {
                // Empty state for days without tasks
                Text("No tasks scheduled")
                    .font(.dmsans(size: 14))
                    .foregroundColor(.gray.opacity(0.5))
                    .padding(.leading, 29)
            } else {
                ForEach(tasks) { task in
                    TaskRowView(task: task)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DayTask: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let category: String
    let categoryColor: Color
    let subtasks: Int
    var isCompleted: Bool
}

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
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .strikethrough(isCompleted, color: .gray)
                
                HStack(spacing: 5) {
                    Text(task.category)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    if task.subtasks > 0 {
                        HStack(spacing: 3) {
                            Image(systemName: "text.badge.checkmark")
                                .font(.system(size: 12))
                            Text("\(task.subtasks)")
                                .font(.system(size: 14))
                        }
                        .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("Inbox / \(task.category)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.6))
                }
            }
        }
        .padding(.leading, 5)
    }
}

// Preference Key for Scroll Detection
struct ScrollOffsetData: Equatable {
    let date: Date
    let offset: CGFloat
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [ScrollOffsetData] = []
    
    static func reduce(value: inout [ScrollOffsetData], nextValue: () -> [ScrollOffsetData]) {
        value.append(contentsOf: nextValue())
    }
}

// Floating Action Button
struct FloatingAddButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(Color.orange)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                )
        }
    }
}

// Main container with FAB
struct UpcomingContainerView: View {
    var body: some View {
        ZStack {
            UpcomingView()
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingAddButton {
                        print("Add new task")
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

#Preview {
    UpcomingContainerView()
}
