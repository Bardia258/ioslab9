//
//  TodoListItem.swift
//  TodoListApp
//
//  Created by Medhat Elmasry on 2025-10-17.
//

import Foundation

struct TodoListItem: Codable, Identifiable {
   let id: String
   let title: String
   let dueDate: TimeInterval
   let createdDate: TimeInterval
   var isDone: Bool
   
   // this is a setter
   mutating func setDone(_ state: Bool) {
      isDone = state
   }
}
