//
//  UndoToastView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 23/10/2025.
//

import SwiftUI

struct UndoToastView: View {
    let message: String
    @Binding var triggerDismiss: Bool
    let onUndo: () -> Void
    let onDismiss: () -> Void
    
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "calendar.badge.checkmark")
                .font(.system(size: 18))
                .foregroundColor(.white)
            
            Text(message)
                .font(.dmsans(size: 15))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                dismissWithAnimation {
                    onUndo()
                }
            }) {
                Text("Undo")
                    .font(.dmsansBold(size: 15))
                    .foregroundColor(.white)
            }
            
            Button(action: {
                dismissWithAnimation {
                    onDismiss()
                }
            }) {
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
        .offset(x: isVisible ? 0 : -400, y: isVisible ? 0 : 100)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isVisible = true
            }
        }
        .onChange(of: triggerDismiss) { shouldDismiss in
            if shouldDismiss {
                dismissWithAnimation {
                    onDismiss()
                }
            }
        }
    }
    
    private func dismissWithAnimation(completion: @escaping () -> Void) {
        // Animate out with same spring as entry
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isVisible = false
        }
        // Wait for animation to complete before calling completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion()
        }
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        VStack {
            Spacer()
            UndoToastView(
                message: "Scheduled for Tomorrow",
                triggerDismiss: .constant(false),
                onUndo: {},
                onDismiss: {}
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}
