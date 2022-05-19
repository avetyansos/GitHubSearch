//
//  SearchWorker.swift
//  TestFlatRockTech
//

import UIKit

typealias SuccessGetUserSpositories = (_ userRepos: [UserRepo]) -> Void
typealias FailureHandler = (_ error: String) -> Void

class SearchWorker
{
    func fetchUserData(searchText: String, _ page: String, success: @escaping SuccessGetUserSpositories, failure: @escaping FailureHandler) {
        let path = "\(AppConstants.Urls.userRepoTail)/\(searchText)/repos"
        let request = APIRequest(method: .get, path: path, baseUrl: AppConstants.Urls.baseUrl)
        request.queryItems = [URLQueryItem(name: "page", value: page),
                              URLQueryItem(name: "per_page", value: "5")]
        
        APIClient().perform(request) { (response) in
            print(response)
            switch response {
            case .success(let response):
                if let response = try? response.decode(to: [UserRepo].self) {
                    let fields = response.body
                    success(fields)
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
