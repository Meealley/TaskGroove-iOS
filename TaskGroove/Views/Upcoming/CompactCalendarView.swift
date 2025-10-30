

//
//  CompactCalendarView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

import SwiftUI

struct CompactCalendarView: View {
    @Binding var currentMonth: Date
    @Binding var selectedDate: Date
    @Binding var currentVisibleDate: Date
    @State private var scrollOffset: CGFloat = 0
    @ObservedObject var viewModel: InboxViewModel
    
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
    
    private func  hasTaskOn(_ date: Date) -> Bool {
        viewModel.hasTasksOn(date: date)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(allDates, id: \.self) { date in
                            CompactDayView(
                                date: date,
                                isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                                isToday: Calendar.current.isDateInToday(date),
                                hasTasks: hasTaskOn(date)
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedDate = date
                                }
                            }
                            .id(date)
                            .background(
                                GeometryReader { itemGeometry in
                                    let midX = itemGeometry.frame(in: .named("compactScroll")).midX
                                    Color.clear
                                        .preference(
                                            key: CompactVisibleDatePreferenceKey.self,
                                            value: [CompactVisibleDateData(
                                                date: date,
                                                midX: midX
                                            )]
                                        )
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .coordinateSpace(name: "compactScroll")
                }
                .onPreferenceChange(CompactVisibleDatePreferenceKey.self) { values in
                    // Find the date closest to center of screen
                    let screenCenter = geometry.size.width / 2
                    if let centerDate = values
                        .filter({ abs($0.midX - screenCenter) < 100 })
                        .sorted(by: { abs($0.midX - screenCenter) < abs($1.midX - screenCenter) })
                        .first?.date {
                        
                        // Update current month if changed
                        let calendar = Calendar.current
                        if !calendar.isDate(currentMonth, equalTo: centerDate, toGranularity: .month) {
                            currentMonth = centerDate
                        }
                    }
                }
                .onAppear {
                    // Scroll to today on appear
                    let today = Calendar.current.startOfDay(for: Date())
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        proxy.scrollTo(today, anchor: .center)
                    }
                }
                .onChange(of: currentVisibleDate) { _, newDate in
                    // Scroll to the selected date
                    withAnimation {
                        proxy.scrollTo(newDate, anchor: .center)
                    }
                }
            }
        }
        .frame(height: 70)
    }
}

// Preference key for tracking center date in compact view
struct CompactVisibleDateData: Equatable {
    let date: Date
    let midX: CGFloat
}

struct CompactVisibleDatePreferenceKey: PreferenceKey {
    static var defaultValue: [CompactVisibleDateData] = []
    
    static func reduce(value: inout [CompactVisibleDateData], nextValue: () -> [CompactVisibleDateData]) {
        value.append(contentsOf: nextValue())
    }
}


#Preview {
    @State var currentMonth = Date()
    @State var selectedDate = Date()
    @State var currentVisibleDate = Date()
    
    return CompactCalendarView(
        currentMonth: $currentMonth,
        selectedDate: $selectedDate,
        currentVisibleDate: $currentVisibleDate,
        viewModel: InboxViewModel()
    )
    
    .frame(height: 100)
}
