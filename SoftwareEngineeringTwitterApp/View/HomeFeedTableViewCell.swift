//
//  HomeFeedTableViewCell.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 8.03.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit

class HomeFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    var indexForSelectedCell: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(tweet: Tweet) {
        tweetLabel.text = tweet.tweet
        timeLabel.text = "\(tweet.dateTweet.dateValue())"
        let userID = tweet.userID
        FetchUserInfo.fetchUserInfo(userID: "\(userID)", completion: { user in
            if let user = user {
                print(user)
                self.userNameLabel.text = user["nameSurname"] as? String
                imageDownload.getImage(withUrl: "\(user["profileImageUrl"] ?? "")", completion: { (image) in
                    self.userProfileImageView.image = image
                })
            }
        })
    }
    
    @IBAction func favouriteButton(_ sender: UIButton) {
        let index = indexPath.flatMap { $0.row }
        self.indexForSelectedCell?(index!)
    }
    
}



extension UIResponder {
    
    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}

extension UITableViewCell {
    
    var tableView: UITableView? {
        return next(UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}
