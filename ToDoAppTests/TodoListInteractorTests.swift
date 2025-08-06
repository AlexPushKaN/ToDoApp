//
//  TodoListInteractorTests.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

class TodoListInteractorTests: XCTestCase {

    var interactor: TodoListInteractor!
    var mockPresenter: MockTodoListPresenter!
    var mockAPIService: MockAPIService!
    var mockCoreDataService: MockCoreDataService!

    override func setUp() {
        super.setUp()
        interactor = TodoListInteractor()
        mockPresenter = MockTodoListPresenter()
        mockAPIService = MockAPIService()
        mockCoreDataService = MockCoreDataService()

        interactor.presenter = mockPresenter
        interactor.apiService = mockAPIService
        interactor.coreDataService = mockCoreDataService
    }

    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockAPIService = nil
        mockCoreDataService = nil
        super.tearDown()
    }

    func testFetchTodos_WhenCoreDataIsEmpty_FetchesFromAPI() {
        // Given
        mockCoreDataService.fetchTodosResult = .success([])
        let apiTodos = [Todo(id: 1, todo: "Test API Todo", completed: false, userId: 1)]
        mockAPIService.fetchTodosResult = .success(apiTodos)
        mockCoreDataService.saveTodosResult = .success(())

        // When
        interactor.fetchTodos()

        // Then
        XCTAssertTrue(mockCoreDataService.fetchTodosCalled)
        XCTAssertTrue(mockAPIService.fetchTodosCalled)
        XCTAssertTrue(mockCoreDataService.saveTodosCalled)
        XCTAssertTrue(mockPresenter.didFetchTodosCalled)
        XCTAssertEqual(Int(mockPresenter.fetchedTodos.first!.id), apiTodos.first?.id)
    }

    func testFetchTodos_WhenCoreDataHasData_ReturnsCoreData() {
        // Given
        let coreDataTodos = [TodoModel(
            id: 1,
            title: "Test CoreData Todo",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )]
        mockCoreDataService.fetchTodosResult = .success(coreDataTodos)

        // When
        interactor.fetchTodos()

        // Then
        XCTAssertTrue(mockCoreDataService.fetchTodosCalled)
        XCTAssertFalse(mockAPIService.fetchTodosCalled)
        XCTAssertTrue(mockPresenter.didFetchTodosCalled)
        XCTAssertEqual(mockPresenter.fetchedTodos.first?.id, coreDataTodos.first?.id)
    }

    func testFetchTodos_WhenCoreDataFails_FetchesFromAPI() {
        // Given
        mockCoreDataService.fetchTodosResult = .failure(NSError(domain: "CoreDataError", code: 0, userInfo: nil))
        let apiTodos = [Todo(id: 1, todo: "Test API Todo", completed: false, userId: 1)]
        mockAPIService.fetchTodosResult = .success(apiTodos)
        mockCoreDataService.saveTodosResult = .success(())

        // When
        interactor.fetchTodos()

        // Then
        XCTAssertTrue(mockCoreDataService.fetchTodosCalled)
        XCTAssertTrue(mockAPIService.fetchTodosCalled)
        XCTAssertTrue(mockCoreDataService.saveTodosCalled)
        XCTAssertTrue(mockPresenter.didFetchTodosCalled)
        XCTAssertEqual(Int(mockPresenter.fetchedTodos.first!.id), apiTodos.first?.id)
    }

    func testUpdateTodo_Success() {
        // Given
        let todoToUpdate = TodoModel(
            id: 1,
            title: "Update Me",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        mockCoreDataService.updateTodoResult = .success(())

        // When
        interactor.updateTodo(todoToUpdate)

        // Then
        XCTAssertTrue(mockCoreDataService.updateTodoCalled)
        XCTAssertEqual(mockCoreDataService.updatedTodo?.id, todoToUpdate.id)
    }

    func testDeleteTodo_Success() {
        // Given
        let todoToDelete = TodoModel(
            id: 1,
            title: "Delete Me",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        mockCoreDataService.deleteTodoResult = .success(())

        // When
        interactor.deleteTodo(todoToDelete)

        // Then
        XCTAssertTrue(mockCoreDataService.deleteTodoCalled)
        XCTAssertEqual(mockCoreDataService.deletedTodoId, todoToDelete.id)
        XCTAssertTrue(mockPresenter.didDeleteTodoOutputCalled)
        XCTAssertEqual(mockPresenter.deletedTodoId, todoToDelete.id)
    }

    func testDeleteTodo_Failure() {
        // Given
        let todoToDelete = TodoModel(
            id: 1,
            title: "Delete Me",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let deleteError = NSError(domain: "CoreDataError", code: 1, userInfo: nil)
        mockCoreDataService.deleteTodoResult = .failure(deleteError)

        // When
        interactor.deleteTodo(todoToDelete)

        // Then
        XCTAssertTrue(mockCoreDataService.deleteTodoCalled)
        XCTAssertEqual(mockCoreDataService.deletedTodoId, todoToDelete.id)
        XCTAssertTrue(mockPresenter.didFailToDeleteTodoOutputCalled)
        XCTAssertEqual((mockPresenter.deleteError as NSError?)?.code, deleteError.code)
    }

    func testSearchTodos_Success() {
        // Given
        let searchQuery = "test"
        let searchResults = [TodoModel(
            id: 1,
            title: "Test Todo",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )]
        mockCoreDataService.searchTodosResult = .success(searchResults)

        // When
        interactor.searchTodos(with: searchQuery)

        // Then
        XCTAssertTrue(mockCoreDataService.searchTodosCalled)
        XCTAssertEqual(mockCoreDataService.searchQuery, searchQuery)
        XCTAssertTrue(mockPresenter.didSearchTodosCalled)
        XCTAssertEqual(mockPresenter.searchedTodos.first?.id, searchResults.first?.id)
    }

    func testSearchTodos_Failure() {
        // Given
        let searchQuery = "test"
        let searchError = NSError(domain: "CoreDataError", code: 2, userInfo: nil)
        mockCoreDataService.searchTodosResult = .failure(searchError)

        // When
        interactor.searchTodos(with: searchQuery)

        // Then
        XCTAssertTrue(mockCoreDataService.searchTodosCalled)
        XCTAssertEqual(mockCoreDataService.searchQuery, searchQuery)
        XCTAssertTrue(mockPresenter.didFailToSearchTodosCalled)
        XCTAssertEqual((mockPresenter.searchError as NSError?)?.code, searchError.code)
    }
}
