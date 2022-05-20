//
//  StaredReposModels.swift
//  TestFlatRockTech
//

import UIKit

enum StaredRepos
{
    
    enum UseCase
    {
        struct Request
        {
        }
        struct Response
        {
            var repos = [UserRepoViewModel]()
            var errorString = ""
        }
        struct ViewModel
        {
            var repos = [UserRepoViewModel]()
            var errorString = ""
        }
    }
}
