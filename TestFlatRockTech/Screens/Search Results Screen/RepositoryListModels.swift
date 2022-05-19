//
//  RepositoryListModels.swift
//  TestFlatRockTech
//

import UIKit

enum RepositoryList
{
    
    enum UseCase
    {
        struct Request
        {
            var userRpos: RepoViewModel!
        }
        struct Response
        {
            var userRpos: RepoViewModel!
            var errosString = ""
        }
        struct ViewModel
        {
            var userRpos: RepoViewModel!
            var errosString = ""
        }
    }
}
