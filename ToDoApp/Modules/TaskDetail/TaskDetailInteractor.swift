//
//  TaskDetailInteractor.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 05.08.2025.
//

import Foundation

class TaskDetailInteractor {
    
    // MARK: - VIPER
    weak var presenter: TaskDetailInteractorOutputProtocol?
    var coreDataService: CoreDataServiceProtocol?
}

// MARK: - TaskDetailInteractorInputProtocol
extension TaskDetailInteractor: TaskDetailInteractorInputProtocol {
    
    func updateTask(_ task: TodoModel) {
        coreDataService?.updateTodo(task) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didUpdateTaskOutput(task)
            case .failure(let error):
                self?.presenter?.didFailToUpdateTask(withError: error)
            }
        }
    }
}
