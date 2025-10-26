//
//  UpcomingContainerView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 25/10/2025.
//

import SwiftUI

struct UpcomingContainerView: View {
    @StateObject private var viewModel = InboxViewModel()
    @State private var showCreateTask = false
    
    var body: some View {
        ZStack {
            UpcomingView()
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showCreateTask = true
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
        .sheet(isPresented: $showCreateTask) {
            CreateTaskSheet(viewModel: viewModel)
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.3)])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.disabled)
                .interactiveDismissDisabled(false)
        }
    }
}

#Preview {
    UpcomingContainerView()
}
