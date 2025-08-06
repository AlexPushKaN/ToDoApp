//
//  AddTaskPresenterTests.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

class AddTaskPresenterTests: XCTestCase {

    var presenter: AddTaskPresenter!
    var mockView: MockAddTaskView!
    var mockInteractor: MockAddTaskInteractor!
    var mockRouter: MockAddTaskRouter!
    var mockDelegate: MockAddTaskDelegate!

    override func setUp() {
        super.setUp()
        presenter = AddTaskPresenter()
        mockView = MockAddTaskView()
        mockInteractor = MockAddTaskInteractor()
        mockRouter = MockAddTaskRouter()
        mockDelegate = MockAddTaskDelegate()

        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
        mockView.delegate = mockDelegate
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func testSaveTask() {
        // Given
        let title = "Test Task"
        let description = "Test Description"

        // When
        presenter.saveTask(title: title, description: description)

        // Then
        XCTAssertTrue(mockInteractor.saveTaskCalled)
        XCTAssertEqual(mockInteractor.savedTask?.title, title)
        XCTAssertEqual(mockInteractor.savedTask?.taskDescription, description)
    }

    func testCancelTask() {
        // When
        presenter.cancelTask()

        // Then
        XCTAssertTrue(mockRouter.dismissViewCalled)
    }

    func testDidSaveTask_Success() {
        // Given
        let savedTask = TodoModel(
            id: 1,
            title: "Saved Task",
            taskDescription: nil,
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        // When
        presenter.didSaveTask(savedTask)

        // Then
        XCTAssertTrue(mockRouter.dismissViewCalled)
    }

    func testDidFailToSaveTask() {
        // Given
        let error = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Save failed"])

        // When
        presenter.didFailToSaveTask(withError: error)

        // Then
        XCTAssertTrue(mockView.showErrorMessageCalled)
        XCTAssertTrue(mockView.errorMessage?.contains("Save failed") ?? false)
    }
}
