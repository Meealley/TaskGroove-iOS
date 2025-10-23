//
//  RescheduleQuickOption.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 23/10/2025.
//

import Foundation


//
//  RescheduleQuickOption.swift
//  TaskGroove

import SwiftUI

enum RescheduleQuickOption: CaseIterable {
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
    
    var color: Color {
        switch self {
        case .today: return .green
        case .tomorrow: return .orange
        case .thisWeekend: return .blue
        case .nextWeek: return .purple
        }
    }
    
    var date: Date {
        let calendar = Calendar.current
        let today = Date()
        
        switch self {
        case .today:
            return today
        case .tomorrow:
            return calendar.date(byAdding: .day, value: 1, to: today) ?? today
        case .thisWeekend:
            let weekday = calendar.component(.weekday, from: today)
            let daysUntilSaturday = (7 - weekday) % 7
            let days = daysUntilSaturday == 0 ? 7 : daysUntilSaturday
            return calendar.date(byAdding: .day, value: days, to: today) ?? today
        case .nextWeek:
            return calendar.date(byAdding: .weekOfYear, value: 1, to: today) ?? today
        }
    }
    
    var dayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

// MARK: - Hashable Conformance
extension RescheduleQuickOption: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
