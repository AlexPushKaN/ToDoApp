//
//  MockAddTaskDelegate.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

final class MockAddTaskDelegate: AddTaskViewControllerDelegate {
    
    var didAddTodoCalled = false

    var receivedTodo: TodoModel?

    func didAddTodo(_ todo: TodoModel) {
        didAddTodoCalled = true
        receivedTodo = todo
    }
}
