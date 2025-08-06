//
//  MockAddTaskRouter.swift
//  ToDoAppTests
//
//  Created by Александр Муклинов on 06.08.2025.
//

import UIKit
@testable import ToDoApp

class MockAddTaskRouter: AddTaskRouterInputProtocol {
    var dismissViewCalled = false
    
    static func createModule() -> UIViewController {
        return UIViewController()
    }
    
    func dismissView() {
        dismissViewCalled = true
    }
}
