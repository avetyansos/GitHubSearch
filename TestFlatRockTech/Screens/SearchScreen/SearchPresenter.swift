//
//  SearchPresenter.swift
//  TestFlatRockTech
//

import UIKit

protocol SearchPresentationLogic {
    func presentUserRepos(response: Search.UseCase.Response)
    func presentError(response: Search.UseCase.Response)
}

class SearchPresenter: SearchPresentationLogic
{
    weak var viewController: SearchDisplayLogic?
    
    func presentUserRepos(response: Search.UseCase.Response) {
        var viewModel = Search.UseCase.ViewModel()
        let userRepo = response.userRpos.compactMap({ $0.makeViewModel() })
        var repoViewModel = RepoViewModel(userRepoViewModel: userRepo)
        repoViewModel.searchText = response.searchText
        viewModel.userRpos = repoViewModel
        viewController?.displayUserRepos(viewModel: viewModel)
    }
    
    func presentError(response: Search.UseCase.Response) {
        var viewModel = Search.UseCase.ViewModel()
        viewModel.errosString = response.errosString
        viewController?.displayError(viewModel: viewModel)
        
    }
}
