//
//  OnboardingPageView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 14/10/2025.
//

import SwiftUI

struct OnboardingPageView: View {
    
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 350)
                .cornerRadius(20)
            
            Text(page.title)
                .font(.dmsansBold(size: 32))
                .foregroundStyle(page.color)
            
            Text(page.description)
                .font(.dmsans())
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingPageView(page: OnboardingPage.pages[0])
}
