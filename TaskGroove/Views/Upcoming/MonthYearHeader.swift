//
//  MonthYearHeader.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 24/10/2025.
//

import SwiftUI

struct MonthYearHeader: View {
    @Binding var currentMonth: Date
    @Binding var isExpanded: Bool
    let currentVisibleDate: Date
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(monthYearString)
                    .font(.dmsansBold(size: 24))
                    .foregroundStyle(LinearGradient(
                        colors: [Color(hex: "1e3a5f"), Color(hex: "2c5282")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 14))
                    .foregroundStyle(LinearGradient(
                        colors: [Color(hex: "1e3a5f"), Color(hex: "2c5282")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MonthYearHeader(
        currentMonth: .constant(Date()), isExpanded: .constant(false), currentVisibleDate: Date()
    )
    .padding()
}
