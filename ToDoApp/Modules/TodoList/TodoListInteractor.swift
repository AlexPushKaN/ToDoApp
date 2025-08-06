//
//  TodoListInteractor.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import Foundation

class TodoListInteractor {
    
    // MARK: - VIPER
    weak var presenter: TodoListInteractorOutputProtocol?
    var apiService: APIServiceProtocol?
    var coreDataService: CoreDataServiceProtocol?
    
    // MARK: - Свойства
    private var hasLoadedFromAPI = false
}

// MARK: - TodoListInteractorInputProtocol
extension TodoListInteractor: TodoListInteractorInputProtocol {
    
    func fetchTodos() {
        // Пытаемся получить данные с хранилища,
        coreDataService?.fetchTodos { [weak self] result in
            switch result {
            case .success(let todos):
                if todos.isEmpty && !(self?.hasLoadedFromAPI ?? false) {
                    // Если в хранилище нет данных, берем их у API
                    self?.fetchTodosFromAPI()
                } else {
                    // Передаем локальные данные
                    self?.presenter?.didFetchTodos(todos)
                }
            case .failure(_):
                // Если получаем ошибку, запрашиваем данные у API
                self?.fetchTodosFromAPI()
            }
        }
    }
    
    func updateTodo(_ todo: TodoModel) {
        coreDataService?.updateTodo(todo) { result in
            switch result {
            case .success:
                print("Todo успешно обновлено")
            case .failure(let error):
                print("Не удалось обновить todo из-за ошибки: \(error)")
            }
        }
    }
    
    func deleteTodo(_ todo: TodoModel) {
        coreDataService?.deleteTodo(withId: todo.id) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didDeleteTodoOutput(withId: todo.id)
            case .failure(let error):
                self?.presenter?.didFailToDeleteTodoOutput(withError: error)
            }
        }
    }
    
    func searchTodos(with query: String) {
        coreDataService?.searchTodos(with: query) { [weak self] result in
            switch result {
            case .success(let todos):
                self?.presenter?.didSearchTodos(todos)
            case .failure(let error):
                self?.presenter?.didFailToSearchTodos(withError: error)
            }
        }
    }
    
    // MARK: - Private Methods
    private func fetchTodosFromAPI() {
        apiService?.fetchTodos { [weak self] result in
            switch result {
            case .success(let apiTodos):
                // Конвертируем задачи с API в локальные модели
                let todoModels = apiTodos.map { apiTodo in
                    TodoModel(from: apiTodo, description: nil, createdAt: Date())
                }
                
                // Сохраняем в локальное хранилище
                self?.coreDataService?.saveTodos(todoModels) { saveResult in
                    switch saveResult {
                    case .success:
                        self?.hasLoadedFromAPI = true
                        self?.presenter?.didFetchTodos(todoModels)
                    case .failure(let error):
                        // Если сохранение данных не удалось, все равно показываем их юзеру
                        self?.presenter?.didFetchTodos(todoModels)
                        print("Не удалось сохранить данные в хранилище из-за ошибки: \(error)")
                    }
                }
                
            case .failure(let error):
                self?.presenter?.didFailToFetchTodos(withError: error)
            }
        }
    }
}
