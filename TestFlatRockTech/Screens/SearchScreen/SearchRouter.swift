//
//  SearchRouter.swift
//  TestFlatRockTech
//

import UIKit

protocol SearchRoutingLogic {
    func navigateToSearchList(viewModel: Search.UseCase.ViewModel)
}

protocol SearchDataPassing {
    var dataStore: SearchDataStore? { get }
}

class SearchRouter: NSObject, SearchRoutingLogic, SearchDataPassing
{
    weak var viewController: SearchViewController?
    var dataStore: SearchDataStore?
    
    func navigateToSearchList(viewModel: Search.UseCase.ViewModel) {
        let controller = RepositoryListViewController.instantiateFromStoryboard()
        controller.reposViewModel = viewModel.userRpos
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
}
