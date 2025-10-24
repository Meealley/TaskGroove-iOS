
//
//  UpcomingView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

//
//  UpcomingView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

import SwiftUI

struct UpcomingView: View {
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var isCalendarExpanded = true
    @State private var scrollViewOffset: CGFloat = 0
    @State private var currentVisibleDate = Date()
    @State private var tasks: [DayTask] = [
        DayTask(date: Date(), title: "Get books", description: "", category: "Books", categoryColor: .blue, subtasks: 2, isCompleted: false),
        DayTask(date: Date().addingTimeInterval(86400), title: "Team Meeting", description: "get status from SEG", category: "Work", categoryColor: .purple, subtasks: 0, isCompleted: false),
        DayTask(date: Date().addingTimeInterval(86400 * 3), title: "Project Deadline", description: "You need to fit this in!", category: "Projects", categoryColor: .red, subtasks: 5, isCompleted: false)
    ]
    
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
                                currentVisibleDate: $currentVisibleDate
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 20)
                        } else {
                            CompactCalendarView(
                                currentMonth: $currentMonth,
                                selectedDate: $selectedDate,
                                currentVisibleDate: $currentVisibleDate
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
                                    DailySection(
                                        date: date,
                                        tasks: tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
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
                                
                                // DON'T update selectedDate here - only update it when user taps calendar
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
        }
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
    UpcomingView()
}
