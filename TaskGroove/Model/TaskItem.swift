//
//  TaskItem.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import Foundation
import SwiftUI

struct TaskItem: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var description: String
    var priority: Priority
    var isCompleted: Bool
    var dueDate: Date?
    var reminder: Date?
    var labels: [String] = []
    var location: String?
    
    // Add initializer with default UUID
    init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        priority: Priority = .none,
        isCompleted: Bool = false,
        dueDate: Date? = nil,
        reminder: Date? = nil,
        labels: [String] = [],
        location: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.priority = priority
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.reminder = reminder
        self.labels = labels
        self.location = location
    }
    
    enum Priority: String, CaseIterable, Codable {
        case high = "High"
        case medium = "Medium"
        case low = "Low"
        case none = "None"
        
        var color: Color {
            switch self {
            case .high: return .red
            case .medium: return .orange
            case .low: return .blue
            case .none: return .gray
            }
        }
    }
}
