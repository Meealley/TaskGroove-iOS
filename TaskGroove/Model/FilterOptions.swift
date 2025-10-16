//
//  FilterOptions.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import Foundation


enum FilterOptions: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case tomorrow = "Tomorrow"
    case thisWeek = "This Week"
    case nextWeek = "Next Week"
    case thisMonth = "This Month"
    case nextMonth = "Next Month"
    case noDate = "No Date"
}
