//
//  CalendarExtension.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

import Foundation


extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}
