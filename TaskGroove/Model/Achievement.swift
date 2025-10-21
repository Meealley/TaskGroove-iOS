//
//  Achievement.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 21/10/2025.
//

import Foundation

struct Achievement: Identifiable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let icon: String
    let date: Date
}
