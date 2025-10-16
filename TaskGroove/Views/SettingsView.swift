//
//  SettingsView.swift
//  GreetingsApp
//
//  Created by Oyewale Favour on 12/10/2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var authManager = AuthenticationManager()
    @State private var showLogoutAlert = false
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    
    private var userName: String {
        if let displayName = authManager.user?.displayName, !displayName.isEmpty {
            return displayName
        } else if let email = authManager.user?.email {
            return email.components(separatedBy: "@").first?.capitalized ?? "User"
        }
        return "User"
    }
    
    private var userEmail: String {
        authManager.user?.email ?? "No email"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.05), .purple.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile Card
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                
                                Text(userName.prefix(1).uppercased())
                                    .font(.dmsansBold(size: 32))
                                    .foregroundColor(.white)
                            }
                            
                            Text(userName)
                                .font(.dmsansBold(size: 20))
                            
                            Text(userEmail)
                                .font(.dmsans(size: 14))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.05), radius: 5)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Settings Sections
                        VStack(spacing: 20) {
                            // Account Section
                            SettingsSection(title: "Account") {
                                SettingsRow(icon: "person.fill", title: "Edit Profile", iconColor: .blue) {
                                    print("Edit profile tapped")
                                }
                                
                                SettingsRow(icon: "lock.fill", title: "Change Password", iconColor: .orange) {
                                    print("Change password tapped")
                                }
                            }
                            
                            // Preferences Section
                            SettingsSection(title: "Preferences") {
                                SettingsToggleRow(
                                    icon: "bell.fill",
                                    title: "Notifications",
                                    iconColor: .purple,
                                    isOn: $notificationsEnabled
                                )
                                
                                SettingsToggleRow(
                                    icon: "moon.fill",
                                    title: "Dark Mode",
                                    iconColor: .indigo,
                                    isOn: $darkModeEnabled
                                )
                            }
                            
                            // Support Section
                            SettingsSection(title: "Support") {
                                SettingsRow(icon: "questionmark.circle.fill", title: "Help Center", iconColor: .green) {
                                    print("Help center tapped")
                                }
                                
                                SettingsRow(icon: "envelope.fill", title: "Contact Us", iconColor: .blue) {
                                    print("Contact us tapped")
                                }
                            }
                            
                            // Logout Button
                            Button {
                                showLogoutAlert = true
                            } label: {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Text("Logout")
                                        .font(.dmsans(size: 16))
                                }
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 5)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .customAlert(
                isPresented: $showLogoutAlert,
                title: "Logout",
                message: "Are you sure you want to logout?",
                buttons: [
                    CustomAlertButton(title: "Cancel", role: .cancel, action: {}),
                    CustomAlertButton(title: "Logout", role: .destructive, action: {
                        logout()
                    })
                ]
            )
        }
    }
    
    private func logout() {
        authManager.signOut()
        print("✅ User logged out")
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.dmsans(size: 14))
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
            
            VStack(spacing: 1) {
                content
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5)
            .padding(.horizontal, 20)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.dmsans(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 35, height: 35)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
            }
            
            Text(title)
                .font(.dmsans(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
