//
//  HomeMenuComponents.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 21/10/2025.
//

import SwiftUI

struct HomeMenuComponents: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var navigateToInbox: Bool
    @Binding var navigateToProjects: Bool
    @Binding var navigateToGoals: Bool
    @Binding var navigateToAnalytics: Bool
    
    var body: some View {
        VStack(spacing: 0){
            
            MenuRowButton(
                icon: "tray.fill",
                iconColor: .blue,
                title: "All Tasks",
                subtitle: nil,
                position: .top,
                showBadge: true,
                badgeCount: viewModel.activeTasks,
                            ) {
                navigateToInbox = true
            }
            
            MenuDivider()
            
            MenuRowButton(
                icon: "folder.fill",
                iconColor: .purple,
                title: "Projects",
                subtitle: nil,
                position: .middle
                            ) {
                navigateToProjects = true
            }
            
            MenuDivider()

            
            MenuRowButton(
                icon: "target",
                iconColor: .orange,
                title: "Goals",
                subtitle: "\(viewModel.goalsCount) active",
                position: .middle
                            ) {
                navigateToGoals = true
            }
            
            MenuDivider()

            MenuRowButton(
                icon: "chart.xyaxis.line",
                iconColor: .green,
                title: "Analytics",
                subtitle: "View your progress",
                position: .bottom,
            
                            ) {
                navigateToAnalytics = true
            }
       
            
            
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 10)
    }
}

struct MenuRowButton: View {
    enum Position {
        case top, middle, bottom
    }
    
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    var position: Position
    var showBadge: Bool = false
    var badgeCount: Int = 0
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(iconColor)
                    .frame(width: 40, height: 40)
                
                MenuText(title: title, subtitle: subtitle)
                
                Spacer()
                
                if showBadge && badgeCount > 0 {
                    Text("\(badgeCount)")
                        .font(.dmsansBold(size: 12))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(iconColor)
                        )
                }
                // Chevron Indicator
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MenuText: View {
    
    let title: String
    let subtitle: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2){
            Text(title)
                .font(.dmsans(weight: .medium, size: 16))
                .foregroundStyle(.primary)
            
            if let subtitle {
                Text(subtitle)
                    .font(.dmsans(size: 12))
                    .foregroundStyle(.secondary)
            }
        }
    }
}


// MARK: - Menu Divider
struct MenuDivider: View {
    var body: some View {
        Divider()
            .background(Color.gray.opacity(0.2))
            .padding(.leading, 56)
    }
}


#Preview {
    HomeMenuComponents(
        viewModel: HomeViewModel(),
        navigateToInbox: .constant(false),
        navigateToProjects: .constant(false),
        navigateToGoals: .constant(false),
        navigateToAnalytics: .constant(false)

    )
}
