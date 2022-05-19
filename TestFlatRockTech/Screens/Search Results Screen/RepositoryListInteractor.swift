//
//  RepositoryListInteractor.swift
//  TestFlatRockTech
//

import UIKit

protocol RepositoryListBusinessLogic {
    func loadMoreRepos(request: RepositoryList.UseCase.Request)
}

protocol RepositoryListDataStore {
    
}

class RepositoryListInteractor: RepositoryListBusinessLogic, RepositoryListDataStore
{
    var presenter: RepositoryListPresentationLogic?
    var worker: RepositoryListWorker?
    //var name: String = ""
    
    
    func loadMoreRepos(request: RepositoryList.UseCase.Request) {
        let worker = SearchWorker()
        var response = RepositoryList.UseCase.Response()
        
        worker.fetchUserData(searchText: request.userRpos.searchText, "\(request.userRpos.currentpage)", success: { userRepos in
            let uiRepos = userRepos.compactMap({ $0.makeViewModel() })
            response.userRpos = request.userRpos
            if userRepos.count != 0 {
                if userRepos.count < 5 {
                    response.userRpos.needToReload = false
                }
                response.userRpos.userRepoViewModel.append(contentsOf: uiRepos)
                self.presenter?.presentUserRepos(response: response)
            }
        }, failure: { error in
            response.errosString = error
            self.presenter?.presentError(response: response)
        })
    }
}
