//
//  MockTaskDetailPresenter.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import Foundation
@testable import ToDoApp

class MockTaskDetailPresenter: TaskDetailInteractorOutputProtocol {
    var didUpdateTaskOutputCalled = false
    var didFailToUpdateTaskCalled = false
    var updatedTask: TodoModel?
    var updateError: Error?
    
    func didUpdateTaskOutput(_ task: TodoModel) {
        didUpdateTaskOutputCalled = true
        updatedTask = task
    }
    
    func didFailToUpdateTask(withError error: Error) {
        didFailToUpdateTaskCalled = true
        updateError = error
    }
}
