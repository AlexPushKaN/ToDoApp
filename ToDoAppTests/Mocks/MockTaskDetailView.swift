//
//  MockTaskDetailView.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

class MockTaskDetailView: TaskDetailViewInputProtocol {
    var presenter: TaskDetailPresenterInputProtocol?
    var delegate: TaskDetailViewControllerDelegate?
    
    var showTaskDetailsCalled = false
    var showErrorMessageCalled = false
    
    var displayedTask: TodoModel?
    var errorMessage: String?
    
    func showTaskDetails(_ task: TodoModel) {
        showTaskDetailsCalled = true
        displayedTask = task
    }
    
    func showErrorMessage(_ message: String) {
        showErrorMessageCalled = true
        errorMessage = message
    }
}
