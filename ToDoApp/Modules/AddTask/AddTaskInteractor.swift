//
//  AddTaskInteractor.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import Foundation

class AddTaskInteractor {
    
    // MARK: - VIPER
    weak var presenter: AddTaskInteractorOutputProtocol?
    var coreDataService: CoreDataServiceProtocol?
}

// MARK: - AddTaskInteractorInputProtocol
extension AddTaskInteractor: AddTaskInteractorInputProtocol {
    
    func saveTask(_ task: TodoModel) {
        coreDataService?.saveTodo(task) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didSaveTask(task)
            case .failure(let error):
                self?.presenter?.didFailToSaveTask(withError: error)
            }
        }
    }
}
