//
//  ContentView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 14/10/2025.
//

import SwiftUI

struct MainView: View {
    @StateObject private var authManager = AuthenticationManager()
    @State private var selectedTab = 0
    
    var body: some View {
            TabView(selection: $selectedTab) {
                // Inbox Tab
                InboxView()
                    .tabItem {
                        Label("Inbox", systemImage: selectedTab == 0 ? "tray.fill" : "tray")
                    }
                    .tag(0)
                
                // Today Tab
                TodayView()
                    .tabItem {
                        Label("Today", systemImage: selectedTab == 1 ? "calendar.circle.fill" : "calendar.circle")
                    }
                    .tag(1)
                
                // Upcoming Tab
                UpcomingView()
                    .tabItem {
                        Label("Upcoming", systemImage: selectedTab == 2 ? "clock.fill" : "clock")
                    }
                    .tag(2)
                
                // Settings Tab
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                    }
                    .tag(3)
            }
            .accentColor(.blue)
            .onAppear {
                // Customize tab bar appearance
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor.systemBackground
                
                // Apply DMSans font to tab bar items
                if let customFont = UIFont(name: "DMSans-Regular", size: 10) {
                    let normalAttributes: [NSAttributedString.Key: Any] = [
                        .font: customFont,
                        .foregroundColor: UIColor.systemGray
                    ]
                    let selectedAttributes: [NSAttributedString.Key: Any] = [
                        .font: customFont,
                        .foregroundColor: UIColor.systemBlue
                    ]
                    
                    appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
                    appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
                    appearance.inlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
                    appearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
                    appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
                    appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
                }
                
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }

    private func logout() {
        authManager.signOut()
        print("User logged out")
    }
}

#Preview {
    MainView()
}
