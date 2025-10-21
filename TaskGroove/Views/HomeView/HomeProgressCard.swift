//
//  HomeProgressCard.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 21/10/2025.
//

import SwiftUI

struct HomeProgressCard: View {
    @ObservedObject var viewModel: HomeViewModel
    
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "1e3a5f"), Color(hex: "2c5282")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            VStack(spacing: 20) {
                HStack {
                    QuoteSection(quote: viewModel.dailyQuote, author: viewModel.quoteAuthor)
                    
                    Spacer()
                    
                    Image("home_view")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 90)
                }
                
                WeaklyGoalProgress(progress: viewModel.weeklyGoalProgress)
            }
            .padding(20)
        }
        .frame(height: 200)
    }
}


// MARK: - Quote Section
struct QuoteSection: View {
    let quote: String
    let author: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Focus")
                .font(.dmsans(size: 14))
                .foregroundStyle(.white.opacity(0.8))
            
            Text("\"\(quote)\"")
                .font(.dmsans(weight: .medium, size: 16))
                .foregroundColor(.white)
                .lineSpacing(4)
            
            Text("- \(author)")
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Weekly Goal Progress
struct WeaklyGoalProgress: View {
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Weekly Goal")
                    .font(.dmsans(size: 12))
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.dmsansBold(size: 14))
                    .foregroundStyle(.white)
            }
            
            GeometryReader {
                geometry in
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "4ade80"))
                        .frame(width: geometry.size.width * progress)

                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    HomeProgressCard(viewModel: HomeViewModel())
        .padding()
}
