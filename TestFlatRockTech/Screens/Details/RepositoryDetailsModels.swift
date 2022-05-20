//
//  RepositoryDetailsModels.swift
//  TestFlatRockTech
//

import UIKit

enum RepositoryDetails
{
    
    enum UseCase
    {
        struct Request
        {
            var repoName = ""
            var owner = ""
            var userRepoViewModel: UserRepoViewModel!
        }
        struct Response
        {
            var repoName = ""
            var owner = ""
            var repoModel: Repo!
            var errosString: String = ""
        }
        struct ViewModel
        {
            var repoViewModel: RepoDetailViewModel!
            var errosString: String = ""
        }
    }
}
