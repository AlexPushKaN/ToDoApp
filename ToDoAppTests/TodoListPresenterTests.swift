//
//  TodoListPresenterTests.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

class TodoListPresenterTests: XCTestCase {

    var presenter: TodoListPresenter!
    var mockView: MockTodoListView!
    var mockInteractor: MockTodoListInteractor!
    var mockRouter: MockTodoListRouter!

    override func setUp() {
        super.setUp()
        presenter = TodoListPresenter()
        mockView = MockTodoListView()
        mockInteractor = MockTodoListInteractor()
        mockRouter = MockTodoListRouter()

        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        // When
        presenter.viewDidLoad()

        // Then
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockInteractor.fetchTodosCalled)
    }

    func testDidSelectTodo() {
        // Given
        let todo = TodoModel(
            id: 1,
            title: "Test Todo",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        // When
        presenter.didSelectTodo(todo)

        // Then
        XCTAssertTrue(mockRouter.presentTodoDetailScreenCalled)
        XCTAssertEqual(mockRouter.presentedTodo?.id, todo.id)
    }

    func testAddTodo() {
        // When
        presenter.addTodo()

        // Then
        XCTAssertTrue(mockRouter.presentAddTodoScreenCalled)
    }

    func testDeleteTodo() {
        // Given
        let todo = TodoModel(
            id: 1,
            title: "Test Todo",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        // When
        presenter.deleteTodo(todo)

        // Then
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockInteractor.deleteTodoCalled)
        XCTAssertEqual(mockInteractor.deletedTodo?.id, todo.id)
    }

    func testSearchTodos_WithQuery() {
        // Given
        let query = "test"

        // When
        presenter.searchTodos(with: query)

        // Then
        XCTAssertTrue(mockInteractor.searchTodosCalled)
        XCTAssertEqual(mockInteractor.searchQuery, query)
    }

    func testSearchTodos_EmptyQuery() {
        // Given
        let todos = [TodoModel(
            id: 1,
            title: "Test Todo",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )]
        presenter.didFetchTodos(todos) // Имитация первоначальной выборки

        // When
        presenter.searchTodos(with: "")

        // Then
        XCTAssertFalse(mockInteractor.searchTodosCalled)
        XCTAssertTrue(mockView.showTodosCalled)
        XCTAssertEqual(mockView.todos?.first?.id, todos.first?.id)
    }

    func testDidUpdateTodo() {
        // Given
        let initialTodos = [TodoModel(
            id: 1,
            title: "Old Title",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )]
        presenter.didFetchTodos(initialTodos)
        let updatedTodo = TodoModel(
            id: 1,
            title: "New Title",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: true,
            userId: 1
        )

        // When
        presenter.didUpdateTodo(updatedTodo)

        // Then
        XCTAssertTrue(mockView.showTodosCalled)
        XCTAssertEqual(mockView.todos?.first?.title, updatedTodo.title)
        XCTAssertTrue(mockView.showUnfinishedTodosCalled)
        XCTAssertEqual(mockView.unfinishedAmount, 0)
    }

    func testDidAddTodo() {
        // Given
        let newTodo = TodoModel(
            id: 2,
            title: "New Todo",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )

        // When
        presenter.didAddTodo(newTodo)

        // Then
        XCTAssertTrue(mockView.showTodosCalled)
        XCTAssertEqual(mockView.todos?.first?.id, newTodo.id)
        XCTAssertTrue(mockView.showUnfinishedTodosCalled)
        XCTAssertEqual(mockView.unfinishedAmount, 1)
    }

    func testDidDeleteTodo() {
        // Given
        let initialTodos = [TodoModel(
            id: 1,
            title: "Test Todo",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )]
        presenter.didFetchTodos(initialTodos)

        // When
        presenter.didDeleteTodo(withId: 1)

        // Then
        XCTAssertTrue(mockView.showTodosCalled)
        XCTAssertTrue(mockView.todos?.isEmpty ?? false)
        XCTAssertTrue(mockView.showUnfinishedTodosCalled)
        XCTAssertEqual(mockView.unfinishedAmount, 0)
    }

    func testDidTapEditAction() {
        // Given
        let todo = TodoModel(
            id: 1,
            title: "Test Todo",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )

        // When
        presenter.didTapEditAction(for: todo)

        // Then
        XCTAssertTrue(mockRouter.presentTodoDetailScreenCalled)
        XCTAssertEqual(mockRouter.presentedTodo?.id, todo.id)
    }

    func testDidTapDeleteAction() {
        // Given
        let todo = TodoModel(
            id: 1,
            title: "Test Todo",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )

        // When
        presenter.didTapDeleteAction(for: todo)

        // Then
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockInteractor.deleteTodoCalled)
        XCTAssertEqual(mockInteractor.deletedTodo?.id, todo.id)
    }

    func testDidFetchTodos() {
        // Given
        let todos = [TodoModel(
            id: 1,
            title: "Test Todo",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )]

        // When
        presenter.didFetchTodos(todos)

        // Then
        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockView.showTodosCalled)
        XCTAssertEqual(mockView.todos?.first?.id, todos.first?.id)
        XCTAssertTrue(mockView.showUnfinishedTodosCalled)
        XCTAssertEqual(mockView.unfinishedAmount, 1)
    }

    func testDidFailToFetchTodos() {
        // Given
        let error = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fetch failed"])

        // When
        presenter.didFailToFetchTodos(withError: error)

        // Then
        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockView.showErrorMessageCalled)
        XCTAssertTrue(mockView.errorMessage?.contains("Fetch failed") ?? false)
    }

    func testDidDeleteTodoOutput() {
        // Given
        let initialTodos = [TodoModel(
            id: 1,
            title: "Test Todo",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )]
        presenter.didFetchTodos(initialTodos)

        // When
        presenter.didDeleteTodoOutput(withId: 1)

        // Then
        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockView.showTodosCalled)
        XCTAssertTrue(mockView.todos?.isEmpty ?? false)
        XCTAssertTrue(mockView.showUnfinishedTodosCalled)
        XCTAssertEqual(mockView.unfinishedAmount, 0)
    }

    func testDidFailToDeleteTodoOutput() {
        // Given
        let error = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Delete failed"])

        // When
        presenter.didFailToDeleteTodoOutput(withError: error)

        // Then
        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockView.showErrorMessageCalled)
        XCTAssertTrue(mockView.errorMessage?.contains("Delete failed") ?? false)
    }

    func testDidSearchTodos() {
        // Given
        let searchResults = [TodoModel(
            id: 1,
            title: "Search Result",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )]

        // When
        presenter.didSearchTodos(searchResults)

        // Then
        XCTAssertTrue(mockView.showTodosCalled)
        XCTAssertEqual(mockView.todos?.first?.id, searchResults.first?.id)
    }

    func testDidFailToSearchTodos() {
        // Given
        let error = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Search failed"])

        // When
        presenter.didFailToSearchTodos(withError: error)

        // Then
        XCTAssertTrue(mockView.showErrorMessageCalled)
        XCTAssertTrue(mockView.errorMessage?.contains("Search failed") ?? false)
    }
}
