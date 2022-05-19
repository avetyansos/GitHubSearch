//
//  RepositoryDetailsPresenter.swift
//  TestFlatRockTech
//

import UIKit

protocol RepositoryDetailsPresentationLogic {
    func presentUserRepo(response: RepositoryDetails.UseCase.Response)
    func presentError(response: RepositoryDetails.UseCase.Response)
}

class RepositoryDetailsPresenter: RepositoryDetailsPresentationLogic
{
    weak var viewController: RepositoryDetailsDisplayLogic?
    
    func presentUserRepo(response: RepositoryDetails.UseCase.Response) {
        var viewModel = RepositoryDetails.UseCase.ViewModel()
        viewModel.repoViewModel = response.repoModel.makeViewModel(owner: response.owner, repoName: response.repoName)
        viewController?.displayRepoDetails(viewModel: viewModel)
    }
    
    func presentError(response: RepositoryDetails.UseCase.Response) {
        var viewModel = RepositoryDetails.UseCase.ViewModel()
        viewModel.errosString = response.errosString
        viewController?.displayError(viewModel: viewModel)
    }
    
}
