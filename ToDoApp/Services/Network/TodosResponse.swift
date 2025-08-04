//
//  TodosResponse.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import Foundation

struct TodosResponse: Codable {
    let todos: [Todo]
}

struct Todo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
