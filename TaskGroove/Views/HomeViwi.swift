import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var userName = "Oyewale favour"
    @State private var dayStreak = 1
    @State private var navigateToInbox = false
    @State private var navigateToProjects = false
    @State private var navigateToGoals = false
    @State private var navigateToAnalytics = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 25) {
                            // Welcome Header
                            WelcomeHeaderView(userName: userName, dayStreak: dayStreak)
                                .padding(.horizontal)
                                .padding(.top, 20)
                            
                            // Progress Card with Motivational Quote
                            EnhancedProgressCard(viewModel: viewModel)
                                .padding(.horizontal)
                            
                            // Quick Stats Dashboard
                            QuickStatsDashboard(viewModel: viewModel)
                                .padding(.horizontal)
                            
                            // Strategic Menu List
                            StrategicMenuList(
                                viewModel: viewModel,
                                navigateToInbox: $navigateToInbox,
                                navigateToProjects: $navigateToProjects,
                                navigateToGoals: $navigateToGoals,
                                navigateToAnalytics: $navigateToAnalytics
                            )
                            .padding(.horizontal)
                            
                            // Daily Focus Section
                            DailyFocusSection(viewModel: viewModel)
                                .padding(.horizontal)
                            
                            // Recent Achievements
                            RecentAchievementsView(viewModel: viewModel)
                                .padding(.horizontal)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToInbox) {
                InboxView()
            }
            .navigationDestination(isPresented: $navigateToProjects) {
                ProjectsView()
            }
            .navigationDestination(isPresented: $navigateToGoals) {
                GoalsView()
            }
            .navigationDestination(isPresented: $navigateToAnalytics) {
                AnalyticsView()
            }
        }
    }
}

// View Model for Home
class HomeViewModel: ObservableObject {
    @Published var activeTasks = 12
    @Published var completedToday = 5
    @Published var weeklyGoalProgress = 0.75
    @Published var projectsCount = 3
    @Published var goalsCount = 4
    @Published var focusHours = 3.5
    @Published var dailyQuote = "The secret of getting ahead is getting started."
    @Published var quoteAuthor = "Mark Twain"
    
    // Focus Tasks
    @Published var focusTasks: [FocusTask] = [
        FocusTask(title: "Complete project proposal", priority: .high, estimatedTime: "2h"),
        FocusTask(title: "Review team submissions", priority: .medium, estimatedTime: "1h"),
        FocusTask(title: "Prepare weekly report", priority: .medium, estimatedTime: "45m")
    ]
    
    // Recent Achievements
    @Published var achievements: [Achievement] = [
        Achievement(title: "Task Master", description: "Completed 50 tasks", icon: "star.fill", date: Date()),
        Achievement(title: "Streak Keeper", description: "7-day streak", icon: "flame.fill", date: Date().addingTimeInterval(-86400))
    ]
}

// Welcome Header
struct WelcomeHeaderView: View {
    let userName: String
    let dayStreak: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome back,")
                .font(.dmsans(size: 16))
                .foregroundColor(.secondary)
            
            HStack {
                Text(userName)
                    .font(.dmsansBold(size: 28))
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 6) {
                    Text("Day \(dayStreak)")
                        .font(.dmsans(weight: .medium, size: 16))
                    Text("🔥")
                        .font(.system(size: 18))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.orange.opacity(0.15))
                )
            }
        }
    }
}

// Enhanced Progress Card with Quote
struct EnhancedProgressCard: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color.purple, Color.blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's Focus")
                            .font(.dmsans(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("\"\(viewModel.dailyQuote)\"")
                            .font(.dmsans(weight: .medium, size: 16))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        
                        Text("— \(viewModel.quoteAuthor)")
                            .font(.dmsans(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Image("home_view")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 90)
                }
                
                // Weekly Goal Progress
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Weekly Goal")
                            .font(.dmsans(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text("\(Int(viewModel.weeklyGoalProgress * 100))%")
                            .font(.dmsansBold(size: 14))
                            .foregroundColor(.white)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.2))
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                                .frame(width: geometry.size.width * viewModel.weeklyGoalProgress)
                        }
                    }
                    .frame(height: 8)
                }
            }
            .padding(20)
        }
        .frame(height: 200)
    }
}

// Quick Stats Dashboard
struct QuickStatsDashboard: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            StatCard(
                value: "\(viewModel.activeTasks)",
                label: "Active",
                icon: "list.bullet",
                color: .blue
            )
            
            StatCard(
                value: "\(viewModel.completedToday)",
                label: "Done Today",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            StatCard(
                value: "\(viewModel.focusHours)h",
                label: "Focus Time",
                icon: "timer",
                color: .orange
            )
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.dmsansBold(size: 22))
                .foregroundColor(.primary)
            
            Text(label)
                .font(.dmsans(size: 11))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

