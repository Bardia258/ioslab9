//
//  User.swift
//  TodoListApp
//
//  Created by Medhat Elmasry on 2025-10-17.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
}
