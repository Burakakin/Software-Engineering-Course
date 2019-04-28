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
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    var indexForSelectedCell: ((Int) -> Void)?
    var indexForRetweet: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.userProfileImageView.image = nil // or set a placeholder image
        self.favouriteButton.isSelected = false
        self.retweetButton.isSelected = false
    }
    
    func configureCell(tweet: Tweet) {
        
        self.favouriteButton.setImage(UIImage(named:"favourite-star-filled")?.withRenderingMode(.alwaysOriginal), for: .selected)
        self.favouriteButton.setImage(UIImage(named:"favourite-star")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.retweetButton.setImage(UIImage(named:"retweet-filled")?.withRenderingMode(.alwaysOriginal), for: .selected)
        self.retweetButton.setImage(UIImage(named:"retweet")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        tweetLabel.text = tweet.tweet
        timeLabel.text = "\(tweet.dateTweet.dateValue())"
        let userID = tweet.userID
        let tweetID = tweet.tweetID
        FetchInfo.fetchUserInfo(userID: "\(userID)", completion: { user in
            if let user = user {
                //print("Configure Cell -> \(user)")
                self.userNameLabel.text = user["nameSurname"] as? String
                imageDownload.getImage(withUrl: "\(user["profileImageUrl"] ?? "")", completion: { (image) in
                    self.userProfileImageView.image = image
                    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.width / 2
                    self.userProfileImageView.clipsToBounds = true
                })
            }
        })
        
        FetchInfo.checkFavourites(tweetID: tweetID) { favouriteTweets in
            guard let favouriteTweet = favouriteTweets else { return }
            if (favouriteTweet["tweetID"] as! String) == "\(tweetID)" {
                self.favouriteButton.isSelected = true
            }
            else {
                self.favouriteButton.isSelected = false
            }
        }
       
    
    }
    @IBAction func retweetButton(_ sender: UIButton) {
        let index = indexPath.flatMap { $0.row }
        self.indexForRetweet?(index!)
        
        
//        if retweetButton.isSelected == true {
//            retweetButton.isSelected = false
//        } else {
//            retweetButton.isSelected = true
//        }
    }
    
    @IBAction func favouriteButton(_ sender: UIButton) {
        let index = indexPath.flatMap { $0.row }
        self.indexForSelectedCell?(index!)
        
        if favouriteButton.isSelected == true {
            favouriteButton.isSelected = false
        } else {
            favouriteButton.isSelected = true
        }
    }
    
}
