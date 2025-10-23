//
//  AddTaskHeaderView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 21/10/2025.
//

import SwiftUI

struct AddTaskHeaderView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Text("Inbox")
                .font(.dmsansBold(size: 24))
                .foregroundStyle(.primary)
            
            Spacer()
            
            
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight:.medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 30, height: 30)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
}

#Preview {
    AddTaskHeaderView(onDismiss: {})
}
