//
//  LogoutView.swift
//  TodoListApp
//
//  Created by Medhat Elmasry on 2025-10-31.
//

import SwiftUI

struct LogoutView: View {
  @StateObject var vModel = LogoutViewViewModel()
  var body: some View {
    Button("Logout") {
        vModel.logout()
    }
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
  }
}

#Preview {
  LogoutView()
}
