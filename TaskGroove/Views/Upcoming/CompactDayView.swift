//
//  CompactDayView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

import SwiftUI

struct CompactDayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let action: () -> Void
    
    private var dateFormatter: DateFormatter {
        var formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        var formatter = DateFormatter()
        formatter.dateFormat = "E"
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
        }
            return .clear
    }
    
    var body: some View {
       Button(action: action) {
           VStack(spacing: 8) {
               Text(String(dayFormatter.string(from: date).prefix(1)))
                   .font(.dmsans(weight: .medium, size: 12))
                   .foregroundStyle(isSelected ? .blue : .gray)
               
               Text(dateFormatter.string(from: date))
                   .font(.dmsans(weight: isToday ? .bold : .medium, size: 16))
                   .foregroundStyle(textColor)
                   .frame(width: 32, height: 32)
                   .background(backgroundColor)
                   .clipShape(Circle())
           }
           .frame(width: 44)
        }
       .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    HStack(spacing: 12) {
        // Today and selected
        CompactDayView(
            date: Date(),
            isSelected: true,
            isToday: true,
            action: {}
        )
        
        // Today but not selected
        CompactDayView(
            date: Date(),
            isSelected: false,
            isToday: true,
            action: {}
        )
        
        // Selected but not today
        CompactDayView(
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            isSelected: true,
            isToday: false,
            action: {}
        )
        
        // Normal day
        CompactDayView(
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            isSelected: false,
            isToday: false,
            action: {}
        )
    }
    .padding()
    .previewLayout(.sizeThatFits)
}
