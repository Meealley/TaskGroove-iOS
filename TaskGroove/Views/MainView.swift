//
//  ContentView.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 14/10/2025.
//

import SwiftUI

struct MainView: View {
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, Oyewale Favour!")
                .font(.dmsans())
            
            Button {
              
                     logout()
                
            } label: {
               Text("Logout")
                    .font(.dmsans())
            }
            
            
        }
        .padding()
    }
    
    private func logout() {
        authManager.signOut()
        print("User logged out")
    }
}

#Preview {
    MainView()
}
