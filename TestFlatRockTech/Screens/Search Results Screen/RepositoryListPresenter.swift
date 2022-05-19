//
//  RepositoryListPresenter.swift
//  TestFlatRockTech
//

import UIKit

protocol RepositoryListPresentationLogic {
    func presentUserRepos(response: RepositoryList.UseCase.Response)
    func presentError(response: RepositoryList.UseCase.Response)
}

class RepositoryListPresenter: RepositoryListPresentationLogic
{
    weak var viewController: RepositoryListDisplayLogic?
    
    
    func presentUserRepos(response: RepositoryList.UseCase.Response) {
        var viewModel = RepositoryList.UseCase.ViewModel()
        viewModel.userRpos = response.userRpos
        viewController?.displayUserRepos(viewModel: viewModel)
    }
    
    func presentError(response: RepositoryList.UseCase.Response) {
        var viewModel = RepositoryList.UseCase.ViewModel()
        viewModel.errosString = response.errosString
        viewController?.displayError(viewModel: viewModel)
    }
}
