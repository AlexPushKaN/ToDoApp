//
//  MockCoreDataService.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import Foundation
import CoreData
@testable import ToDoApp

class MockCoreDataService: CoreDataServiceProtocol {
    var fetchTodosResult: Result<[TodoModel], Error>?
    var saveTodosResult: Result<Void, Error>?
    var saveTodoResult: Result<Void, Error>?
    var updateTodoResult: Result<Void, Error>?
    var deleteTodoResult: Result<Void, Error>?
    var searchTodosResult: Result<[TodoModel], Error>?
    
    var fetchTodosCalled = false
    var saveTodosCalled = false
    var saveTodoCalled = false
    var updateTodoCalled = false
    var deleteTodoCalled = false
    var searchTodosCalled = false
    
    var savedTodos: [TodoModel] = []
    var savedTodo: TodoModel?
    var updatedTodo: TodoModel?
    var deletedTodoId: Int64?
    var searchQuery: String?
    
    func fetchTodos(completion: @escaping (Result<[TodoModel], Error>) -> Void) {
        fetchTodosCalled = true
        if let result = fetchTodosResult {
            completion(result)
        }
    }
    
    func saveTodo(_ todo: TodoModel, completion: @escaping (Result<Void, any Error>) -> Void) {
        saveTodoCalled = true
        savedTodo = todo
        if let result = saveTodoResult {
            completion(result)
        }
    }
    
    func saveTodos(_ todos: [TodoModel], completion: @escaping (Result<Void, Error>) -> Void) {
        saveTodosCalled = true
        savedTodos = todos
        if let result = saveTodosResult {
            completion(result)
        }
    }
    
    func updateTodo(_ todo: TodoModel, completion: @escaping (Result<Void, Error>) -> Void) {
        updateTodoCalled = true
        updatedTodo = todo
        if let result = updateTodoResult {
            completion(result)
        }
    }
    
    func deleteTodo(withId id: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        deleteTodoCalled = true
        deletedTodoId = id
        if let result = deleteTodoResult {
            completion(result)
        }
    }
    
    func searchTodos(with query: String, completion: @escaping (Result<[TodoModel], Error>) -> Void) {
        searchTodosCalled = true
        searchQuery = query
        if let result = searchTodosResult {
            completion(result)
        }
    }
}
