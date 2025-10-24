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
            Text(dateFormatter.string(from: calendarDate.date))
                .font(.dmsans(weight: isToday ? .bold : .medium, size: 16,))
                .foregroundStyle(textColor)
                .frame(width: 36, height: 36)
                .background(backgroundColor)
                .clipShape(Circle())
                .opacity(calendarDate.isInCurrentMonth ? 1 : 0.3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview {
//    CalendarDayView()
//}

