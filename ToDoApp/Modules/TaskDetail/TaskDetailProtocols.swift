//
//  TaskDetailProtocols.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 05.08.2025.
//

import Foundation
import UIKit

// MARK: View Input
protocol TaskDetailViewInputProtocol: AnyObject {
    var presenter: TaskDetailPresenterInputProtocol? { get set }
    var delegate: TaskDetailViewControllerDelegate? { get set }
    
    func showTaskDetails(_ task: TodoModel)
    func showErrorMessage(_ message: String)
}

// MARK: Presenter Input
protocol TaskDetailPresenterInputProtocol: AnyObject {
    var view: TaskDetailViewInputProtocol? { get set }
    var interactor: TaskDetailInteractorInputProtocol? { get set }
    
    func viewDidLoad()
    func didUpdateTask(_ taskDescription: String)
}

// MARK: Interactor Input
protocol TaskDetailInteractorInputProtocol: AnyObject {
    var presenter: TaskDetailInteractorOutputProtocol? { get set }
    var coreDataService: CoreDataServiceProtocol? { get set }
    
    func updateTask(_ task: TodoModel)
}

// MARK: Interactor Output
protocol TaskDetailInteractorOutputProtocol: AnyObject {
    func didUpdateTaskOutput(_ task: TodoModel)
    func didFailToUpdateTask(withError error: Error)
}

// MARK: Router Input
protocol TaskDetailRouterInputProtocol: AnyObject {
    static func createModule(with task: TodoModel) -> UIViewController
}
