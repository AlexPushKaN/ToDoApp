//
//  MockTodoListInteractor.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import Foundation
@testable import ToDoApp

class MockTodoListInteractor: TodoListInteractorInputProtocol {
    var presenter: TodoListInteractorOutputProtocol?
    var apiService: APIServiceProtocol?
    var coreDataService: CoreDataServiceProtocol?
    
    var fetchTodosCalled = false
    var updateTodoCalled = false
    var deleteTodoCalled = false
    var searchTodosCalled = false
    
    var updatedTodo: TodoModel?
    var deletedTodo: TodoModel?
    var searchQuery: String?
    
    func fetchTodos() {
        fetchTodosCalled = true
    }
    
    func updateTodo(_ todo: TodoModel) {
        updateTodoCalled = true
        updatedTodo = todo
    }
    
    func deleteTodo(_ todo: TodoModel) {
        deleteTodoCalled = true
        deletedTodo = todo
    }
    
    func searchTodos(with query: String) {
        searchTodosCalled = true
        searchQuery = query
    }
}
