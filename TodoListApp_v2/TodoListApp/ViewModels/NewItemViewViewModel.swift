import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class NewItemViewViewModel: ObservableObject {
   @Published var title = ""
   @Published var dueDate = Date() // defaults to current date
   @Published var errMsg = ""
   @Published var showAlert = false
   
   init() {}
   
   func save() {
      guard canSave else {
         return
      }
      
      // Get current user id
      guard let uId = Auth.auth().currentUser?.uid else {
         return
      }
      
      // Create model
      let newId = UUID().uuidString
      let newItem = TodoListItem(
         id: newId,
         title: title,
         dueDate: dueDate.timeIntervalSince1970,
         createdDate: Date().timeIntervalSince1970,
         isDone: false)
      
      // Save the model
      let db = Firestore.firestore()
      db.collection("users")
         .document(uId)
         .collection("todos")
         .document(newId)
         .setData(newItem.asDictionary())
   }
   
   var canSave: Bool {
      errMsg = ""
      
      guard !title.trimmingCharacters(in: .whitespaces).isEmpty
      else {
         errMsg = "Please fill in title field."
         return false
      }

            // 86400 is the number of seconds in a day
      guard dueDate >= Date().addingTimeInterval(-86400) else {
         errMsg = "Due date cannot be in the past."
         return false
      }
      
      return true

   }
}
