//
//  SearchTableViewCell.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 2.04.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

   
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(user: User) {
        userNameLabel.text = user.nameSurname
        imageDownload.getImage(withUrl: user.profileImageUrl) { (image) in
            self.userProfileImageView.image = image
            self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.width / 2
            self.userProfileImageView.clipsToBounds = true
        }
    }

}
