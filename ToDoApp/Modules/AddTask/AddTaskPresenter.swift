//
//  AddTaskPresenter.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import Foundation

class AddTaskPresenter {
    
    // MARK: - VIPER
    weak var view: AddTaskViewInputProtocol?
    var interactor: AddTaskInteractorInputProtocol?
    var router: AddTaskRouterInputProtocol?
}

// MARK: - AddTaskPresenterProtocol
extension AddTaskPresenter: AddTaskPresenterInputProtocol {

    func saveTask(title: String, description: String?) {
        
        let newTask = TodoModel(
            id: Int64(Date().timeIntervalSince1970),
            title: title,
            taskDescription: description,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        
        interactor?.saveTask(newTask)
    }
    
    func cancelTask() {
        router?.dismissView()
    }
}

// MARK: - AddTaskInteractorOutputProtocol
extension AddTaskPresenter: AddTaskInteractorOutputProtocol {
    
    func didSaveTask(_ task: TodoModel) {
        if let viewController = view as? AddTaskViewController {
            viewController.delegate?.didAddTodo(task)
        }
        router?.dismissView()
    }
    
    func didFailToSaveTask(withError error: Error) {
        view?.showErrorMessage("Не удалось сохранить задачу: \(error.localizedDescription)")
    }
}
