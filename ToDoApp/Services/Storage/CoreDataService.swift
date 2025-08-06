//
//  CoreDataService.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataServiceProtocol {
    func saveTodos(_ todos: [TodoModel], completion: @escaping (Result<Void, Error>) -> Void)
    func fetchTodos(completion: @escaping (Result<[TodoModel], Error>) -> Void)
    func saveTodo(_ todo: TodoModel, completion: @escaping (Result<Void, Error>) -> Void)
    func updateTodo(_ todo: TodoModel, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTodo(withId id: Int64, completion: @escaping (Result<Void, Error>) -> Void)
    func searchTodos(with query: String, completion: @escaping (Result<[TodoModel], Error>) -> Void)
}

class CoreDataService: CoreDataServiceProtocol {
    
    private let persistentContainer: NSPersistentContainer

    // MARK: - Инициализация
    init(container: NSPersistentContainer? = nil) {
        if let externalContainer = container {
            self.persistentContainer = externalContainer
        } else {
            self.persistentContainer = NSPersistentContainer(name: "TodoModel")
            self.persistentContainer.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Core Data stack failed to load: \(error)")
                }
            }
        }
    }
    
    // MARK: - Сохранение нескольких задач (для первоначальной загрузки API)
    func saveTodos(_ todos: [TodoModel], completion: @escaping (Result<Void, Error>) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        
        context.perform {
            do {
                // Производим очистку хранилища от существующих задач (для первоначальной загрузки, на всякий случай)
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                let existingTodos = try context.fetch(fetchRequest)
                existingTodos.forEach { context.delete($0) }

                // Сохраняем новые задачи
                for todoModel in todos {
                    let entity = TodoEntity(context: context)
                    self.updateEntity(entity, with: todoModel)
                }

                try context.save()
                DispatchQueue.main.async { completion(.success(())) }

            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    // MARK: - Получить все задачи
    func fetchTodos(completion: @escaping (Result<[TodoModel], Error>) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        backgroundContext.perform {
            do {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                let entities = try backgroundContext.fetch(fetchRequest)
                let todos = entities.map { TodoModel(from: $0) }
                
                DispatchQueue.main.async {
                    completion(.success(todos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Сохранить одну задачу
    func saveTodo(_ todo: TodoModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        backgroundContext.perform {
            do {
                let entity = TodoEntity(context: backgroundContext)
                self.updateEntity(entity, with: todo)
                
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Обновить список задач
    func updateTodo(_ todo: TodoModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        backgroundContext.perform {
            do {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %lld", todo.id)
                
                let entities = try backgroundContext.fetch(fetchRequest)
                
                if let entity = entities.first {
                    self.updateEntity(entity, with: todo)
                    try backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "CoreDataService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"])))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Удалить задачу
    func deleteTodo(withId id: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        backgroundContext.perform {
            do {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
                
                let entities = try backgroundContext.fetch(fetchRequest)
                
                if let entity = entities.first {
                    backgroundContext.delete(entity)
                    try backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "CoreDataService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"])))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Поиск задач
    func searchTodos(with query: String, completion: @escaping (Result<[TodoModel], Error>) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        backgroundContext.perform {
            do {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                
                if !query.isEmpty {
                    let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
                    let descriptionPredicate = NSPredicate(format: "taskDescription CONTAINS[cd] %@", query)
                    fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, descriptionPredicate])
                }
                
                let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                let entities = try backgroundContext.fetch(fetchRequest)
                let todos = entities.map { TodoModel(from: $0) }
                
                DispatchQueue.main.async {
                    completion(.success(todos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Вспомогательный метод для обновления сущности задачи
    private func updateEntity(_ entity: TodoEntity, with todo: TodoModel) {
        entity.id = todo.id
        entity.title = todo.title
        entity.taskDescription = todo.taskDescription
        entity.createdAt = todo.createdAt
        entity.isCompleted = todo.isCompleted
        entity.userId = todo.userId
    }
}
