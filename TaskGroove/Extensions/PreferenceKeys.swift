//
//  PreferenceKeys.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

import SwiftUI

// MARK: - Scroll Offset Data Models
struct ScrollOffsetData: Equatable {
    let date: Date
    let offset: CGFloat
}

struct MonthScrollOffsetData: Equatable {
    let month: Date
    let offset: CGFloat
}

struct CompactScrollOffsetData: Equatable {
    let date: Date
    let offset: CGFloat
}

// MARK: - Preference Keys
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [ScrollOffsetData] = []
    
    static func reduce(value: inout [ScrollOffsetData], nextValue: () -> [ScrollOffsetData]) {
        value.append(contentsOf: nextValue())
    }
}

struct MonthScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [MonthScrollOffsetData] = []
    
    static func reduce(value: inout [MonthScrollOffsetData], nextValue: () -> [MonthScrollOffsetData]) {
        value.append(contentsOf: nextValue())
    }
}

struct CompactScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [CompactScrollOffsetData] = []
    
    static func reduce(value: inout [CompactScrollOffsetData], nextValue: () -> [CompactScrollOffsetData]) {
        value.append(contentsOf: nextValue())
    }
}
