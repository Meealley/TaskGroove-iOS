
//
//  CalendarGridView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

import SwiftUI

struct CalendarGridView: View {
    @Binding var currentMonth: Date
    @Binding var selectedDate: Date
    @Binding var currentVisibleDate: Date
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    // Use full names to ensure unique IDs
    private let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    // Dynamic: Generate 20 months from current month
    private var months: [Date] {
        let calendar = Calendar.current
        var monthsArray: [Date] = []
        
        // Start from current month
        let today = Date()
        let components = calendar.dateComponents([.year, .month], from: today)
        guard let startMonth = calendar.date(from: components) else {
            return []
        }
        
        // Generate 20 months from current month
        for monthOffset in 0..<20 {
            if let month = calendar.date(byAdding: .month, value: monthOffset, to: startMonth) {
                monthsArray.append(month)
            }
        }
        
        return monthsArray
    }
    
    private func monthDates(for month: Date) -> [CalendarDate] {
        generateMonthDates(for: month)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 30) {
                        ForEach(months, id: \.self) { month in
                            VStack(spacing: 15) {
                                // Month header
                                Text(monthYearFormatter.string(from: month))
                                    .font(.dmsansBold(weight: .bold, size: 16))
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 5)
                                
                                // Week days header - use first letter for display
                                HStack {
                                    ForEach(weekDays, id: \.self) { day in
                                        Text(String(day.prefix(1)))
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                
                                // Calendar grid for this month
                                LazyVGrid(columns: columns, spacing: 15) {
                                    ForEach(monthDates(for: month)) { calendarDate in
                                        CalendarDayView(
                                            calendarDate: calendarDate,
                                            isSelected: isSameDay(calendarDate.date, selectedDate),
                                            isToday: isToday(calendarDate.date)
                                        ) {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                selectedDate = calendarDate.date
                                                currentVisibleDate = calendarDate.date
                                            }
                                        }
                                    }
                                }
                            }
                            .id(month)
                            .background(
                                GeometryReader { monthGeometry in
                                    Color.clear
                                        .preference(
                                            key: MonthScrollOffsetPreferenceKey.self,
                                            value: [MonthScrollOffsetData(
                                                month: month,
                                                offset: monthGeometry.frame(in: .named("calendarScroll")).minY
                                            )]
                                        )
                                }
                            )
                        }
                    }
                    .padding(.vertical, 10)
                    .coordinateSpace(name: "calendarScroll")
                    .onPreferenceChange(MonthScrollOffsetPreferenceKey.self) { values in
                        // Find the month closest to the top of the view
                        if let topMonth = values
                            .filter({ $0.offset > -200 && $0.offset < 200 })
                            .sorted(by: { abs($0.offset) < abs($1.offset) })
                            .first?.month {
                            
                            // Update current month if it changed
                            let calendar = Calendar.current
                            if !calendar.isDate(currentMonth, equalTo: topMonth, toGranularity: .month) {
                                DispatchQueue.main.async {
                                    currentMonth = topMonth
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                // Scroll to current month on appear
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month], from: Date())
                if let currentMonthStart = calendar.date(from: components) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        proxy.scrollTo(currentMonthStart, anchor: .top)
                    }
                }
            }
            .onChange(of: selectedDate) { newDate in
                // Scroll to the month when selected date changes
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month], from: newDate)
                if let monthStart = calendar.date(from: components) {
                    withAnimation {
                        proxy.scrollTo(monthStart, anchor: .top)
                    }
                }
            }
        }
        .frame(maxHeight: 400)
    }
    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    private func generateMonthDates(for month: Date) -> [CalendarDate] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // 1 = Sunday, 2 = Monday, etc.
        
        var dates: [CalendarDate] = []
        
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        let monthStart = monthInterval.start
        let monthEnd = monthInterval.end
        
        var currentDate = monthFirstWeek.start
        
        while currentDate < monthEnd {
            let isInCurrentMonth = calendar.isDate(currentDate, equalTo: monthStart, toGranularity: .month)
            dates.append(CalendarDate(date: currentDate, isInCurrentMonth: isInCurrentMonth))
            
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        
        return dates
    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    private func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}


#Preview {
    CalendarGridView(
        currentMonth: .constant(Date()),
        selectedDate: .constant(Date()),
        currentVisibleDate: .constant(Date())
    )
    .padding()
    .previewLayout(.sizeThatFits)
}
