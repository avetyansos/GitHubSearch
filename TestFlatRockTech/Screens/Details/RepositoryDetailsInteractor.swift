//
//  RepositoryDetailsInteractor.swift
//  TestFlatRockTech
//

import UIKit

protocol RepositoryDetailsBusinessLogic {
    func getRepoDetails(request: RepositoryDetails.UseCase.Request)
    func stareRepoDetails(request: RepositoryDetails.UseCase.Request)
}

protocol RepositoryDetailsDataStore {
    
}

class RepositoryDetailsInteractor: RepositoryDetailsBusinessLogic, RepositoryDetailsDataStore
{
    var presenter: RepositoryDetailsPresentationLogic?
    var worker: RepositoryDetailsWorker?
    
    
    
    func getRepoDetails(request: RepositoryDetails.UseCase.Request) {
        worker = RepositoryDetailsWorker()
        var response = RepositoryDetails.UseCase.Response()
        
        worker?.fetchRepoDetails(owner: request.owner, repoName: request.repoName, success: { userRepos in
            response.repoModel = userRepos
            response.repoName = request.repoName
            response.owner = request.owner
            self.presenter?.presentUserRepo(response: response)
        }, failure: { error in
            response.errosString = error
            self.presenter?.presentError(response: response)
        })
        
    }
    
    func stareRepoDetails(request: RepositoryDetails.UseCase.Request) {
        let starWorker = StaredReposWorker()
        starWorker.storeData(data: request.userRepoViewModel)
    }
}
