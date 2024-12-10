//
//  NewsFeedViewControllerCoordinator.swift
//  Autodoc_testTask
//
//  Created by Fixed on 04.12.24.
//

import UIKit

class NewsFeedViewCoordinator: BaseCoordinator, NewsFeedDidRequestNavigation {

    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private let newsFeedViewModel = NewsFeedViewModel(apiService: APIService.shared)
    
    override func start() {
        let newsFeedVC = NewsFeedViewController(viewModel: newsFeedViewModel)
        newsFeedVC.detailsRequestDelegate = self
        navigationController.pushViewController(newsFeedVC, animated: true)
    }
    
    func openDetailsScreen(for item: String) {
        let newsFeedExtendedViewController = NewsFeedDetailsController(url: URL(string: item) ?? URL(fileURLWithPath: "") )
        navigationController.pushViewController(newsFeedExtendedViewController, animated: true)
    }
}
