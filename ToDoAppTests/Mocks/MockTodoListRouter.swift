//
//  MockTodoListRouter.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import UIKit
@testable import ToDoApp

class MockTodoListRouter: TodoListRouterInputProtocol {
    var presentAddTodoScreenCalled = false
    var presentTodoDetailScreenCalled = false
    var presentedTodo: TodoModel?
    
    static func createModule() -> UIViewController {
        return UIViewController()
    }
    
    func presentAddTodoScreen(from view: TodoListViewProtocol) {
        presentAddTodoScreenCalled = true
    }
    
    func presentTodoDetailScreen(from view: TodoListViewProtocol, for todo: TodoModel) {
        presentTodoDetailScreenCalled = true
        presentedTodo = todo
    }
}
