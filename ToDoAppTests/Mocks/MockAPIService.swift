//
//  MockAPIService.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import Foundation
@testable import ToDoApp

class MockAPIService: APIServiceProtocol {
    var fetchTodosResult: Result<[Todo], Error>?
    var fetchTodosCalled = false

    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        fetchTodosCalled = true

        if let result = fetchTodosResult {
            completion(result)
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1)))
        }
    }
}
