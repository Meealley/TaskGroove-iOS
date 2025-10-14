//
//  TaskGrooveApp.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 14/10/2025.
//

import SwiftUI

@main
struct TaskGrooveApp: App {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    init() {
        setupNavigationBarAppearance()
        setupToolbarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !hasCompletedOnboarding {
                    OnboardingView(showOnboarding: $hasCompletedOnboarding)
                } else {
                    MainView()
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
