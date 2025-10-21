//
//  HomeHeaderComponents.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 21/10/2025.
//

import SwiftUI

// MARK: - Welcome Header
struct WelcomeHeader: View {
    let userName: String
    let dayStreak: Int
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome back, ")
                .font(.dmsans(size: 16))
                .foregroundStyle(.secondary)
            
            HStack {
                Text(userName)
                    .font(.dmsansBold(size: 28))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                StreakBadge(dayStreak: dayStreak)
            }
            
        
        }
    }
}


// MARK: - Streak Badge
struct StreakBadge: View {
    let dayStreak: Int
    
    var body: some View {
        HStack(spacing: 6) {
            Text("Day \(dayStreak)")
                .font(.dmsans(weight: .medium, size: 16))
            Text("🔥")
                .font(.system(size: 18))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.primary.opacity(0.1))
        )
    }
}

#Preview {
    WelcomeHeader(
        userName: "Oyewale", dayStreak: 2
    )
    .padding()
}
