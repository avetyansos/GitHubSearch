//
//  RepositoryListInteractor.swift
//  TestFlatRockTech
//

import UIKit

protocol RepositoryListBusinessLogic {
    
}

protocol RepositoryListDataStore {
    
}

class RepositoryListInteractor: RepositoryListBusinessLogic, RepositoryListDataStore
{
    var presenter: RepositoryListPresentationLogic?
    var worker: RepositoryListWorker?
    //var name: String = ""
    
}
