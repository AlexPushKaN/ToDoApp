//
//  AddTaskRouter.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import UIKit

class AddTaskRouter {
    
    weak var viewController: UIViewController?
}

// MARK: - AddTaskRouterProtocol
extension AddTaskRouter: AddTaskRouterInputProtocol {
    
    static func createModule() -> UIViewController {
        let view = AddTaskViewController()
        let presenter = AddTaskPresenter()
        let interactor = AddTaskInteractor()
        let router = AddTaskRouter()
        
        // Инъекция зависимостей
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.coreDataService = CoreDataService()
        router.viewController = view
        
        return view
    }

    func dismissView() {
        DispatchQueue.main.async {
            self.viewController?.dismiss(animated: true)
        }
    }
}
