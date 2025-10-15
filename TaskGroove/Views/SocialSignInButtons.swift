//
//  SocialSignInButtons.swift
//  GreetingsApp
//
//  Created by Oyewale Favour on 12/10/2025.
//

import SwiftUI
import AuthenticationServices

struct SocialSignInButtons: View {
    @ObservedObject var authManager: AuthenticationManager
    @Binding var showError: Bool
    @State private var isLoading = false
    @State private var showAppleError = false
    @State private var appleErrorMessage = ""
    @StateObject private var appleSignInCoordinator = AppleSignInCoordinator()
    
    var body: some View {
        VStack(spacing: 15) {
            // Divider with "OR"
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
                
                Text("OR")
                    .font(.dmsans(size: 14))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 10)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
            }
            .padding(.horizontal, 20)
            
            // Google Sign In Button
            Button {
                print("🔵 Google button tapped")
                Task {
                    await signInWithGoogle()
                }
            } label: {
                HStack {
                    Image(systemName: "g.circle.fill")
                        .font(.system(size: 20))
                    
                    Text("Continue with Google")
                        .font(.dmsans(size: 16))
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            .disabled(isLoading)
            .padding(.horizontal, 20)
            
            // Custom Apple Sign In Button
            Button {
                print("🍎 Apple button tapped!")
                Task {
                    await signInWithApple()
                }
            } label: {
                HStack {
                    Image(systemName: "applelogo")
                        .font(.system(size: 20))
                    
                    Text("Continue with Apple")
                        .font(.dmsans(size: 16))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(Color.black)
                .cornerRadius(10)
            }
            .disabled(isLoading)
            .padding(.horizontal, 20)
        }
        .customAlert(
            isPresented: $showAppleError,
            title: "Apple Sign In Error",
            message: appleErrorMessage,
            buttons: [
                CustomAlertButton(title: "OK", role: .cancel, action: {})
            ]
        )
        .onAppear {
            setupAppleSignInHandlers()
        }
    }
    
    // ✅ Fixed with explicit type annotation
    private func setupAppleSignInHandlers() {
        appleSignInCoordinator.onSuccess = { (authorization: ASAuthorization) in
            print("🍎 Coordinator success callback")
            Task {
                await self.handleAppleSignInSuccess(authorization)
            }
        }
        
        appleSignInCoordinator.onError = { (error: Error) in
            print("🍎 Coordinator error callback")
            self.handleAppleSignInError(error)
        }
    }
    
    private func signInWithGoogle() async {
        print("🔵 Google Sign-In started")
        isLoading = true
        showError = false
        
        do {
            try await authManager.signInWithGoogle()
            print("✅ Google sign-in completed successfully")
            isLoading = false
        } catch {
            print("❌ Google sign-in error in UI: \(error)")
            showError = true
            isLoading = false
        }
    }
    
    private func signInWithApple() async {
        print("🍎 signInWithApple started")
        isLoading = true
        showError = false
        
        let nonce = authManager.startSignInWithAppleFlow()
        print("🍎 Nonce generated, calling coordinator")
        
        appleSignInCoordinator.signIn(nonce: nonce)
    }
    
    private func handleAppleSignInSuccess(_ authorization: ASAuthorization) async {
        print("🍎 handleAppleSignInSuccess called")
        do {
            try await authManager.signInWithApple(authorization: authorization)
            print("✅ Apple Sign-In completed successfully")
            isLoading = false
        } catch {
            print("❌ Apple Sign-In Firebase error: \(error)")
            appleErrorMessage = authManager.errorMessage.isEmpty ? error.localizedDescription : authManager.errorMessage
            showAppleError = true
            showError = true
            isLoading = false
        }
    }
    
    private func handleAppleSignInError(_ error: Error) {
        print("❌ handleAppleSignInError called")
        
        if let authError = error as? ASAuthorizationError {
            print("🍎 ASAuthorizationError code: \(authError.code.rawValue)")
            switch authError.code {
            case .canceled:
                print("🍎 User canceled")
                // Don't show error for cancel
                isLoading = false
                return
            case .failed:
                appleErrorMessage = "Authorization failed. Please try again."
            case .invalidResponse:
                appleErrorMessage = "Invalid response from Apple"
            case .notHandled:
                appleErrorMessage = "Sign in request not handled"
            case .unknown:
                appleErrorMessage = "Unknown error occurred"
            @unknown default:
                appleErrorMessage = "Unexpected error occurred"
            }
        } else {
            appleErrorMessage = error.localizedDescription
        }
        
        showAppleError = true
        showError = true
        isLoading = false
    }
}
