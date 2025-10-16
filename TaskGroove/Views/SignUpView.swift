//
//  SignUpView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 15/10/2025.
//

import SwiftUI

struct SignUpView: View {
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthenticationManager()
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var isLoading = false
    @State private var showError = false

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 25) {
                    Text("Create Account")
                        .font(.dmsansBold())
                    
                    Text("Sign up to get started")
                        .font(.dmsans())
                        .foregroundStyle(.secondary)
                    
                    // MARK: - Name Field
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Full Name")
                            .font(.dmsans(size: 15))
                            .foregroundStyle(.secondary)
                        
                        TextField("Enter your full name", text: $name)
                            .font(.dmsans(size: 15))
                            .textInputAutocapitalization(.words)
                            .frame(maxWidth: .infinity)
                            .frame(height: 14)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 10)
                    
                    // MARK: - Email Field
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email")
                            .font(.dmsans(size: 15))
                            .foregroundStyle(.secondary)
                        
                        TextField("Enter your email", text: $email)
                            .font(.dmsans(size: 15))
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .frame(maxWidth: .infinity)
                            .frame(height: 14)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )

                    }
                    .padding(.horizontal,10)
                        
                    // MARK: - Password Field
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("Password")
                            .font(.dmsans(size: 15))
                            .foregroundStyle(.secondary)
                        
                        HStack{
                            if showPassword {
                                TextField("Enter your password", text: $password)
                                    .font(.dmsans(size: 15))
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            } else {
                                SecureField("Enter your password", text: $password)
                                    .font(.dmsans(size: 15))
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundStyle(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 14)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 10)
                    
                    // MARK: - Confirm password Field
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Confirm Password")
                            .font(.dmsans(size: 15))
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            if showConfirmPassword {
                                TextField("Confirm your password", text: $confirmPassword)
                                    .font(.dmsans(size: 15))
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            } else {
                                SecureField("Confirm your password", text: $confirmPassword)
                                    .font(.dmsans(size: 15))
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            
                            Button {
                                showConfirmPassword.toggle()
                            } label: {
                                Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 14)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(passwordsMatch ? Color.gray.opacity(0.3) : Color.red.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 10)
                    
                    // Password requirements
                    if !password.isEmpty {
                        VStack(alignment: .leading, spacing: 5) {
                            PasswordRequirement(text: "At least 6 characters", isMet: password.count >= 6)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Error Message
                    if showError {
                        Text(authManager.errorMessage)
                            .font(.dmsans(size: 13))
                            .foregroundStyle(.red)
                            .padding(.horizontal, 20)
                    }
                    
                    // Signup Button
                    Button {
                        Task {
                            await signUp()
                        }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .frame(height: 14)
                                .padding()
                        } else {
                            Text("Sign Up")
                                .font(.dmsans())
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 14)
                                .padding()
                            
                        }
                    }
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .disabled(!isFormValid || isLoading)
                    .opacity((!isFormValid || isLoading) ? 0.6 : 1.0)
                    .padding(.horizontal, 10)
                    
                    
                    // MARK: - Social Sign Up Button
                    SocialSignInButtons(authManager: authManager, showError: $showError)
                    
                    // MARK: -  Login Link
                    HStack {
                        Text("Already have an account?")
                            .font(.dmsans(size:13))
                            .foregroundStyle(.secondary)
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Log In")
                                .font(.dmsans(size: 13))
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.bottom, 30)
                    
                }
                
                
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .onChange(of: authManager.isAuthenticated) { _, newValue in
            if newValue {
                withAnimation {
                    isLoggedIn = true
                }
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
            }
        }
    }
    
    // MARK: - Computed Properties
    private var passwordsMatch: Bool {
        confirmPassword.isEmpty || password == confirmPassword
    }
    
    private var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password.count >= 6 &&
        password == confirmPassword
    }
    
    // MARK: - Sign Up
    private func signUp() async {
        guard isFormValid else {
            authManager.errorMessage = "Please fill in all fields correctly"
            showError = true
            return
        }
        
        isLoading = true
        showError = false
        
        do {
            try await authManager.signUp(email: email, password: password)
            // You can save the name to Firestore here if needed
        } catch {
            showError = true
            isLoading = false
        }
    }
    
    // MARK: - Helper Functions
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    

}

// MARK: - Password Requirement Component
struct PasswordRequirement: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isMet ? .green : .gray)
                .font(.system(size: 14))
            
            Text(text)
                .font(.dmsans(size: 13))
                .foregroundColor(isMet ? .green : .secondary)
        }
    }
}



#Preview {
    SignUpView(isLoggedIn: .constant(false))
}