// Strategic Menu List
struct StrategicMenuList: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var navigateToInbox: Bool
    @Binding var navigateToProjects: Bool
    @Binding var navigateToGoals: Bool
    @Binding var navigateToAnalytics: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            MenuRowButton(
                icon: "tray.fill",
                iconColor: .blue,
                title: "All Tasks",
                subtitle: "\(viewModel.activeTasks) active tasks",
                showBadge: true,
                badgeCount: viewModel.activeTasks,
                position: .top
            ) {
                navigateToInbox = true
            }
            
            Divider()
                .background(Color.gray.opacity(0.2))
                .padding(.leading, 56)
            
            MenuRowButton(
                icon: "folder.fill",
                iconColor: .purple,
                title: "Projects",
                subtitle: "\(viewModel.projectsCount) ongoing",
                position: .middle
            ) {
                navigateToProjects = true
            }
            
            Divider()
                .background(Color.gray.opacity(0.2))
                .padding(.leading, 56)
            
            MenuRowButton(
                icon: "target",
                iconColor: .orange,
                title: "Goals & Habits",
                subtitle: "\(viewModel.goalsCount) active goals",
                position: .middle
            ) {
                navigateToGoals = true
            }
            
            Divider()
                .background(Color.gray.opacity(0.2))
                .padding(.leading, 56)
            
            MenuRowButton(
                icon: "chart.xyaxis.line",
                iconColor: .green,
                title: "Analytics",
                subtitle: "View your progress",
                position: .bottom
            ) {
                navigateToAnalytics = true
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
    }
}

struct MenuRowButton: View {
    enum Position {
        case top, middle, bottom
    }
    
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    var showBadge: Bool = false
    var badgeCount: Int = 0
    let position: Position
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.dmsans(weight: .medium, size: 16))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.dmsans(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if showBadge && badgeCount > 0 {
                    Text("\(badgeCount)")
                        .font(.dmsansBold(size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(iconColor)
                        )
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Daily Focus Section
struct DailyFocusSection: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Focus")
                    .font(.dmsansBold(size: 18))
                
                Spacer()
                
                Button(action: {}) {
                    Text("View All")
                        .font(.dmsans(size: 14))
                        .foregroundColor(.blue)
                }
            }
            
            VStack(spacing: 10) {
                ForEach(viewModel.focusTasks) { task in
                    FocusTaskRow(task: task)
                }
            }
        }
    }
}

struct FocusTask: Identifiable {
    let id = UUID()
    let title: String
    let priority: Priority
    let estimatedTime: String
    
    enum Priority {
        case high, medium, low
        
        var color: Color {
            switch self {
            case .high: return .red
            case .medium: return .orange
            case .low: return .blue
            }
        }
    }
}

struct FocusTaskRow: View {
    let task: FocusTask
    @State private var isCompleted = false
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                withAnimation {
                    isCompleted.toggle()
                }
            }) {
                Circle()
                    .stroke(task.priority.color, lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .fill(task.priority.color)
                            .frame(width: 16, height: 16)
                            .opacity(isCompleted ? 1 : 0)
                    )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.dmsans(size: 14))
                    .foregroundColor(.primary)
                    .strikethrough(isCompleted)
                
                HStack(spacing: 8) {
                    Label(task.estimatedTime, systemImage: "clock")
                        .font(.dmsans(size: 11))
                        .foregroundColor(.secondary)
                    
                    Circle()
                        .fill(task.priority.color)
                        .frame(width: 6, height: 6)
                    
                    Text(task.priority == .high ? "High Priority" : task.priority == .medium ? "Medium" : "Low")
                        .font(.dmsans(size: 11))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

// Recent Achievements
struct RecentAchievementsView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Achievements")
                    .font(.dmsansBold(size: 18))
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.yellow)
                }
            }
            
            HStack(spacing: 12) {
                ForEach(viewModel.achievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let date: Date
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: achievement.icon)
                .font(.system(size: 24))
                .foregroundColor(.yellow)
            
            VStack(spacing: 2) {
                Text(achievement.title)
                    .font(.dmsans(weight: .medium, size: 12))
                    .foregroundColor(.primary)
                
                Text(achievement.description)
                    .font(.dmsans(size: 10))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.yellow.opacity(0.1))
        )
    }
}

// Placeholder Views for Navigation
struct ProjectsView: View {
    var body: some View {
        Text("Projects View")
            .navigationTitle("Projects")
    }
}

struct GoalsView: View {
    var body: some View {
        Text("Goals & Habits")
            .navigationTitle("Goals & Habits")
    }
}

struct AnalyticsView: View {
    var body: some View {
        Text("Analytics View")
            .navigationTitle("Analytics")
    }
}

// Preview
#Preview {
    HomeView()
}
