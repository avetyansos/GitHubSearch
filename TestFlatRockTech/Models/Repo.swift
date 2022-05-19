//
//  Repo.swift
//  TestFlatRockTech
//
//  Created by Sos Avetyan on 5/19/22.
//

import Foundation


struct Repo: Codable {
    let created: String
    let language: String
    let description: String?
    let url: String
    
    
    enum CodingKeys: String, CodingKey {
        case created = "created_at"
        case language
        case description
        case url = "html_url"
    }
    
    func makeViewModel(owner: String, repoName:String) -> RepoDetailViewModel {
        let url = URL(string: url)
        let viewModel = RepoDetailViewModel(owner: owner, repoName: repoName, description: description,createdAt: created.toCorrectDateTime(), language: language, repoURL: url!)
        return viewModel
    }
}

struct RepoDetailViewModel {
    let owner: String
    let repoName: String
    let description: String?
    let createdAt: String
    let language: String
    let repoURL: URL
    var isStareed: Bool = false
}
