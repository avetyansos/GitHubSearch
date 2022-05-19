//
//  SearchInteractor.swift
//  TestFlatRockTech
//

import UIKit

protocol SearchBusinessLogic {
    func fetchUserRepository(request: Search.UseCase.Request)
}

protocol SearchDataStore {
    
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore {
    var presenter: SearchPresentationLogic?
    var worker: SearchWorker?
    
    func fetchUserRepository(request: Search.UseCase.Request) {
        worker = SearchWorker()
        var response = Search.UseCase.Response()
        worker?.fetchUserData(searchText: request.searchText, "\(request.page)", success: { userRepos in
            response.userRpos = userRepos
            response.searchText = request.searchText
            self.presenter?.presentUserRepos(response: response)
        }, failure: { error in
            response.errosString = error
            self.presenter?.presentError(response: response)
        })
    }
}
