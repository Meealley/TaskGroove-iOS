//
//  RescheduleDateSheet.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 23/10/2025.
//

import SwiftUI

//
//  RescheduleDateSheet.swift
//  TaskGroove
//

import SwiftUI

struct RescheduleDateSheet: View {
    let task: TaskItem
    let onReschedule: (Date) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var selectedDate: Date
    @State private var selectedQuickOption: RescheduleQuickOption?
    
    // Precomputed values
    private let quickOptions: [RescheduleQuickOption] = [.today, .tomorrow, .thisWeekend, .nextWeek]
    
    init(task: TaskItem, onReschedule: @escaping (Date) -> Void) {
        self.task = task
        self.onReschedule = onReschedule
        _selectedDate = State(initialValue: task.dueDate ?? Date())
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                taskInfoHeader
                
                ScrollView {
                    LazyVStack(spacing: 16, pinnedViews: []) {
                        quickOptionsSection
                        calendarSection
                    }
                    .padding(.bottom, 20)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Reschedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarItems
            }
        }
    }
    
    // MARK: - Task Info Header
    private var taskInfoHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.name)
                .font(.dmsansBold(size: 18))
                .foregroundColor(.primary)
            
            if let currentDate = task.dueDate {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                    Text("Currently: \(currentDate.formatted(.dateTime.month().day()))")
                        .font(.dmsans(size: 14))
                }
                .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Quick Options Section
    private var quickOptionsSection: some View {
        VStack(spacing: 0) {
            ForEach(quickOptions, id: \.self) { option in
                quickOptionRow(option)
                
                if option != quickOptions.last {
                    Divider().padding(.leading, 66)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    // MARK: - Quick Option Row
    private func quickOptionRow(_ option: RescheduleQuickOption) -> some View {
        Button(action: {
            selectedQuickOption = option
            selectedDate = option.date
        }) {
            HStack(spacing: 16) {
                Image(systemName: option.icon)
                    .font(.system(size: 20))
                    .foregroundColor(option.color)
                    .frame(width: 30)
                
                Text(option.title)
                    .font(.dmsans(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(option.dayText)
                    .font(.dmsans(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                selectedQuickOption == option ? Color.blue.opacity(0.1) : Color.clear
            )
        }
    }
    
    // MARK: - Calendar Section
    private var calendarSection: some View {
        DatePicker("", selection: $selectedDate, displayedComponents: [.date])
            .datePickerStyle(.graphical)
            .padding(.horizontal)
    }
    
    // MARK: - Toolbar Items
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                dismiss()
            }
            .font(.dmsans())
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done") {
                onReschedule(selectedDate)
                dismiss()
            }
            .font(.dmsansBold())
            .foregroundColor(.blue)
        }
    }
}
