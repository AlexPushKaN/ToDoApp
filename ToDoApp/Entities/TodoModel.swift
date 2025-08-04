//
//  TodoModel.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import Foundation

struct TodoModel {
    let id: Int64
    let title: String
    let taskDescription: String?
    let createdAt: Date
    var isCompleted: Bool
    let userId: Int64
    
    // Инициализатор для создания TodoModel напрямую из свойств
    init(id: Int64, title: String, taskDescription: String?, createdAt: Date, isCompleted: Bool, userId: Int64) {
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
        self.createdAt = createdAt
        self.isCompleted = isCompleted
        self.userId = userId
    }
    
    // Инициализатор для создания TodoModel из локального хранилища
    init(from entity: TodoEntity) {
        self.id = entity.id
        self.title = entity.title ?? ""
        self.taskDescription = entity.taskDescription
        self.createdAt = entity.createdAt ?? Date()
        self.isCompleted = entity.isCompleted
        self.userId = entity.userId
    }
    
    // Инициализатор для создания TodoModel из сетевого сервиса
    init(from apiTodo: Todo, description: String? = nil, createdAt: Date = Date()) {
        self.id = Int64(apiTodo.id)
        self.title = apiTodo.todo
        self.taskDescription = description
        self.createdAt = createdAt
        self.isCompleted = apiTodo.completed
        self.userId = Int64(apiTodo.userId)
    }
}

