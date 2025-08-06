//
//  MockAddTaskView.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

class MockAddTaskView: AddTaskViewInputProtocol {
    var presenter: AddTaskPresenterInputProtocol?
    var delegate: AddTaskViewControllerDelegate?
    
    var showErrorMessageCalled = false
    var errorMessage: String?
    
    func showErrorMessage(_ message: String) {
        showErrorMessageCalled = true
        self.errorMessage = message
    }
}
