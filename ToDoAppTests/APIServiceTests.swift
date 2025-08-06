//
//  APIServiceTests.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

class APIServiceTests: XCTestCase {

    var apiService: MockAPIService!

    override func setUp() {
        super.setUp()
        apiService = MockAPIService()
    }

    override func tearDown() {
        apiService = nil
        super.tearDown()
    }

    func testFetchTodos_Success() {
        // Given
        let expectation = self.expectation(description: "Fetch todos success")

        let mockTodos = [
            Todo(id: 1, todo: "Test Todo 1", completed: false, userId: 1),
            Todo(id: 2, todo: "Test Todo 2", completed: true, userId: 2)
        ]

        apiService.fetchTodosResult = .success(mockTodos)

        // When
        apiService.fetchTodos { result in
            // Then
            switch result {
            case .success(let todos):
                XCTAssertEqual(todos.count, 2)
                XCTAssertEqual(todos.first?.id, 1)
                XCTAssertEqual(todos.first?.todo, "Test Todo 1")
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testFetchTodos_InvalidURL() {
        // Given
        let expectation = self.expectation(description: "Fetch todos invalid URL")

        apiService.fetchTodosResult = .failure(APIError.invalidURL)

        // When
        apiService.fetchTodos { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertTrue(error is APIError)
                XCTAssertEqual(error as? APIError, .invalidURL)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
