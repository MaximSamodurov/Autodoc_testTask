//
//  BaseCoordinator.swift
//  Autodoc_testTask
//
//  Created by Fixed on 04.12.24.
//

import Foundation

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    func start() {
        fatalError("Child should implement func start!")
    }
}
