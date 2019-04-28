//
//  SearchVC.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 26.02.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit
import Firebase

class SearchVC: UITableViewController {

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        FetchInfo.getUserProfile { (userDictionary) in
            if let userDictionary = userDictionary {
                let timestamp: Timestamp = userDictionary["date"] as! Timestamp
                let newTweet = User(userID: userDictionary["userID"] as! String, nameSurname: userDictionary["nameSurname"] as! String, email: userDictionary["email"] as! String, password: userDictionary["password"] as! Int, profileImageUrl: userDictionary["profileImageUrl"] as! String, date: timestamp)
                DispatchQueue.main.async {
                    self.users.append(newTweet)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
   
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        let user = users[indexPath.row]
        cell.configureCell(user: user)
        
        cell.indexForSelectedCell = { index in
            let tweetID = self.users[index].nameSurname
            let userID = self.users[index].userID
            
            FetchInfo.fetchHomeFeed(userID: userID, subCollection: "UserTweet", completion: { userTweet in
                if userID == User.currentUserID {
                    print("You choose yourself")
                }
                else {
                    if let userTweet = userTweet {
                        
                        FetchInfo.addFriend(userID: userID, UserTweets: userTweet)
                        print(userTweet["tweetID"]!)
                    }
                }
            })
            
            print("TweetID: \(tweetID)\nUserID: \(userID)")
        }
        
        return cell
    }
    

}


//let alert = UIAlertController(title: "Confirm", message: "Would you like follow the Friend ", preferredStyle: UIAlertController.Style.alert)
//
//alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
//    if cell.followFriend.isSelected == true {
//        cell.followFriend.isSelected = true
//    } else {
//        cell.followFriend.isSelected = false
//    }
//}))
//alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
//    if cell.followFriend.isSelected == true {
//        cell.followFriend.isSelected = false
//    } else {
//        cell.followFriend.isSelected = true
//    }
//
//
//
//}))
//self.present(alert, animated: true, completion: nil)
