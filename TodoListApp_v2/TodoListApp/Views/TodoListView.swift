//
//  TodoListView.swift
//  TodoListApp
//
//  Created by Medhat Elmasry on 2025-10-16.
//

import SwiftUI
import FirebaseFirestore
import Combine
import FirebaseAuth

struct TodoListView: View {
   @StateObject var viewModel: TodoListViewViewModel
   
   @FirestoreQuery var items: [TodoListItem]

   init(userId: String) {
      // users/<id>/todos/<todo data>
      self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos")
      
      self._viewModel = StateObject(
               wrappedValue: TodoListViewViewModel(userId: userId)
            )
   }
   
   var body: some View {
      NavigationStack {
         VStack {
             List(items) { item in
                SingleItemView(item: item)
                     .swipeActions(content: {
                        Button ("Delete") {
                           viewModel.delete(id: item.id)
                        }
                        .tint(.red)
                     })

             }
             .listStyle(PlainListStyle())
             .frame(maxWidth: 760)
             .frame(maxWidth: .infinity)

         }
         .navigationTitle("Todo List")
         .toolbar {
            Button {
               viewModel.showingNewItemView = true
            } label: {
               Image(systemName: "plus")
            }
         }
         .sheet(isPresented: $viewModel.showingNewItemView) {
            NewItemView(newItemPresented: $viewModel.showingNewItemView)
         }
      }
   }
}

#Preview {
   TodoListView(userId: "")
}


