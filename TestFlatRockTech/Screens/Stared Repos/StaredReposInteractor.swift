//
//  StaredReposInteractor.swift
//  TestFlatRockTech
//

import UIKit

protocol StaredReposBusinessLogic {
    func getElements()
}

protocol StaredReposDataStore {
    
}

class StaredReposInteractor: StaredReposBusinessLogic, StaredReposDataStore
{
    var presenter: StaredReposPresentationLogic?
    var worker: StaredReposWorker?
    //var name: String = ""
    
    
    func getElements() {
        worker = StaredReposWorker()
        var response = StaredRepos.UseCase.Response()
        if let repos = worker?.getData() {
            response.repos = repos
            presenter?.presentRepos(response: response)
        } else {
            response.errorString = "Something Went Wrong"
            presenter?.presentRepos(response: response)
        }
    }
}
