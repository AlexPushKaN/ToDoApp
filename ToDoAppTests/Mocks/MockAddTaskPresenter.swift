//
//  MockAddTaskPresenter.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import Foundation
@testable import ToDoApp

class MockAddTaskPresenter: AddTaskInteractorOutputProtocol {
    var didSaveTaskCalled = false
    var didFailToSaveTaskCalled = false
    var savedTask: TodoModel?
    var saveError: Error?
    
    func didSaveTask(_ task: TodoModel) {
        didSaveTaskCalled = true
        savedTask = task
    }
    
    func didFailToSaveTask(withError error: Error) {
        didFailToSaveTaskCalled = true
        saveError = error
    }
}
