//
//  MockTaskDetailInteractor.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import Foundation
@testable import ToDoApp

class MockTaskDetailInteractor: TaskDetailInteractorInputProtocol {
    var presenter: TaskDetailInteractorOutputProtocol?
    var coreDataService: CoreDataServiceProtocol?
    
    var updateTaskCalled = false
    var updatedTask: TodoModel?
    
    func updateTask(_ task: TodoModel) {
        updateTaskCalled = true
        updatedTask = task
    }
}
