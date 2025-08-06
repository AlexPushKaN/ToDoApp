//
//  CoreDataServiceTests.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
import CoreData
@testable import ToDoApp

class CoreDataServiceTests: XCTestCase {

    var coreDataService: CoreDataServiceProtocol!
    var mockPersistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        mockPersistentContainer = createMockPersistentContainer()
        coreDataService = CoreDataService(container: mockPersistentContainer)
        deleteAllObjectsManually()
    }

    override func tearDown() {
        clearAllEntities()
        coreDataService = nil
        mockPersistentContainer = nil
        super.tearDown()
    }

    // Помощник для создания постоянного контейнера в памяти для тестирования
    private func createMockPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "TodoModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            XCTAssertNil(error, "Failed to load persistent stores: \(error?.localizedDescription ?? "")")
        }
        return container
    }
    
    // Помощник для очистки всех сущностей из фиктивного постоянного хранилища
    private func clearAllEntities() {
        let context = mockPersistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            try context.save()
        } catch {
            XCTFail("Failed to clear entities: \(error)")
        }
    }
    
    private func deleteAllObjectsManually() {
        let context = mockPersistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                if let managedObject = object as? NSManagedObject {
                    context.delete(managedObject)
                }
            }
            try context.save()
        } catch {
            XCTFail("Manual delete failed: \(error)")
        }
    }

    func testSaveTodos_Success() {
        // Given
        let todosToSave = [
            TodoModel(
                id: 1,
                title: "Test Todo 1",
                taskDescription: nil,
                createdAt: Date(),
                isCompleted: false,
                userId: 1
            ),
            TodoModel(
                id: 2,
                title: "Test Todo 2",
                taskDescription: nil,
                createdAt: Date(),
                isCompleted: true,
                userId: 1
            ),
        ]
        let expectation = self.expectation(description: "Save multiple todos success")

        // When
        coreDataService.saveTodos(todosToSave) { result in
            // Then
            switch result {
            case .success:
                self.coreDataService.fetchTodos { fetchResult in
                    switch fetchResult {
                    case .success(let fetchedTodos):
                        XCTAssertEqual(fetchedTodos.count, 2)
                        XCTAssertTrue(fetchedTodos.contains(where: { $0.id == 1 }))
                        XCTAssertTrue(fetchedTodos.contains(where: { $0.id == 2 }))
                    case .failure(let error):
                        XCTFail("Failed to fetch todos after saving: \(error)")
                    }
                    expectation.fulfill()
                }
            case .failure(let error):
                XCTFail("Save todos failed with error: \(error)")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchTodos_Success() {
        // Given
        let todo1 = TodoModel(
            id: 1,
            title: "Fetch Todo 1",
            taskDescription: nil,
            createdAt: Date().addingTimeInterval(-100),
            isCompleted: false,
            userId: 1
        )
        let todo2 = TodoModel(
            id: 2,
            title: "Fetch Todo 2",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: true,
            userId: 1
        )
        let todosToSave = [todo1, todo2]
        
        let saveExpectation = self.expectation(description: "Save todos for fetch")
        coreDataService.saveTodos(todosToSave) { _ in saveExpectation.fulfill() }
        waitForExpectations(timeout: 1, handler: nil)

        let fetchExpectation = self.expectation(description: "Fetch todos success")

        // When
        coreDataService.fetchTodos { result in
            // Then
            switch result {
            case .success(let fetchedTodos):
                XCTAssertEqual(fetchedTodos.count, 2)
                XCTAssertEqual(fetchedTodos.first?.id, todo2.id, "Todos should be sorted by createdAt descending")
                XCTAssertEqual(fetchedTodos.last?.id, todo1.id)
            case .failure(let error):
                XCTFail("Fetch todos failed with error: \(error)")
            }
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSaveTodo_Success() {
        // Given
        let todoToSave = TodoModel(
            id: 3,
            title: "Single Todo",
            taskDescription: "Description",
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let expectation = self.expectation(description: "Save single todo success")

        // When
        coreDataService.saveTodo(todoToSave) { result in
            // Then
            switch result {
            case .success:
                self.coreDataService.fetchTodos { fetchResult in
                    switch fetchResult {
                    case .success(let fetchedTodos):
                        XCTAssertEqual(fetchedTodos.count, 1)
                        XCTAssertEqual(fetchedTodos.first?.id, todoToSave.id)
                    case .failure(let error):
                        XCTFail("Failed to fetch todos after saving single: \(error)")
                    }
                    expectation.fulfill()
                }
            case .failure(let error):
                XCTFail("Save single todo failed with error: \(error)")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testUpdateTodo_Success() {
        // Given
        let initialTodo = TodoModel(
            id: 4,
            title: "Original Title",
            taskDescription: "Original Description",
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let saveExpectation = self.expectation(description: "Save initial todo for update")
        coreDataService.saveTodo(initialTodo) { _ in saveExpectation.fulfill() }
        waitForExpectations(timeout: 1, handler: nil)

        let updatedTodo = TodoModel(
            id: 4,
            title: "Updated Title",
            taskDescription: "Updated Description",
            createdAt: Date(),
            isCompleted: true,
            userId: 1
        )
        let updateExpectation = self.expectation(description: "Update todo success")

        // When
        coreDataService.updateTodo(updatedTodo) { result in
            // Then
            switch result {
            case .success:
                self.coreDataService.fetchTodos { fetchResult in
                    switch fetchResult {
                    case .success(let fetchedTodos):
                        XCTAssertEqual(fetchedTodos.count, 1)
                        XCTAssertEqual(fetchedTodos.first?.title, updatedTodo.title)
                        XCTAssertEqual(fetchedTodos.first?.isCompleted, updatedTodo.isCompleted)
                        XCTAssertEqual(fetchedTodos.first?.taskDescription, updatedTodo.taskDescription)
                    case .failure(let error):
                        XCTFail("Failed to fetch todos after update: \(error)")
                    }
                    updateExpectation.fulfill()
                }
            case .failure(let error):
                XCTFail("Update todo failed with error: \(error)")
                updateExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testUpdateTodo_NotFound() {
        // Given
        let nonExistentTodo = TodoModel(
            id: 99,
            title: "Non Existent",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let expectation = self.expectation(description: "Update non-existent todo")

        // When
        coreDataService.updateTodo(nonExistentTodo) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Update should fail for non-existent todo")
            case .failure(let error):
                let nsError = error as NSError
                XCTAssertEqual(nsError.domain, "CoreDataService")
                XCTAssertEqual(nsError.code, 404)
                XCTAssertEqual(nsError.localizedDescription, "Todo not found")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDeleteTodo_Success() {
        // Given
        let todoToDelete = TodoModel(
            id: 5,
            title: "Delete Me",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let saveExpectation = self.expectation(description: "Save todo for delete")
        coreDataService.saveTodo(todoToDelete) { _ in saveExpectation.fulfill() }
        waitForExpectations(timeout: 1, handler: nil)

        let deleteExpectation = self.expectation(description: "Delete todo success")

        // When
        coreDataService.deleteTodo(withId: todoToDelete.id) { result in
            // Then
            switch result {
            case .success:
                self.coreDataService.fetchTodos { fetchResult in
                    switch fetchResult {
                    case .success(let fetchedTodos):
                        XCTAssertTrue(fetchedTodos.isEmpty)
                    case .failure(let error):
                        XCTFail("Failed to fetch todos after delete: \(error)")
                    }
                    deleteExpectation.fulfill()
                }
            case .failure(let error):
                XCTFail("Delete todo failed with error: \(error)")
                deleteExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDeleteTodo_NotFound() {
        // Given
        let nonExistentId: Int64 = 999
        let expectation = self.expectation(description: "Delete non-existent todo")

        // When
        coreDataService.deleteTodo(withId: nonExistentId) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Delete should fail for non-existent todo")
            case .failure(let error):
                let nsError = error as NSError
                XCTAssertEqual(nsError.domain, "CoreDataService")
                XCTAssertEqual(nsError.code, 404)
                XCTAssertEqual(nsError.localizedDescription, "Todo not found")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSearchTodos_ByTitle() {
        // Given
        let todo1 = TodoModel(
            id: 6,
            title: "Buy groceries",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let todo2 = TodoModel(
            id: 7,
            title: "Walk the dog",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let todo3 = TodoModel(
            id: 8,
            title: "Read a book",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let todosToSave = [todo1, todo2, todo3]
        
        let saveExpectation = self.expectation(description: "Save todos for search")
        coreDataService.saveTodos(todosToSave) { _ in saveExpectation.fulfill() }
        waitForExpectations(timeout: 1, handler: nil)

        let searchExpectation = self.expectation(description: "Search todos by title")

        // When
        coreDataService.searchTodos(with: "groceries") { result in
            // Then
            switch result {
            case .success(let fetchedTodos):
                XCTAssertEqual(fetchedTodos.count, 1)
                XCTAssertEqual(fetchedTodos.first?.id, todo1.id)
            case .failure(let error):
                XCTFail("Search todos failed with error: \(error)")
            }
            searchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSearchTodos_ByDescription() {
        // Given
        let todo1 = TodoModel(
            id: 9,
            title: "Task A",
            taskDescription: "This is a task about coding",
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let todo2 = TodoModel(
            id: 10,
            title: "Task B",
            taskDescription: "Go for a run",
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let todosToSave = [todo1, todo2]
        
        let saveExpectation = self.expectation(description: "Save todos for search by description")
        coreDataService.saveTodos(todosToSave) { _ in saveExpectation.fulfill() }
        waitForExpectations(timeout: 1, handler: nil)

        let searchExpectation = self.expectation(description: "Search todos by description")

        // When
        coreDataService.searchTodos(with: "coding") { result in
            // Then
            switch result {
            case .success(let fetchedTodos):
                XCTAssertEqual(fetchedTodos.count, 1)
                XCTAssertEqual(fetchedTodos.first?.id, todo1.id)
            case .failure(let error):
                XCTFail("Search todos failed with error: \(error)")
            }
            searchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSearchTodos_NoMatch() {
        // Given
        let todo1 = TodoModel(
            id: 11,
            title: "Task X",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let todosToSave = [todo1]
        
        let saveExpectation = self.expectation(description: "Save todos for no match search")
        coreDataService.saveTodos(todosToSave) { _ in saveExpectation.fulfill() }
        waitForExpectations(timeout: 1, handler: nil)

        let searchExpectation = self.expectation(description: "Search todos no match")

        // When
        coreDataService.searchTodos(with: "nonexistent") { result in
            // Then
            switch result {
            case .success(let fetchedTodos):
                XCTAssertTrue(fetchedTodos.isEmpty)
            case .failure(let error):
                XCTFail("Search todos failed with error: \(error)")
            }
            searchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSearchTodos_EmptyQueryReturnsAll() {
        // Given
        let todo1 = TodoModel(
            id: 12,
            title: "Task Y",
            taskDescription: nil,
            createdAt: Date().addingTimeInterval(-100),
            isCompleted: false,
            userId: 1
        )
        let todo2 = TodoModel(
            id: 13,
            title: "Task Z",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let todosToSave = [todo1, todo2]
        
        let saveExpectation = self.expectation(description: "Save todos for empty query search")
        coreDataService.saveTodos(todosToSave) { _ in saveExpectation.fulfill() }
        waitForExpectations(timeout: 1, handler: nil)

        let searchExpectation = self.expectation(description: "Search todos empty query")

        // When
        coreDataService.searchTodos(with: "") { result in
            // Then
            switch result {
            case .success(let fetchedTodos):
                XCTAssertEqual(fetchedTodos.count, 2)
                XCTAssertEqual(fetchedTodos.first?.id, todo2.id)
                XCTAssertEqual(fetchedTodos.last?.id, todo1.id)
            case .failure(let error):
                XCTFail("Search todos failed with error: \(error)")
            }
            searchExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
