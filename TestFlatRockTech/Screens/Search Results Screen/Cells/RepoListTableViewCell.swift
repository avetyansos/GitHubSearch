//
//  RepoListTableViewCell.swift
//  TestFlatRockTech
//
//  Created by Sos Avetyan on 5/20/22.
//

import UIKit

class RepoListTableViewCell: UITableViewCell, Registerable {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var repoNameLabel: UILabel!
    private let imageLoader = ImageLoader()
    var userRepo: UserRepoViewModel?  {
        didSet {
            imageLoader.downloadImage(from: userRepo!.avatarURL, imageView: avatarImageView)
            userNameLabel.text = userRepo?.loginName
            repoNameLabel.text = userRepo?.repoName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
