//
//  StaredReposPresenter.swift
//  TestFlatRockTech
//

import UIKit

protocol StaredReposPresentationLogic {
    func presentRepos(response: StaredRepos.UseCase.Response)
    func presentError(response: StaredRepos.UseCase.Response)
}

class StaredReposPresenter: StaredReposPresentationLogic
{
    weak var viewController: StaredReposDisplayLogic?

    func presentRepos(response: StaredRepos.UseCase.Response) {
        var viewModel = StaredRepos.UseCase.ViewModel()
        viewModel.repos = response.repos
        viewController?.displayRepos(viewModel: viewModel)
    }
    
    func presentError(response: StaredRepos.UseCase.Response) {
        var viewModel = StaredRepos.UseCase.ViewModel()
        viewModel.errorString = response.errorString
        viewController?.displayError(viewModel: viewModel)
    }
}
