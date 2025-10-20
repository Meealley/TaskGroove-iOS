import SwiftUI

struct HomeView: View {
    @State private var userName = "Oyewale favour"
    @State private var dayStreak = 1
    @State private var inboxCount = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
//                    HeaderView(userName: userName, dayStreak: dayStreak)
//                        .padding(.horizontal)
//                        .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 33) {
                            // Progress Card
                            ProgressCardView()
                                .padding(.horizontal)
                            
                            // Task Categories - Menu List Style
                            TaskMenuList(inboxCount: inboxCount)
                                .padding(.horizontal)
                            
//                            // Recent Activities
//                            RecentActivitiesView()
//                                .padding(.horizontal)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct HeaderView: View {
    let userName: String
    let dayStreak: Int
    
    var body: some View {
        HStack {
            Text("Welcome Back, \(userName)")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("Day \(dayStreak)")
                    .font(.system(size: 16, weight: .medium))
                Text("🔥")
                    .font(.system(size: 18))
            }
        }
        .padding(.vertical, 8)
    }
}

struct ProgressCardView: View {
    @State private var progress: Double = 1.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "1e3a5f"), Color(hex: "2c5282")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            HStack {
                
                // Illustration
                Image("home_view")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 110)
                    .padding(.trailing, 20)
                
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Manage and Organise\nyour tasks")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .lineSpacing(4)
                    
                    // Progress Bar
                    VStack(alignment: .leading, spacing: 8) {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 28)
                            
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hex: "4ade80"))
                                .frame(width: 200 * progress, height: 28)
                            
                            Text("100.0%")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(width: 200)
                    }
                    .padding(.trailing, 10)
                }
                .padding(.leading, 25)
                
                
                
            }
            .padding(.vertical, 25)
        }
        .frame(height: 140)
    }
}

struct TaskMenuList: View {
    let inboxCount: Int
    
    var body: some View {
        VStack(spacing: 0) {
            TaskMenuRow(
                icon: "tray.fill",
                iconColor: .blue,
                title: "Inbox",
                count: inboxCount,
                position: .top
            )
            
            Divider()
                .background(Color.gray.opacity(0.2))
                .padding(.leading, 56)
            
            TaskMenuRow(
                icon: "calendar",
                iconColor: .green,
                title: "Today",
                count: nil,
                showCalendarDate: true,
                position: .middle
            )
            
            Divider()
                .background(Color.gray.opacity(0.2))
                .padding(.leading, 56)
            
            TaskMenuRow(
                icon: "calendar.badge.plus",
                iconColor: .orange,
                title: "Upcoming",
                count: nil,
                position: .middle
            )
            
            Divider()
                .background(Color.gray.opacity(0.2))
                .padding(.leading, 56)
            
            TaskMenuRow(
                icon: "clock.arrow.circlepath",
                iconColor: .red,
                title: "Overdue",
                count: nil,
                position: .bottom
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
    }
}

struct TaskMenuRow: View {
    enum Position {
        case top, middle, bottom
    }
    
    let icon: String
    let iconColor: Color
    let title: String
    let count: Int?
    var showCalendarDate: Bool = false
    let position: Position
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                ZStack {
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(iconColor.opacity(0.15))
//                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(iconColor)
                    
                    if showCalendarDate {
                        Text("19")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(iconColor)
                            .offset(y: 3)
                    }
                }
                
                Text(title)
                    .font(.dmsans(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let count = count {
                    Text("\(count)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
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

struct TaskCategoryRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let count: Int?
    var showCalendarDate: Bool = false
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(iconColor)
                    
                    if showCalendarDate {
                        Text("18")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(iconColor)
                            .offset(y: 3)
                    }
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let count = count {
                    Text("\(count)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecentActivitiesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Activities")
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
                
                Button(action: {}) {
                    Text("View All")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
            }
            
            VStack(spacing: 12) {
                ActivityRow(
                    taskName: "It works...",
                    timeAgo: "a moment ago",
                    points: 5
                )
                
                ActivityRow(
                    taskName: "Calm",
                    timeAgo: "about an hour ago",
                    points: nil
                )
            }
        }
        .padding(.top, 10)
    }
}

struct ActivityRow: View {
    let taskName: String
    let timeAgo: String
    let points: Int?
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.green)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("You completed a task: \(taskName)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.primary)
                
                Text(timeAgo)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if let points = points {
                Text("\(points)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

// Floating Action Button
struct FloatingActionButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(Color(hex: "1e3a5f"))
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                )
        }
    }
}

// Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(icon: "house.fill", isSelected: selectedTab == 0)
                .onTapGesture { selectedTab = 0 }
            
            TabBarItem(icon: "magnifyingglass", isSelected: selectedTab == 1)
                .onTapGesture { selectedTab = 1 }
            
            TabBarItem(icon: "bell", isSelected: selectedTab == 2)
                .onTapGesture { selectedTab = 2 }
            
            TabBarItem(icon: "person", isSelected: selectedTab == 3)
                .onTapGesture { selectedTab = 3 }
        }
        .padding(.vertical, 8)
        .background(
            Color(UIColor.systemBackground)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: -5)
        )
    }
}

struct TabBarItem: View {
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(isSelected ? Color(hex: "1e3a5f") : .gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

// Main Content View with Tab Bar and FAB
struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HomeView()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton {
                        print("Add new task")
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 80)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
