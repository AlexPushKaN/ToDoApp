//
//  MockTodoListView.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

class MockTodoListView: TodoListViewProtocol {
    var presenter: TodoListPresenterInputProtocol?
    
    var showTodosCalled = false
    var showUnfinishedTodosCalled = false
    var showErrorMessageCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    
    var todos: [TodoModel]?
    var unfinishedAmount: Int?
    var errorMessage: String?
    
    func showTodos(_ todos: [TodoModel]) {
        showTodosCalled = true
        self.todos = todos
    }
    
    func showUnfinishedTodos(_ amount: Int) {
        showUnfinishedTodosCalled = true
        self.unfinishedAmount = amount
    }
    
    func showErrorMessage(_ message: String) {
        showErrorMessageCalled = true
        self.errorMessage = message
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
}
