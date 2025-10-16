//
//  InboxView.swift
//  GreetingsApp
//

import SwiftUI

struct InboxView: View {
    @StateObject private var viewModel = InboxViewModel()
    @StateObject private var authManager = AuthenticationManager()
    @State private var searchText = ""
    @State private var navigationPath = NavigationPath()
    
    private var userName: String {
        if let displayName = authManager.user?.displayName, !displayName.isEmpty {
            return displayName.components(separatedBy: " ").first ?? "User"
        } else if let email = authManager.user?.email {
            return email.components(separatedBy: "@").first?.capitalized ?? "User"
        }
        return "User"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView
                
                ScrollView {
                    VStack(spacing: 20) {
                        Group {
                            switch viewModel.selectedViewStyle {
                            case .list: listView
                            case .board: boardView
                            case .calendar: calendarView
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 80)
                    }
                }
                
                floatingButton
            }
            .navigationTitle("Inbox")
            .navigationBarTitleDisplayMode(.large)
            .toolbar { toolbarItems }
            .sheet(isPresented: $viewModel.showViewSheet) {
                ViewFilterSheet(
                    selectedViewStyle: $viewModel.selectedViewStyle,
                    selectedFilter: $viewModel.selectedFilter,
                    isPresented: $viewModel.showViewSheet
                )
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $viewModel.showTaskSheet) {
                CreateTaskSheet(isPresented: $viewModel.showTaskSheet) { newTask in
                    viewModel.addTask(newTask)
                }
            }
        }
    }
}

// MARK: - Subviews
extension InboxView {
    private var backgroundView: some View {
        LinearGradient(colors: [.blue.opacity(0.05), .purple.opacity(0.05)],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
    
    private var floatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    viewModel.showTaskSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(
                            LinearGradient(colors: [.blue, .purple],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .clipShape(Circle())
                        .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
    
    private var toolbarItems: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showViewSheet = true
                } label: {
                    Image(systemName: "rectangle.stack.fill")
                }
            }
        }
    }
    
    private var listView: some View {
        VStack(spacing: 12) {
            ForEach($viewModel.tasks) { $task in
                TaskListCard(task: $task)
            }
        }
    }
    
    private var boardView: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15),
                            GridItem(.flexible(), spacing: 15)],
                  spacing: 15) {
            ForEach($viewModel.tasks) { $task in
                TaskBoardCard(task: $task)
            }
        }
    }
    
    private var calendarView: some View {
        VStack(spacing: 15) {
            ForEach($viewModel.tasks) { $task in
                TaskCalendarCard(task: $task)
            }
        }
    }
}

#Preview {
    InboxView()
}
