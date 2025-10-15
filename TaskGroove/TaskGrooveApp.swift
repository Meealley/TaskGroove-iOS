//
//  TaskGrooveApp.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 14/10/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct TaskGrooveApp: App {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var isLoggedIn = false
    
    init() {
        FirebaseApp.configure()
        setupNavigationBarAppearance()
        setupToolbarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !hasCompletedOnboarding {
                    OnboardingView(showOnboarding: $hasCompletedOnboarding)
                } else if !isLoggedIn{
                    NavigationStack {
                        LoginView(isLoggedIn: $isLoggedIn)
                    }
                    
                } else {
                    MainView()
                }
            }
            .onAppear {
                checkAuthState()
            }
            .onChange(of: isLoggedIn) { _, newValue in
                UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
            }
        }
    }
    
    
    private func checkAuthState() {
        // Check the current auth state
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
        
        // Listen for auth state changes (incl. logout)
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                withAnimation {
                    isLoggedIn = user != nil
                }
            }
        }
        
    }
    
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        if let customFont = UIFont(name: "DMSans-Regular", size: 17) {
            appearance.titleTextAttributes = [
                .font: customFont,
                .foregroundColor: UIColor.label
            ]
        }
        
        if let largeTitleFont = UIFont(name: "DMSans-Bold", size: 34) {
            appearance.largeTitleTextAttributes = [
                .font: largeTitleFont,
                .foregroundColor: UIColor.label
            ]
        }
        
        if let backButtonFont = UIFont(name: "DMSans-Regular", size: 17) {
            appearance.backButtonAppearance.normal.titleTextAttributes = [
                .font: backButtonFont,
                .foregroundColor: UIColor.label
            ]
        }
        
        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
    }
    
    private func setupToolbarAppearance() {
        if let customFont = UIFont(name: "DMSans-Regular", size: 17) {
            UIBarButtonItem.appearance().setTitleTextAttributes([
                .font: customFont,
                .foregroundColor: UIColor.label
            ], for: .normal)
            
            UIBarButtonItem.appearance().setTitleTextAttributes([
                .font: customFont,
                .foregroundColor: UIColor.systemGray
            ], for: .disabled)
        }
    }

}
