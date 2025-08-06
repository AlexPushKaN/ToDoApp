//
//  AddTaskInteractorTests.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

class AddTaskInteractorTests: XCTestCase {

    var interactor: AddTaskInteractor!
    var mockPresenter: MockAddTaskPresenter!
    var mockCoreDataService: MockCoreDataService!

    override func setUp() {
        super.setUp()
        interactor = AddTaskInteractor()
        mockPresenter = MockAddTaskPresenter()
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

    func testSaveTask_Success() {
        // Given
        let taskToSave = TodoModel(
            id: 1,
            title: "New Task",
            taskDescription: "Task description",
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        mockCoreDataService.saveTodoResult = .success(())

        // When
        interactor.saveTask(taskToSave)

        // Then
        XCTAssertTrue(mockCoreDataService.saveTodoCalled)
        XCTAssertEqual(mockCoreDataService.savedTodo?.id, taskToSave.id)
        XCTAssertEqual(mockCoreDataService.savedTodo?.title, taskToSave.title)
        XCTAssertTrue(mockPresenter.didSaveTaskCalled)
        XCTAssertEqual(mockPresenter.savedTask?.id, taskToSave.id)
    }

    func testSaveTask_Failure() {
        // Given
        let taskToSave = TodoModel(
            id: 1,
            title: "New Task",
            taskDescription: "Task description",
            createdAt: Date(),
            isCompleted: false,
            userId: 1
        )
        let saveError = NSError(domain: "CoreDataError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to save task"])
        mockCoreDataService.saveTodoResult = .failure(saveError)

        // When
        interactor.saveTask(taskToSave)

        // Then
        XCTAssertTrue(mockCoreDataService.saveTodoCalled)
        XCTAssertEqual(mockCoreDataService.savedTodo?.id, taskToSave.id)
        XCTAssertTrue(mockPresenter.didFailToSaveTaskCalled)
        XCTAssertEqual((mockPresenter.saveError as NSError?)?.code, saveError.code)
        XCTAssertEqual((mockPresenter.saveError as NSError?)?.localizedDescription, saveError.localizedDescription)
    }
}
