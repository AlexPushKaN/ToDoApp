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
    
    private var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save multiple todos (for initial API load)
    func saveTodos(_ todos: [TodoModel], completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        backgroundContext.perform {
            do {
                // Clear existing todos first (for initial load)
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoEntity.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try backgroundContext.execute(deleteRequest)
                
                // Save new todos
                for todoModel in todos {
                    let entity = TodoEntity(context: backgroundContext)
                    self.updateEntity(entity, with: todoModel)
                }
                
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
    
    // MARK: - Fetch all todos
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
    
    // MARK: - Save single todo
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
    
    // MARK: - Update todo
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
    
    // MARK: - Delete todo
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
    
    // MARK: - Search todos
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
    
    // MARK: - Helper method to update entity
    private func updateEntity(_ entity: TodoEntity, with todo: TodoModel) {
        entity.id = todo.id
        entity.title = todo.title
        entity.taskDescription = todo.taskDescription
        entity.createdAt = todo.createdAt
        entity.isCompleted = todo.isCompleted
        entity.userId = todo.userId
    }
}
