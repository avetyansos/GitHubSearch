//
//  SearchRouter.swift
//  TestFlatRockTech
//

import UIKit

@objc protocol SearchRoutingLogic {
    
}

protocol SearchDataPassing {
    var dataStore: SearchDataStore? { get }
}

class SearchRouter: NSObject, SearchRoutingLogic, SearchDataPassing
{
    weak var viewController: SearchViewController?
    var dataStore: SearchDataStore?
    
}
