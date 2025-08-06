//
//  TaskDetailPresenterTests.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

class TaskDetailPresenterTests: XCTestCase {

    var presenter: TaskDetailPresenter!
    var mockView: MockTaskDetailView!
    var mockInteractor: MockTaskDetailInteractor!
    var mockDelegate: MockTaskDetailDelegate!

    override func setUp() {
        super.setUp()
        let initialTask = TodoModel(
            id: 1,
            title: "Initial Task",
            taskDescription: "Initial description",
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        presenter = TaskDetailPresenter(task: initialTask)
        mockView = MockTaskDetailView()
        mockInteractor = MockTaskDetailInteractor()
        mockDelegate = MockTaskDetailDelegate()

        presenter.view = mockView
        presenter.interactor = mockInteractor
        mockView.delegate = mockDelegate
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        // When
        presenter.viewDidLoad()

        // Then
        XCTAssertTrue(mockView.showTaskDetailsCalled)
        XCTAssertEqual(mockView.displayedTask?.id, 1)
        XCTAssertEqual(mockView.displayedTask?.title, "Initial Task")
    }

    func testDidUpdateTask() {
        // Given
        let newDescription = "Updated description for task"

        // When
        presenter.didUpdateTask(newDescription)

        // Then
        XCTAssertTrue(mockInteractor.updateTaskCalled)
        XCTAssertEqual(mockInteractor.updatedTask?.taskDescription, newDescription)
        XCTAssertEqual(mockInteractor.updatedTask?.id, 1)
    }

    func testDidUpdateTaskOutput_Success() {
        // Given
        let updatedTask = TodoModel(
            id: 1,
            title: "Initial Task",
            taskDescription: "Updated description",
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        // When
        presenter.didUpdateTaskOutput(updatedTask)

        // Then
        XCTAssertTrue(mockDelegate.didUpdateTodoCalled)
        XCTAssertEqual(mockDelegate.receivedTodo?.id, updatedTask.id)
    }

    func testDidFailToUpdateTask() {
        // Given
        let error = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Update failed"])

        // When
        presenter.didFailToUpdateTask(withError: error)

        // Then
        XCTAssertTrue(mockView.showErrorMessageCalled)
        XCTAssertTrue(mockView.errorMessage?.contains("Update failed") ?? false)
    }
}
