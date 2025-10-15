//
//  OnboardingViewModel.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 14/10/2025.
//

import Foundation
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var showOnboarding: Bool = true
    
    let pages = OnboardingPage.pages
    
    func nextPage() {
        if currentPage < pages.count - 1 {
            withAnimation {
                currentPage += 1
            }
        } else {
            completeOnboarding()
        }
    }
    
    func skipOnboarding() {
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        withAnimation {
            showOnboarding = false
        }
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}
