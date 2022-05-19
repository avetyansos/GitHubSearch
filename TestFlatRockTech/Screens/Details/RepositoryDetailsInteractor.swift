//
//  RepositoryDetailsInteractor.swift
//  TestFlatRockTech
//

import UIKit

protocol RepositoryDetailsBusinessLogic {
    
}

protocol RepositoryDetailsDataStore {
    
}

class RepositoryDetailsInteractor: RepositoryDetailsBusinessLogic, RepositoryDetailsDataStore
{
    var presenter: RepositoryDetailsPresentationLogic?
    var worker: RepositoryDetailsWorker?
    
    
}
