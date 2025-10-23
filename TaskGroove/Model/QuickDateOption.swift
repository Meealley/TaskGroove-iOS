//
//  QuickDateOption.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 21/10/2025.
//

import Foundation


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
