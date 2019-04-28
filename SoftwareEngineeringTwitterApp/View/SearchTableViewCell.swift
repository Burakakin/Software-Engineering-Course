//
//  SearchTableViewCell.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 2.04.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit
import Firebase

class SearchTableViewCell: UITableViewCell {

   
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    var indexForSelectedCell: ((Int) -> Void)?
    @IBOutlet weak var followFriend: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func FollowFriend(_ sender: UIButton) {
        let index = indexPath.flatMap { $0.row }
        self.indexForSelectedCell?(index!)
        
        if followFriend.isSelected == true {
            followFriend.isSelected = false
        } else {
            followFriend.isSelected = true
        }
    }
    
    func configureCell(user: User) {
        
        self.followFriend.setTitle("Follow", for: .normal)
        self.followFriend.setTitle("Unfollow", for: .selected)
        userNameLabel.text = user.nameSurname
        imageDownload.getImage(withUrl: user.profileImageUrl) { (image) in
            self.userProfileImageView.image = image
            self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.width / 2
            self.userProfileImageView.clipsToBounds = true
        }
        
        let userID = user.userID
        
        var ref: CollectionReference? = nil
        //ref = Firestore.firestore().collection("Tweet")
        ref = Firestore.firestore().collection("User").document(User.currentUserID).collection("Friend")
        
        ref?.document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                self.followFriend.isSelected = true
                
                
            } else {
                
                self.followFriend.isSelected = false
            }
        }
    }

}
