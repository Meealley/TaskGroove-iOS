//
//  TaskItem.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import Foundation
import SwiftUI

struct TaskItem: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var priority: Priority
    var isCompleted: Bool
    var dueDate: Date?
    var reminder: Date?
    var labels: [String] = []
    var location: String?
    
    enum Priority: String, CaseIterable {
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
