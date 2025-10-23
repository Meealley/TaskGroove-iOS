//
//  UndoToastView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 23/10/2025.
//

import SwiftUI

//
//  UndoToastView.swift
//  TaskGroove
//

//import SwiftUI
//
struct UndoToastView: View {
    let message: String
    let onUndo: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "calendar.badge.checkmark")
                .font(.system(size: 18))
                .foregroundColor(.white)
            
            Text(message)
                .font(.dmsans(size: 15))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: onUndo) {
                Text("Undo")
                    .font(.dmsansBold(size: 15))
                    .foregroundColor(.white)
            }
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.85))
        )
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
    }
}
