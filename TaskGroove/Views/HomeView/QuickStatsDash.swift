//
//  HomeStatsComponents.swift
//  TaskGroove
//
//  Advanced Quick Stats Dashboard
//

import SwiftUI

struct QuickStatsDashboard: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            DynamicStatCard(
                title: "Active Tasks",
                value: "\(viewModel.activeTasks)",
                icon: "bolt.fill",
                gradient: [.blue, .purple],
                glow: Color.blue,
                progress: Double(viewModel.activeTasks) / 10
            )
            
            DynamicStatCard(
                title: "Done Today",
                value: "\(viewModel.completedToday)",
                icon: "checkmark.seal.fill",
                gradient: [.green, .mint],
                glow: Color.green,
                progress: Double(viewModel.completedToday) / 10
            )
            
            DynamicStatCard(
                title: "Focus Time",
                value: "\(viewModel.focusHours)h",
                icon: "timer.circle.fill",
                gradient: [.orange, .pink],
                glow: Color.orange,
                progress: min(Double(viewModel.focusHours) / 5, 1.0)
            )
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Dynamic Stat Card
struct DynamicStatCard: View {
    let title: String
    let value: String
    let icon: String
    let gradient: [Color]
    let glow: Color
    let progress: Double
    
    @State private var tilt = CGSize.zero
    @State private var appear = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Glowing Gradient Layer
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blur(radius: 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(glow.opacity(0.3), lineWidth: 1.5)
                            .shadow(color: glow.opacity(0.4), radius: 8)
                    )
                    .shadow(color: glow.opacity(0.25), radius: 12, x: 0, y: 8)
                    .scaleEffect(appear ? 1 : 0.9)
                    .rotation3DEffect(
                        .degrees(Double(tilt.width / 10)),
                        axis: (x: -tilt.height, y: tilt.width, z: 0)
                    )
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: appear)
                
                VStack(spacing: 12) {
                    // Circular progress indicator
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 6)
                            .foregroundColor(.white.opacity(0.2))
                        
                        Circle()
                            .trim(from: 0.0, to: CGFloat(progress))
                            .stroke(
                                AngularGradient(colors: gradient, center: .center),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .shadow(color: glow.opacity(0.3), radius: 6)
                        
                        Image(systemName: icon)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 52, height: 52)
                    
                    VStack(spacing: 4) {
                        Text(value)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                        
                        Text(title)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                    }
                }
                .padding()
            }
            .frame(height: geo.size.width * 0.9)
            .rotation3DEffect(.degrees(Double(tilt.width / 15)), axis: (x: -tilt.height, y: tilt.width, z: 0))
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    appear = true
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        tilt = gesture.translation
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) { tilt = .zero }
                    }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: 140)
    }
}

#Preview {
    QuickStatsDashboard(viewModel: HomeViewModel())
        .padding()
        .background(
            LinearGradient(colors: [.black, .gray.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
}
