//
//  RepositoryDetailsWorker.swift
//  TestFlatRockTech
//

import UIKit

typealias SuccessGetRepoDetails = (_ userRepos: Repo) -> Void

class RepositoryDetailsWorker {
    
    func fetchRepoDetails(owner: String, repoName: String, success: @escaping SuccessGetRepoDetails, failure: @escaping FailureHandler) {
        let path = "\(AppConstants.Urls.repoDetailsTail)/\(owner)/\(repoName)"
        let request = APIRequest(method: .get, path: path, baseUrl: AppConstants.Urls.baseUrl)
        
        
        APIClient().perform(request) { (response) in
            print(response)
            switch response {
            case .success(let response):
                if let response = try? response.decode(to: Repo.self) {
                    let details = response.body
                    success(details)
                } else {
                    print("Failed to decode response")
                    failure("Internal Error")
                }
            case .failure(let error):
                switch error.body {
                case .errorWithInfo(let errorData):
                    failure(errorData.message)
                default:
                    failure("Something went wrong")
                    
                }
            }
        }
    }
}
