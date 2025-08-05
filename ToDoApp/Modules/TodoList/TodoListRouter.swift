//
//  TodoListRouter.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import UIKit

class TodoListRouter {
    
    weak var viewController: UIViewController?
}

// MARK: - TodoListRouterProtocol
extension TodoListRouter: TodoListRouterInputProtocol {
    
    static func createModule() -> UIViewController {
        let view = TodoListViewController()
        let presenter = TodoListPresenter()
        let interactor = TodoListInteractor()
        let router = TodoListRouter()
        
        // Инъекция зависимостей
        view.presenter = presenter
        view.actionMenuService = ActionMenuService()
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.apiService = APIService()
        interactor.coreDataService = CoreDataService()
        router.viewController = view
        
        return view
    }
    
    func presentAddTodoScreen(from view: TodoListViewProtocol) {
        guard let viewController = viewController else { return }
        
        let addTodoModule = AddTaskRouter.createModule()
        
        if let addTaskVC = addTodoModule as? AddTaskViewController,
           let presenter = (view as? TodoListViewController)?.presenter {
            addTaskVC.delegate = AddTaskDelegate(presenter: presenter)
        }
        
        let navigationController = UINavigationController(rootViewController: addTodoModule)
        viewController.present(navigationController, animated: true)
    }
    
    func presentTodoDetailScreen(from view: TodoListViewProtocol, for todo: TodoModel) {
        guard let viewController = viewController else { return }
        
        let detailModule = TaskDetailRouter.createModule(with: todo)
        
        if let detailVC = detailModule as? TaskDetailViewController,
           let presenter = (view as? TodoListViewController)?.presenter {
            detailVC.delegate = TaskDetailDelegate(presenter: presenter)
        }
        
        viewController.navigationController?.pushViewController(detailModule, animated: true)
    }
}

// MARK: - Helper Delegates
class AddTaskDelegate: AddTaskViewControllerDelegate {
    weak var presenter: TodoListPresenterInputProtocol?
    
    init(presenter: TodoListPresenterInputProtocol) {
        self.presenter = presenter
    }
    
    func didAddTodo(_ todo: TodoModel) {
        presenter?.didAddTodo(todo)
    }
}

class TaskDetailDelegate: TaskDetailViewControllerDelegate {
    weak var presenter: TodoListPresenterInputProtocol?
    
    init(presenter: TodoListPresenterInputProtocol) {
        self.presenter = presenter
    }
    
    func didUpdateTodo(_ todo: TodoModel) {
        presenter?.didUpdateTodo(todo)
    }
}
