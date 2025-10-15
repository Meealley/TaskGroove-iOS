//
//  CustomAlert.swift
//  GreetingsApp
//
//  Created by Oyewale Favour on 12/10/2025.
//

import SwiftUI

struct CustomAlertButton {
    let title: String
    let role: ButtonRole?
    let action: () -> Void
    
    init(title: String, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.title = title
        self.role = role
        self.action = action
    }
}

struct CustomAlert: View {
    let title: String
    let message: String
    let buttons: [CustomAlertButton]
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    // Dismiss on background tap (optional)
                }
            
            // Alert card
            VStack(spacing: 0) {
                // Title
                Text(title)
                    .font(.dmsans(size: 17))
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                // Message
                Text(message)
                    .font(.dmsans(size: 13))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                Divider()
                
                // Buttons
                if buttons.count == 1 {
                    // Single button
                    alertButton(buttons[0])
                } else if buttons.count == 2 {
                    // Two buttons side by side
                    HStack(spacing: 0) {
                        alertButton(buttons[0])
                        Divider()
                            .frame(width: 1)
                        alertButton(buttons[1])
                    }
                } else {
                    // Multiple buttons stacked
                    VStack(spacing: 0) {
                        ForEach(buttons.indices, id: \.self) { index in
                            if index > 0 {
                                Divider()
                            }
                            alertButton(buttons[index])
                        }
                    }
                }
            }
            .frame(width: 270)
            .frame(height: 130)
            .background(Color(.systemBackground))
            .cornerRadius(14)
            .shadow(radius: 20)
            .padding(.bottom, 120)

        }
        
    }
    
    
    private func alertButton(_ button: CustomAlertButton) -> some View {
        Button {
            button.action()
            isPresented = false
        } label: {
            Text(button.title)
                .font(.dmsans(size: 17))
                .foregroundColor(buttonColor(for: button.role))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
        }
    }
    
    private func buttonColor(for role: ButtonRole?) -> Color {
        switch role {
        case .destructive:
            return .red
        case .cancel:
            return .primary
        default:
            return .blue
        }
    }
}

// MARK: - View Extension for Easy Usage
extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        buttons: [CustomAlertButton]
    ) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                CustomAlert(
                    title: title,
                    message: message,
                    buttons: buttons,
                    isPresented: isPresented
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented.wrappedValue)
    }
}
