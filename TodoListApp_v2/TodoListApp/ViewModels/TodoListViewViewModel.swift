//
//  TodoListViewViewModel.swift
//  TodoListApp
//
//  Created by Medhat Elmasry on 2025-10-16.
//

import Foundation
import Combine
import FirebaseFirestore

class TodoListViewViewModel: ObservableObject {
   @Published var showingNewItemView = false
   
   private let _userId: String

   init(userId: String) {
       _userId = userId
   }
   
   /// Delete todo list item
   /// - Parameter id: item id to delete
   func delete(id: String) {
      let db = Firestore.firestore()
      
      db.collection("users")
         .document(_userId)
         .collection("todos")
         .document(id)
         .delete()
   }


}
