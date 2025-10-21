//
//  FocusTask.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 21/10/2025.
//

import Foundation
import SwiftUI

struct FocusTask: Identifiable {
    var id: UUID = UUID()
    var title: String
    let priority: Priority
    let estimatedTime: String
//    var isCompleted: Bool = false
    
    enum Priority {
        case high, medium, low
        
        var color: Color {
            switch self {
            case .high:
                return .red
            case .medium:
                return .yellow
            case .low:
                return .green
            }
        }
        
        var label: String {
            switch self {
            case .high:
                return "High"
            case .medium:
                return "Medium"
            case .low:
                return "Low"
            }
        }
    }
}
