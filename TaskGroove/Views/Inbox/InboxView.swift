//
//  InboxView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import SwiftUI

struct InboxView: View {
    @StateObject private var viewModel = InboxViewModel()
    @StateObject private var authManager = AuthenticationManager()
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

                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        tasksContent
                            .padding(.horizontal, 20)
                            .padding(.bottom, 80)
                    }
                    .padding(.bottom, 30)
                }
                
                // Floating Action Button
                floatingActionButton
            }
            .navigationTitle("Inbox")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                toolbarContent
            }
            .sheet(isPresented: $viewModel.showViewSheet) {
                ViewFilterSheet(viewModel: viewModel)
//                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $viewModel.showTaskSheet) {
                CreateTaskSheet(viewModel: viewModel)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    // MARK: - Tasks Content
    @ViewBuilder
    private var tasksContent: some View {
        switch viewModel.selectedViewStyle {
        case .list:
            listView
        case .board:
            boardView
        case .calendar:
            calendarView
        }
    }
    
    // MARK: - List View
    private var listView: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.filteredTasks) { task in
                TaskListCard(
                  
                    task: task,
                    onToggle: { viewModel.toggleCompletion(for: task) },
                    
                )
            }
        }
    }
    
    // MARK: - Board View
    private var boardView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 15),
            GridItem(.flexible(), spacing: 15)
        ], spacing: 15) {
            ForEach(viewModel.filteredTasks) { task in
                TaskBoardCard(
                    task: task,
                    onToggle: { viewModel.toggleCompletion(for: task) }
                )
            }
        }
    }
    
    // MARK: - Calendar View
    private var calendarView: some View {
        VStack(spacing: 15) {
            ForEach(viewModel.filteredTasks) { task in
                TaskCalendarCard(
                    task: task,
                    onToggle: { viewModel.toggleCompletion(for: task) }
                )
            }
        }
    }
    
    // MARK: - Floating Action Button
    private var floatingActionButton: some View {
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
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                        .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
    
    // MARK: - Toolbar Content
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.showViewSheet = true
            } label: {
                Image(systemName: "rectangle.stack.fill")
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            DMSansMenuButton(icon: "ellipsis.circle", items: [
                (title: "Activity", icon: "chart.bar.fill", isDestructive: false, action: {
                    navigationPath.append("Activity")
                }),
                (title: "Add Section", icon: "square.on.square.squareshape.controlhandles", isDestructive: false, action: {
                    navigationPath.append("AddSection")
                }),
                (title: "Comments", icon: "message", isDestructive: false, action: {
                    navigationPath.append("Comments")
                })
            ])
        }
    }
}

#Preview {
    InboxView()
}
