//
//  MockTaskDetailDelegate.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

final class MockTaskDetailDelegate: TaskDetailViewControllerDelegate {

    var didUpdateTodoCalled = false

    var receivedTodo: TodoModel?

    func didUpdateTodo(_ todo: TodoModel) {
        didUpdateTodoCalled = true
        receivedTodo = todo
    }
}
