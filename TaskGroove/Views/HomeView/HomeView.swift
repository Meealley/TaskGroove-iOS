//
//  HomeView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 21/10/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var userName = "Oyewale Favour"
    @State private var dayStreak = 1
    @State private var navigateToInbox = false
    @State private var navigateToProjects = false
    @State private var navigateToGoals = false
    @State private var navigateToAnalytics = false
    
    
    var body: some View {
       NavigationStack {
           ZStack {
               Color(UIColor.systemGray6)
                   .ignoresSafeArea()
               
               VStack(spacing: 0) {
                   ScrollView {
                       VStack(spacing: 25) {
                           // Welcome Header
                           WelcomeHeader(userName: userName, dayStreak: dayStreak)
                               .padding(.horizontal)
                               .padding(.top, 20)
                           
                           // ProgressCard
                           HomeProgressCard(viewModel: viewModel)
                               .padding(.horizontal, 10)
                           
                           // Menu List
                           HomeMenuComponents(viewModel: viewModel, navigateToInbox: $navigateToInbox, navigateToProjects: $navigateToProjects, navigateToGoals: $navigateToGoals, navigateToAnalytics: $navigateToAnalytics)
                           
                           // Daily Focus Section
                           DailyFocusSection(viewModel: viewModel)
                               .padding(.horizontal, 15)
                           
                           Spacer(minLength: 100)
                               
                       }
                       .padding(.vertical, 15)
                   }
               }
           }
           .navigationBarHidden(true)
           .navigationDestination(isPresented: $navigateToInbox) {
               InboxView()
           }
        }
    }
}

#Preview {
    HomeView()
}
