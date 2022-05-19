//
//  SearchModels.swift
//  TestFlatRockTech
//

import UIKit

enum Search
{
    
    enum UseCase
    {
        struct Request
        {
            var searchText: String = ""
            var page: Int = 1
        }
        struct Response
        {
            var errosString: String = ""
            var searchText: String = ""
            var userRpos = [UserRepo]()
        }
        struct ViewModel
        {
            var errosString: String = ""
            var userRpos: RepoViewModel!
        }
    }
}
