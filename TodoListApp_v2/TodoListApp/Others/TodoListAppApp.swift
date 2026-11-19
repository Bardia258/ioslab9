//
//  TodoListAppApp.swift
//  TodoListApp
//
//  Created by Medhat Elmasry on 2025-10-17.
//

import SwiftUI
import FirebaseCore

@main
struct TodoListAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
       FirebaseApp.configure()
    }
}
