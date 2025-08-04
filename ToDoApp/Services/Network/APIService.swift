//
//  APIService.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import Foundation

protocol APIServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void)
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL-адрес API."
        case .noData:
            return "Данные не получены от API."
        }
    }
}

class APIService: APIServiceProtocol {
    
    private let baseURL = "https://dummyjson.com"
    
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        let urlString = "\(baseURL)/todos"
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        // Выполняем сетевой запрос в фоновом потоке
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(APIError.noData))
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let todosResponse = try decoder.decode(TodosResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(todosResponse.todos))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}
