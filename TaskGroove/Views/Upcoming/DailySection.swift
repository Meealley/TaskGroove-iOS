//
//  DailySection.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//
//

import SwiftUI

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
                .font(.dmsansSemiBold(weight: .semibold, size: 17))
                .foregroundColor(.primary.opacity(0.7))
            
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

