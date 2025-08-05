//
//  TodoListProtocols.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import Foundation
import UIKit

// MARK: View Input
protocol TodoListViewProtocol: AnyObject {
    var presenter: TodoListPresenterInputProtocol? { get set }
    
    func showTodos(_ todos: [TodoModel])
    func showUnfinishedTodos(_ amount: Int)
    func showErrorMessage(_ message: String)
    func showLoading()
    func hideLoading()
}

// MARK: Presenter Input
protocol TodoListPresenterInputProtocol: AnyObject {
    var view: TodoListViewProtocol? { get set }
    var interactor: TodoListInteractorInputProtocol? { get set }
    var router: TodoListRouterInputProtocol? { get set }
    
    func viewDidLoad()
    func didSelectTodo(_ todo: TodoModel)
    func addTodo()
    func deleteTodo(_ todo: TodoModel)
    func searchTodos(with query: String)
    func didUpdateTodo(_ todo: TodoModel)
    func didAddTodo(_ todo: TodoModel)
    func didDeleteTodo(withId id: Int64)
}

// MARK: Interactor Input
protocol TodoListInteractorInputProtocol: AnyObject {
    var presenter: TodoListInteractorOutputProtocol? { get set }
    var apiService: APIServiceProtocol? { get set }
    var coreDataService: CoreDataServiceProtocol? { get set }
    
    func fetchTodos()
    func updateTodo(_ todo: TodoModel)
    func deleteTodo(_ todo: TodoModel)
    func searchTodos(with query: String)
}

// MARK: Interactor Output
protocol TodoListInteractorOutputProtocol: AnyObject {
    func didFetchTodos(_ todos: [TodoModel])
    func didFailToFetchTodos(withError error: Error)
    func didDeleteTodo(withId id: Int64)
    func didFailToDeleteTodo(withError error: Error)
    func didSearchTodos(_ todos: [TodoModel])
    func didFailToSearchTodos(withError error: Error)
}

// MARK: Router Input
protocol TodoListRouterInputProtocol: AnyObject {
    static func createModule() -> UIViewController
    
    func presentAddTodoScreen(from view: TodoListViewProtocol)
    func presentTodoDetailScreen(from view: TodoListViewProtocol, for todo: TodoModel)
}
