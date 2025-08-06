//
//  MockAddTaskInteractor.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import Foundation
@testable import ToDoApp

class MockAddTaskInteractor: AddTaskInteractorInputProtocol {
    var presenter: AddTaskInteractorOutputProtocol?
    var coreDataService: CoreDataServiceProtocol?
    
    var saveTaskCalled = false
    var savedTask: TodoModel?
    
    func saveTask(_ task: TodoModel) {
        saveTaskCalled = true
        savedTask = task
    }
}
