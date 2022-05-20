//
//  User.swift
//  TestFlatRockTech
//
//  Created by Sos Avetyan on 5/17/22.
//

import Foundation
import RealmSwift


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
    
    func toDB() -> UserRepoDB {
        let dbModel = UserRepoDB()
        dbModel.id = id
        dbModel.node = node
        dbModel.repoName = repoName
        dbModel.created = created
        dbModel.url = url
        dbModel.language = language
        dbModel.desc = description ?? ""
        dbModel.loginName = loginName
        dbModel.avatarURL = avatarURL.absoluteString
        return dbModel
    }
}

class UserRepoDB: Object, IdentifiableObject {
    @objc dynamic var id: Int = 0
    @objc dynamic var node: String = ""
    @objc dynamic var repoName: String = ""
    @objc dynamic var created: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var language: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var loginName: String = ""
    @objc dynamic var avatarURL: String = ""
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    func toUserModel() -> UserRepoViewModel {
        
        let userModel = UserRepoViewModel(id: id,
                                          node: node,
                                          repoName: repoName,
                                          created: created,
                                          url: url,
                                          language: language,
                                          description: desc,
                                          loginName: loginName,
                                          avatarURL: URL(string: avatarURL)!)
        return userModel
    }
}
