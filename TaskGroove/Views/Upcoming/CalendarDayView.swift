//
//  CalendarDayView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

import SwiftUI

struct CalendarDayView: View {
    let calendarDate: CalendarDate
    let isSelected: Bool
    let isToday: Bool
    let hasTasks: Bool
    let action: () -> Void
    
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    private var textColor: Color {
        if isToday && isSelected {
            return .white
        } else if isToday {
            return .blue
        } else if isSelected {
            return .white
        } else {
            return .primary
        }
        
    }
    
    private var backgroundColor: Color {
        if isToday && isSelected {
            return .blue
        } else if isSelected {
            return .blue.opacity(0.7)
        } else {
            return .clear
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(dateFormatter.string(from: calendarDate.date))
                    .font(.dmsans(weight: isToday ? .bold : .medium, size: 16,))
                    .foregroundStyle(textColor)
                    .frame(width: 36, height: 36)
                    .background(backgroundColor)
                    .clipShape(Circle())
                    .opacity(calendarDate.isInCurrentMonth ? 1 : 0.3)
                
                /// Tasks Indicator dot
                if hasTasks && calendarDate.isInCurrentMonth {
                    Circle()
                        .fill(isSelected ? .white : .blue)
                        .frame(width: 4, height: 4)
                } else {
                    Circle()
                        .fill(.clear)
                        .frame(width: 4, height: 4)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!calendarDate.isInCurrentMonth)
    }
}

#Preview {
    HStack(spacing: 12) {
        // Today, selected, with tasks
        CalendarDayView(
            calendarDate: CalendarDate(date: Date(), isInCurrentMonth: true),
            isSelected: true,
            isToday: true,
            hasTasks: true,
            action: {}
        )
        
        // Today, not selected, with tasks
        CalendarDayView(
            calendarDate: CalendarDate(date: Date(), isInCurrentMonth: true),
            isSelected: false,
            isToday: true,
            hasTasks: true,
            action: {}
        )
        
        // Normal day with tasks
        CalendarDayView(
            calendarDate: CalendarDate(date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, isInCurrentMonth: true),
            isSelected: false,
            isToday: false,
            hasTasks: true,
            action: {}
        )
        
        // Normal day without tasks
        CalendarDayView(
            calendarDate: CalendarDate(date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!, isInCurrentMonth: true),
            isSelected: false,
            isToday: false,
            hasTasks: false,
            action: {}
        )
    }
    .padding()
}
