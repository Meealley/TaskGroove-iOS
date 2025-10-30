//
//  ViewFilterSheet.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 16/10/2025.
//

import SwiftUI

struct ViewFilterSheet: View {
    @ObservedObject var viewModel: InboxViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                // View Group
                VStack(alignment: .leading, spacing: 15) {
                    Text("View")
                        .font(.dmsansBold(size: 18))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    HStack(spacing: 20) {
                        ViewStyleButton(
                            icon: "list.bullet",
                            title: "List",
                            isSelected: viewModel.selectedViewStyle == .list
                        ) {
                            viewModel.selectedViewStyle = .list
                        }
                        
                        ViewStyleButton(
                            icon: "square.grid.2x2",
                            title: "Board",
                            isSelected: viewModel.selectedViewStyle == .board
                        ) {
                            viewModel.selectedViewStyle = .board
                        }
                        
                        ViewStyleButton(
                            icon: "calendar",
                            title: "Calendar",
                            isSelected: viewModel.selectedViewStyle == .calendar
                        ) {
                            viewModel.selectedViewStyle = .calendar
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Divider()
                    .padding(.horizontal, 20)
                
                // Show Completed Tasks Toggle
                VStack(alignment: .leading, spacing: 15) {
                    Toggle(isOn: $viewModel.showCompletedTasks) {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .font(.system(size: 20))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Show Completed")
                                    .font(.dmsans(size: 16))
                                    .foregroundStyle(.primary)
                                
                                Text("\(viewModel.completedTasks.count) completed tasks")
                                    .font(.dmsans(size: 13))
                                    .foregroundStyle(.secondary)
                                
                            }
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                }
                
                
                Divider()
                    .padding(.horizontal, 20)
                
                
                // Filter Group
                VStack(alignment: .leading, spacing: 15) {
                    Text("Filter")
                        .font(.dmsansBold(size: 18))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 0) {
                        ForEach(FilterOptions.allCases, id: \.self) { option in
                            FilterRow(
                                title: option.rawValue,
                                isSelected: viewModel.selectedFilter == option
                            ) {
                                viewModel.selectedFilter = option
                            }
                            
                            if option != FilterOptions.allCases.last {
                                Divider()
                                    .padding(.leading, 60)
                            }
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.dmsans())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.dmsansBold())
                }
            }
        }
    }
}
