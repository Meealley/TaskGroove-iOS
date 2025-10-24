//
//  DayTask.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

import Foundation
import SwiftUI


struct DayTask: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let description: String
    let category: String
    let categoryColor: Color
    let subtasks: Int
    var isCompleted: Bool
}
