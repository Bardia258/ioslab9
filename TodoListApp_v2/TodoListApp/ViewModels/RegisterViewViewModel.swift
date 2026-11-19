//
//  RegisterViewViewModel.swift
//  TodoListApp
//
//  Created by Medhat Elmasry on 2025-10-17.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class RegisterViewViewModel: ObservableObject {
   @Published var name = ""
   @Published var email = ""
   @Published var password = ""
@Published var errMsg = ""
    
   init() {
      
   }
   

    // this adds a user to Firebase Auth
   func register() {
       guard validate() else {
          return
       }
       // register user with firebase
       Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
          guard let userId = result?.user.uid else {
             return
          }
          self?.insertUserRecord(id: userId)
       }

   }
   
    // this adds custom data into the firestore
    private func insertUserRecord(id: String) {
      let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970)
      
      let db = Firestore.firestore()
      db.collection("users")
         .document(id)
         .setData(newUser.asDictionary())
    }

   
    private func validate() -> Bool {
      errMsg = ""
      
      guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
            !email.trimmingCharacters(in: .whitespaces).isEmpty,
            !password.trimmingCharacters(in: .whitespaces).isEmpty
      else {
         errMsg = "Please fill in name, email and password fields."
         return false
      }
      
      // email@foo.com
      guard email.contains("@") && email.contains(".") else {
         errMsg = "Please enter a valid email address."
         return false
      }
      
      guard password.count >= 6 else {
         errMsg = "Password must be at least 6 characters long."
         return false
      }
      
      return true
    }

}
