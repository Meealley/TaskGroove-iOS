//
//  CalendarDate.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

import Foundation


struct CalendarDate: Identifiable {
    let id = UUID()
    let date: Date
    let isInCurrentMonth: Bool
}
