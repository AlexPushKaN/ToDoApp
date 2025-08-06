//
//  TodoModelTests.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import XCTest
@testable import ToDoApp

class TodoModelTests: XCTestCase {

    func testInitWithProperties() {
        let date = Date()
        let todo = TodoModel(id: 1, title: "Test Title", taskDescription: "Test Description", createdAt: date, isCompleted: false, userId: 10)
        
        XCTAssertEqual(todo.id, 1)
        XCTAssertEqual(todo.title, "Test Title")
        XCTAssertEqual(todo.taskDescription, "Test Description")
        XCTAssertEqual(todo.createdAt, date)
        XCTAssertFalse(todo.isCompleted)
        XCTAssertEqual(todo.userId, 10)
    }

    func testInitWithAPIModel() {
        let apiTodo = Todo(id: 2, todo: "API Todo Title", completed: true, userId: 20)
        let description = "API Description"
        let createdAt = Date().addingTimeInterval(-3600)
        
        let todoModel = TodoModel(from: apiTodo, description: description, createdAt: createdAt)
        
        XCTAssertEqual(todoModel.id, Int64(apiTodo.id))
        XCTAssertEqual(todoModel.title, apiTodo.todo)
        XCTAssertEqual(todoModel.taskDescription, description)
        XCTAssertEqual(todoModel.createdAt, createdAt)
        XCTAssertEqual(todoModel.isCompleted, apiTodo.completed)
        XCTAssertEqual(todoModel.userId, Int64(apiTodo.userId))
    }
    
    func testInitWithAPIModel_DefaultValues() {
        let apiTodo = Todo(id: 3, todo: "Another API Todo", completed: false, userId: 30)
        
        let todoModel = TodoModel(from: apiTodo)
        
        XCTAssertEqual(todoModel.id, Int64(apiTodo.id))
        XCTAssertEqual(todoModel.title, apiTodo.todo)
        XCTAssertNil(todoModel.taskDescription)
        XCTAssertNotNil(todoModel.createdAt)
        XCTAssertEqual(todoModel.isCompleted, apiTodo.completed)
        XCTAssertEqual(todoModel.userId, Int64(apiTodo.userId))
    }
}
