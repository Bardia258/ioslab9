//
//  TodoListItemsViewViewModel.swift
//  TodoListApp
//
//  Created by Medhat Elmasry on 2025-10-17.
//

import Foundation
import Combine

import FirebaseAuth
import FirebaseFirestore

class SingleItemViewViewModel: ObservableObject {
    
    init() {}
    
    func toggleIsDone(item: TodoListItem) {
       // you must make a copy of item because it is immutable
       var itemCopy = item
       itemCopy.setDone(!item.isDone)
       
       guard let uid = Auth.auth().currentUser?.uid else {
          return
       }
       
       let db = Firestore.firestore()
       db.collection("users")
          .document(uid)
          .collection("todos")
          .document(itemCopy.id)
          .setData(itemCopy.asDictionary())
       
    }
}
