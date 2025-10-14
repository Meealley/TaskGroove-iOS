//
//  OnboardingView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 14/10/2025.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage: Int = 0
    
    private let pages = OnboardingPage.pages
    
    var body: some View {
        ZStack {
//            LinearGradient(
//                colors: [
//                    pages[currentPage].color.opacity(0.3),
//                    pages[currentPage].color.opacity(0.1)
//                    
//                ],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//            .animation(.easeInOut(duration: 0.5), value: currentPage)
            
            VStack {
                // Skip button
                HStack {
                    Spacer()
                    Button {
                        print("Skip")
                        completeOnboarding()
                    } label: {
                        Text("Skip")
                            .font(.dmsans(size: 14))
                            .foregroundStyle(.gray)
                            .padding()
                    }
                }
                // Page Content
                TabView(selection: $currentPage){
                    ForEach(0..<pages.count, id: \.self){
                        index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                VStack(spacing: 20) {
                    if currentPage == pages.count - 1 {
                        Button {
                            print("Get Started")
                            completeOnboarding()
                        } label : {
                            Text("Get Started")
                                .font(.dmsans(size: 16))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 14)
                                .padding()
                                .background(pages[currentPage].color)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal, 15)
                        
                    } else {
                        Button {
                            withAnimation {
                                currentPage += 1
                            }
                        } label : {
                            Text("Continue")
                                .font(.dmsans(size: 16))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(pages[currentPage].color)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal, 15)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        
    }
    
    private func completeOnboarding() {
        withAnimation {
            showOnboarding = false
        }
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
