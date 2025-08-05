//
//  TaskDetailPresenter.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 05.08.2025.
//

import Foundation

class TaskDetailPresenter {
    
    // MARK: - VIPER
    weak var view: TaskDetailViewInputProtocol?
    var interactor: TaskDetailInteractorInputProtocol?
    
    // MARK: - Свойства
    private var currentTask: TodoModel?
    
    // MARK: - Инициализация
    init(task: TodoModel) {
        self.currentTask = task
    }
}

// MARK: - TaskDetailPresenterProtocol
extension TaskDetailPresenter: TaskDetailPresenterInputProtocol {
    
    func viewDidLoad() {
        guard let task = currentTask else { return }
        view?.showTaskDetails(task)
    }

    func didUpdateTask(_ taskDescription: String) {
        guard let task = currentTask else { return }
        
        let updateTask = TodoModel(
            id: task.id,
            title: task.title,
            taskDescription: taskDescription,
            createdAt: task.createdAt,
            isCompleted: task.isCompleted,
            userId: task.userId)
        
        interactor?.updateTask(updateTask)
    }
}

// MARK: - TaskDetailInteractorOutputProtocol
extension TaskDetailPresenter: TaskDetailInteractorOutputProtocol {
    
    func didUpdateTaskOutput(_ task: TodoModel) {
        view?.delegate?.didUpdateTodo(task)
    }
    
    func didFailToUpdateTask(withError error: Error) {
        view?.showErrorMessage("Не удалось обновить задачу: \(error.localizedDescription)")
    }
}
