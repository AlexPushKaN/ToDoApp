//
//  TaskDetailRouter.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 05.08.2025.
//

import UIKit

class TaskDetailRouter {
    
    weak var viewController: UIViewController?
}

// MARK: - TaskDetailRouterProtocol
extension TaskDetailRouter: TaskDetailRouterInputProtocol {
    
    static func createModule(with task: TodoModel) -> UIViewController {
        let view = TaskDetailViewController()
        let presenter = TaskDetailPresenter(task: task)
        let interactor = TaskDetailInteractor()
        let router = TaskDetailRouter()
        
        // Инъекция зависимостей
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.coreDataService = CoreDataService()
        router.viewController = view
        
        return view
    }
}
