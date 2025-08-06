//
//  MockTodoListPresenter.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import Foundation
@testable import ToDoApp

class MockTodoListPresenter: TodoListInteractorOutputProtocol {
    var didFetchTodosCalled = false
    var didFailToFetchTodosCalled = false
    var didDeleteTodoOutputCalled = false
    var didFailToDeleteTodoOutputCalled = false
    var didSearchTodosCalled = false
    var didFailToSearchTodosCalled = false
    
    var fetchedTodos: [TodoModel] = []
    var fetchError: Error?
    var deletedTodoId: Int64?
    var deleteError: Error?
    var searchedTodos: [TodoModel] = []
    var searchError: Error?
    
    func didFetchTodos(_ todos: [TodoModel]) {
        didFetchTodosCalled = true
        fetchedTodos = todos
    }
    
    func didFailToFetchTodos(withError error: Error) {
        didFailToFetchTodosCalled = true
        fetchError = error
    }
    
    func didDeleteTodoOutput(withId id: Int64) {
        didDeleteTodoOutputCalled = true
        deletedTodoId = id
    }
    
    func didFailToDeleteTodoOutput(withError error: Error) {
        didFailToDeleteTodoOutputCalled = true
        deleteError = error
    }
    
    func didSearchTodos(_ todos: [TodoModel]) {
        didSearchTodosCalled = true
        searchedTodos = todos
    }
    
    func didFailToSearchTodos(withError error: Error) {
        didFailToSearchTodosCalled = true
        searchError = error
    }
}
