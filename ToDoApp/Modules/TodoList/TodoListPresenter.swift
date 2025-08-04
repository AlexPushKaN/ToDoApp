//
//  TodoListPresenter.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import Foundation

class TodoListPresenter {
    
    // MARK: - VIPER
    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorInputProtocol?
    var router: TodoListRouterInputProtocol?
    
    // MARK: - Properties
    private var allTodos: [TodoModel] = []
    private var filteredTodos: [TodoModel] = []
    private var isSearching = false
}

// MARK: - TodoListPresenterProtocol
extension TodoListPresenter: TodoListPresenterInputProtocol {

    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchTodos()
    }
    
    func didSelectTodo(_ todo: TodoModel) {
        guard let view = view else { return }
    }
    
    func addTodo() {
        guard let view = view else { return }
        router?.presentAddTodoScreen(from: view)
    }
    
    func deleteTodo(_ todo: TodoModel) {
        view?.showLoading()
        interactor?.deleteTodo(todo)
    }
    
    func searchTodos(with query: String) {
        if query.isEmpty {
            isSearching = false
            view?.showTodos(allTodos)
        } else {
            isSearching = true
            interactor?.searchTodos(with: query)
        }
    }
    
    func didUpdateTodo(_ todo: TodoModel) {
        // Обновляем список дел в локальных массивах
        updateTodoInArrays(todo)
        
        // Показываем обновленные задачи и количество не выполненных задач
        let todosToShow = isSearching ? filteredTodos : allTodos
        showListAndAmountUnfinishedTasks(todosToShow)
    }
    
    func didAddTodo(_ todo: TodoModel) {
        // Добавляем задачу в локальные массивы
        // Вставляем ее в начало массивов, чтобы она отображалась в начале списка
        allTodos.insert(todo, at: 0)
        filteredTodos.insert(todo, at: 0)

        // Показываем обновленные задачи и количество не выполненных задач
        let todosToShow = isSearching ? filteredTodos : allTodos
        showListAndAmountUnfinishedTasks(todosToShow)
    }
    
    func didDeleteTodo(withId id: Int64) {
        // Удаляем задачу по id из локальных массивов
        allTodos.removeAll { $0.id == id }
        filteredTodos.removeAll { $0.id == id }
        
        // Показываем обновленные задачи и количество не выполненных задач
        let todosToShow = isSearching ? filteredTodos : allTodos
        showListAndAmountUnfinishedTasks(todosToShow)
    }
    
    // MARK: - Private Methods
    private func updateTodoInArrays(_ updatedTodo: TodoModel) {
        // Обновляем задачу в основном массиве
        if let index = allTodos.firstIndex(where: { $0.id == updatedTodo.id }) {
            allTodos[index] = updatedTodo
        }
        
        // Обновляем задачу в отфильтрованном массиве
        if let index = filteredTodos.firstIndex(where: { $0.id == updatedTodo.id }) {
            filteredTodos[index] = updatedTodo
        }
    }
    
    private func showListAndAmountUnfinishedTasks(_ todos: [TodoModel]) {
        // Показываем обновленные задачи и количество не выполненных задач
        view?.showTodos(todos)
        view?.showUnfinishedTodos(todos.filter { !$0.isCompleted }.count)
    }
}

// MARK: - TodoListInteractorOutputProtocol
extension TodoListPresenter: TodoListInteractorOutputProtocol {
    
    func didFetchTodos(_ todos: [TodoModel]) {
        allTodos = todos
        view?.hideLoading()
        view?.showTodos(todos)
        view?.showUnfinishedTodos(todos.filter { !$0.isCompleted }.count)
    }
    
    func didFailToFetchTodos(withError error: Error) {
        view?.hideLoading()
        view?.showErrorMessage("Не удалось загрузить задачи: \(error.localizedDescription)")
    }
    
    func didDeleteTodoOutput(withId id: Int64) {
        view?.hideLoading()
        didDeleteTodo(withId: id)
    }
    
    func didFailToDeleteTodo(withError error: Error) {
        view?.hideLoading()
        view?.showErrorMessage("Не удалось удалить задачу: \(error.localizedDescription)")
    }
    
    func didSearchTodos(_ todos: [TodoModel]) {
        filteredTodos = todos
        view?.showTodos(todos)
    }
    
    func didFailToSearchTodos(withError error: Error) {
        view?.showErrorMessage("Ошибка поиска: \(error.localizedDescription)")
    }
}
