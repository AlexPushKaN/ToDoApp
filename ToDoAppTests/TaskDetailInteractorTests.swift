//
//  TaskDetailInteractorTests.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

class TaskDetailInteractorTests: XCTestCase {

    var interactor: TaskDetailInteractor!
    var mockPresenter: MockTaskDetailPresenter!
    var mockCoreDataService: MockCoreDataService!

    override func setUp() {
        super.setUp()
        interactor = TaskDetailInteractor()
        mockPresenter = MockTaskDetailPresenter()
        mockCoreDataService = MockCoreDataService()

        interactor.presenter = mockPresenter
        interactor.coreDataService = mockCoreDataService
    }

    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockCoreDataService = nil
        super.tearDown()
    }

    func testUpdateTask_Success() {
        // Given
        let taskToUpdate = TodoModel(
            id: 1,
            title: "Updated Task",
            taskDescription: "Updated description",
            createdAt: Date(),
            isCompleted: true,
            userId: 1
        )
        mockCoreDataService.updateTodoResult = .success(())

        // When
        interactor.updateTask(taskToUpdate)

        // Then
        XCTAssertTrue(mockCoreDataService.updateTodoCalled)
        XCTAssertEqual(mockCoreDataService.updatedTodo?.id, taskToUpdate.id)
        XCTAssertEqual(mockCoreDataService.updatedTodo?.title, taskToUpdate.title)
        XCTAssertEqual(mockCoreDataService.updatedTodo?.isCompleted, taskToUpdate.isCompleted)
        XCTAssertTrue(mockPresenter.didUpdateTaskOutputCalled)
        XCTAssertEqual(mockPresenter.updatedTask?.id, taskToUpdate.id)
    }

    func testUpdateTask_Failure() {
        // Given
        let taskToUpdate = TodoModel(
            id: 1,
            title: "Updated Task",
            taskDescription: "Updated description",
            createdAt: Date(),
            isCompleted: true,
            userId: 1
        )
        let updateError = NSError(domain: "CoreDataError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update task"])
        mockCoreDataService.updateTodoResult = .failure(updateError)

        // When
        interactor.updateTask(taskToUpdate)

        // Then
        XCTAssertTrue(mockCoreDataService.updateTodoCalled)
        XCTAssertEqual(mockCoreDataService.updatedTodo?.id, taskToUpdate.id)
        XCTAssertTrue(mockPresenter.didFailToUpdateTaskCalled)
        XCTAssertEqual((mockPresenter.updateError as NSError?)?.code, updateError.code)
        XCTAssertEqual((mockPresenter.updateError as NSError?)?.localizedDescription, updateError.localizedDescription)
    }
}
