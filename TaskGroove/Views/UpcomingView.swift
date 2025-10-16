//
//  UpcomingView.swift
//  GreetingsApp
//
//  Created by Oyewale Favour on 12/10/2025.
//

import SwiftUI

struct UpcomingView: View {
    @State private var upcomingEvents = [
        Event(title: "Sprint Planning", date: Date().addingTimeInterval(86400), type: .meeting),
        Event(title: "Project Deadline", date: Date().addingTimeInterval(172800), type: .deadline),
        Event(title: "Team Lunch", date: Date().addingTimeInterval(259200), type: .social),
        Event(title: "Code Review Session", date: Date().addingTimeInterval(345600), type: .meeting)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.05), .purple.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Calendar Preview Card
                        VStack(spacing: 15) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(Date().formatted(.dateTime.month(.wide)))
                                        .font(.dmsans(size: 16))
                                        .foregroundColor(.secondary)
                                    Text(Date().formatted(.dateTime.year()))
                                        .font(.dmsansBold(size: 24))
                                }
                                Spacer()
                                Image(systemName: "calendar")
                                    .font(.system(size: 40))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(20)
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.05), radius: 5)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Upcoming Events
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Upcoming Events")
                                .font(.dmsansBold(size: 20))
                                .padding(.horizontal, 20)
                            
                            ForEach(upcomingEvents) { event in
                                EventCard(event: event)
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Upcoming")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Add new event
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                    }
                }
            }
        }
    }
}

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let type: EventType
    
    enum EventType {
        case meeting, deadline, social
        
        var icon: String {
            switch self {
            case .meeting: return "person.2.fill"
            case .deadline: return "flag.fill"
            case .social: return "fork.knife"
            }
        }
        
        var color: Color {
            switch self {
            case .meeting: return .blue
            case .deadline: return .red
            case .social: return .green
            }
        }
    }
}

struct EventCard: View {
    let event: Event
    
    private var daysDifference: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: event.date).day ?? 0
    }
    
    private var dateText: String {
        if daysDifference == 0 {
            return "Today"
        } else if daysDifference == 1 {
            return "Tomorrow"
        } else {
            return "in \(daysDifference) days"
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(event.type.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: event.type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(event.type.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.dmsans(size: 16))
                
                HStack(spacing: 5) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    Text(event.date.formatted(.dateTime.month().day()))
                        .font(.dmsans(size: 14))
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(dateText)
                        .font(.dmsans(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    UpcomingView()
}
