//
//  OnboardingView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 14/10/2025.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var showOnboarding: Bool
    
    var body: some View {
        ZStack {
            
            VStack {
                // Skip button
                HStack {
                    Spacer()
                    Button {
                        print("Skip")
                        viewModel.skipOnboarding()
                        showOnboarding = true
                    } label: {
                        Text("Skip")
                            .font(.dmsans(size: 14))
                            .foregroundStyle(.gray)
                            .padding()
                    }
                }
                // Page Content
                TabView(selection: $viewModel.currentPage){
                    ForEach(0..<viewModel.pages.count, id: \.self){
                        index in
                        OnboardingPageView(page: viewModel.pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                
                Button(action: {
                    if viewModel.currentPage == viewModel.pages.count - 1 {
                        showOnboarding = true   // ✅ mark as completed
                        } else {
                            viewModel.nextPage()
                        }
                }){
                    Text(viewModel.currentPage == viewModel.pages.count - 1 ? "Get Started" : "Continue")
                        .font(.dmsans(size: 16))
                        .foregroundStyle(.white)
                        
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(viewModel.pages[viewModel.currentPage].color)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding(.horizontal, 15)
                        
                }
                .padding(.bottom, 30)
            }
        }
        
    }

}

#Preview {
    OnboardingView(showOnboarding: .constant(false))
}
