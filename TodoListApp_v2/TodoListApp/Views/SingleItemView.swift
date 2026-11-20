//
//  TodoListItemsView.swift
//  TodoListApp
//
//  Created by Medhat Elmasry on 2025-10-17.
//

import SwiftUI

struct SingleItemView: View {
    @StateObject var viewModel = SingleItemViewViewModel()
    let item: TodoListItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
           VStack(alignment: .leading) {
              Text(item.title)
                 .font(.body)
                 .fixedSize(horizontal: false, vertical: true)
              
              Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                 .font(.footnote)
                 .foregroundColor(Color.secondary)
                 .fixedSize(horizontal: false, vertical: true)
           }
           .frame(maxWidth: .infinity, alignment: .leading)

           Button {
              // action
               viewModel.toggleIsDone(item: item)   
           } label: {
              Image(systemName:
                     item.isDone ? "checkmark.circle.fill" : "circle")
              .foregroundColor(Color.blue)
                 .font(.title2)
                 .frame(minWidth: 44, minHeight: 44)
           }
           .buttonStyle(.plain)
           .accessibilityLabel(item.isDone ? "Mark incomplete" : "Mark complete")
        }

    }
}


#Preview {
   var todo = TodoListItem(id: "123", title: "Buy Flour", dueDate: Date().timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false)
   SingleItemView ( item: todo)
}


