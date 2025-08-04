//
//  AddTaskProtocols.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import Foundation
import UIKit

// MARK: View Input
protocol AddTaskViewInputProtocol: AnyObject {
    var presenter: AddTaskPresenterInputProtocol? { get set }

    func showErrorMessage(_ message: String)
}

// MARK: Presenter Input
protocol AddTaskPresenterInputProtocol: AnyObject {
    var view: AddTaskViewInputProtocol? { get set }
    var interactor: AddTaskInteractorInputProtocol? { get set }
    var router: AddTaskRouterInputProtocol? { get set }
    
    func saveTask(title: String, description: String?)
    func cancelTask()
}

// MARK: Interactor Input
protocol AddTaskInteractorInputProtocol: AnyObject {
    var presenter: AddTaskInteractorOutputProtocol? { get set }
    var coreDataService: CoreDataServiceProtocol? { get set }
    
    func saveTask(_ task: TodoModel)
}

// MARK: Interactor Output
protocol AddTaskInteractorOutputProtocol: AnyObject {
    func didSaveTask(_ task: TodoModel)
    func didFailToSaveTask(withError error: Error)
}

// MARK: Router Input
protocol AddTaskRouterInputProtocol: AnyObject {
    static func createModule() -> UIViewController

    func dismissView()
}
