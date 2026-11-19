//
//  ContentView.swift
//  TodoListApp
//
//  Created by Medhat Elmasry on 2025-10-17.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel()
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            accountView
        } else {
           LoginView()
        }

    }
    
    @ViewBuilder
    var accountView: some View {
        VStack {
            TabView {
                TodoListView(userId: viewModel.currentUserId)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
                
                LogoutView()
                    .tabItem {
                        Label("Logout", systemImage: "figure.walk.departure")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
