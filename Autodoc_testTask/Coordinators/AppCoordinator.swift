//
//  AppCoordinator.swift
//  Autodoc_testTask
//
//  Created by Fixed on 04.12.24.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    private var window: UIWindow
    
    private var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    override func start() {
        let newsFeedViewControllerCoordinator = NewsFeedViewCoordinator(navigationController: navigationController)
        add(coordinator: newsFeedViewControllerCoordinator)
        newsFeedViewControllerCoordinator.start()
    }
}

