//
//  DateSuggestion.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 21/10/2025.
//

import Foundation


// MARK: - Date Suggestion Model
struct DateSuggestion: Identifiable {
    let id = UUID()
    let text: String
    let date: Date
}
