//
//  User.swift
//  TestFlatRockTech
//
//  Created by Sos Avetyan on 5/17/22.
//

import Foundation


struct UserRepo: Codable {
    let id: Int
    let node: String
    let name: String
    let owner: Owner
    let created: String
    let url: String
    let language: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case node = "node_id"
        case name
        case owner
        case created = "created_at"
        case url = "html_url"
        case language
        case description
    }
    
    func makeViewModel() -> UserRepoViewModel {
        let viewModel = UserRepoViewModel(id: id,
                                      node: node,
                                      repoName: name,
                                      created: created,
                                      url: url,
                                      language: language,
                                      description: description,
                                      loginName: owner.login,
                                      avatarURL: URL(string: owner.avatar) ?? URL(fileURLWithPath: ""))
        
        return viewModel
    }
    
}


struct Owner: Codable {
    let login: String
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatar = "avatar_url"
    }
}

struct RepoViewModel {
    var currentpage = 0
    var userRepoViewModel: [UserRepoViewModel]
    var searchText = ""
    var needToReload = true
}


struct UserRepoViewModel {
    let id: Int
    let node: String
    let repoName: String
    let created: String
    let url: String
    let language: String
    let description: String?
    let loginName: String
    let avatarURL: URL
}
