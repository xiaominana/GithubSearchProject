//
//  UserInfoTableViewCell.swift
//  GitHubSearch
//
//  Created by huangliru on 2019/8/8.
//  Copyright © 2019年 huangliru. All rights reserved.
//

import UIKit
import Kingfisher

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var userHeaderImageView: UIImageView!
    
    @IBOutlet weak var userBestLanguageLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func setCellData(_ data : Dictionary<String,Any> , _ indexPath : IndexPath) -> Void {
        
        self.userNameLabel.text = (data["userName"] as! String)
        
        let url = URL(string: data["headerImageUrl"] as! String)
        self.userHeaderImageView.kf.setImage(with: url)
        
        self.userBestLanguageLabel.text = (data["language"] as? String)
    }
    public
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
