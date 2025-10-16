//
//  ViewStyleButton.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import SwiftUI

struct ViewStyleButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.blue.opacity(0.2) : Color(.systemBackground))
                        .frame(height: 70)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(isSelected ? .blue : .secondary)
                }
                
                Text(title)
                    .font(.dmsans(size: 14))
                    .foregroundColor(isSelected ? .blue : .primary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
