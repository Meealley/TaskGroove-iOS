//
//  LoginView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 15/10/2025.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @StateObject private var authManager = AuthenticationManager()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var showError = false
    @State private var showResetAlert = false
    @State private var resetAlertmessage = ""
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 27){
                    Spacer()
                        .frame(height: 20)
                    
                    // Logo
                    Image(systemName: "person.crop.circle.dashed.circle")
                        .font(.system(size: 60))
                    
                    Text("Welcome Back")
                        .font(.dmsansBold(size: 28))
                    Text("Please log in to continue")
                        .font(.dmsans())
                        .foregroundStyle(.secondary)
                    
                    // Email Field
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("Email")
                            .font(.dmsans(size: 15))
                            .foregroundStyle(.secondary)
                        TextField("Enter your email", text: $email)
                            .font(.dmsans(size: 15))
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .frame(maxWidth: .infinity)
                            .frame(height: 14)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 10)
                    
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Password")
                            .font(.dmsans(size: 15))
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            if showPassword {
                                TextField("Enter your password", text: $password)
                                    .font(.dmsans(size: 15))
                                    .textInputAutocapitalization(.never)
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
                    
                    // MARK: - Forgot Password
                    
                    HStack {
                        Spacer()
                        Button {
                            print("Forgot Password")
                        } label: {
                            Text("Forgot Password?")
                                .font(.dmsans(size: 14))
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    // MARK: - Login Button
                    
                    Button {
                        Task {
                            await login()
                        }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                .frame(maxWidth: .infinity)
                                .frame(height: 14)
                                .padding()
                        } else {
                            Text("Login")
                                .font(.dmsans())
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 14)
                                .padding()
                                .background(
                                    Color.black
                                )
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .disabled(isLoading || email.isEmpty || password.isEmpty)
                                .opacity((isLoading || email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                            
                        }
                    }
                    .padding(.horizontal, 12)
                    
                    
                     // MARK: - Sign Up Navigation Link
                    HStack {
                        Text("Don't have an account?")
                            .font(.dmsans(size: 13))
                            .foregroundStyle(.secondary)
                        
                        NavigationLink {
                            SignUpView(isLoggedIn: $isLoggedIn)
                        } label: {
                            Text("Sign Up")
                                .font(.dmsans(size: 13))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.bottom, 20)
                    
                }
            }
            
            // Dismiss keyboard when tapping outside
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
        .customAlert(isPresented: $showError, title: "Login Error", message: authManager.errorMessage, buttons: [
            CustomAlertButton(title: "OK", role: .cancel, action: {})
        ])
    }
     
    // Login
    private func login() async {
        isLoading = true
        showError = false
        
        do {
            try await authManager.signIn(email: email, password: password)
        } catch {
            showError = true
            isLoading = false
        }
    }
    
    // function to dismiss keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
