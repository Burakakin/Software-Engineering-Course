//
//  ProfileVC.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 26.02.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var ProfileSegmentedControl: UISegmentedControl!

    var tweets =  [Tweet]()
    var favourite =  [Tweet]()
    var retweet =  [Tweet]()
    

    @IBOutlet weak var profileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
            self.fetchHomeTweets()
        self.fetchHomeFavourites()
       
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch(ProfileSegmentedControl.selectedSegmentIndex)
        {
            
        case 0:
            returnValue = tweets.count
            break
        case 1:
            returnValue = favourite.count
            break
            
        case 2:
            returnValue = retweet.count
            break
            
        default:
            break
            
        }
        
        return returnValue
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        var tweet: Tweet!
        
        
        switch(ProfileSegmentedControl.selectedSegmentIndex)
        {
        case 0:
           tweet = tweets[indexPath.row]
            break
        case 1:
            tweet = favourite[indexPath.row]
            break
            
        case 2:
             tweet = retweet[indexPath.row]
            break
            
        default:
            break
            
        }

        cell.configureTweet(tweet: tweet)
        
        cell.indexForSelectedCell = { index in
            let tweetID = tweet.tweetID
            let userID = tweet.userID
            FetchInfo.favouriteTweet(userID: userID, tweetID: tweetID)
            print("TweetID: \(tweetID)\nUserID: \(userID)")
        }
        
        cell.indexForRetweet = { index in
            let tweetID = self.tweets[index].tweetID
            let userID = self.tweets[index].userID
            let tweetNew = self.tweets[index].tweet
            
            
            let alert = UIAlertController(title: "Confirm", message: "Would you like the Retweet ", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
                if cell.retweetButton.isSelected == true {
                    cell.retweetButton.isSelected = true
                } else {
                    cell.retweetButton.isSelected = false
                }
            }))
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
                if cell.retweetButton.isSelected == true {
                    cell.retweetButton.isSelected = false
                } else {
                    cell.retweetButton.isSelected = true
                }
                FetchInfo.retweetTweet(userID: userID, tweetID: tweetID)
                let retweetTweet = Tweet(tweet: tweetNew, dateTweet: Timestamp(), userID: userID, tweetID: tweetID)
                //                FetchInfo.pushTweet(tweet: retweetTweet, tweetID: tweetID)
                
            }))
            self.present(alert, animated: true, completion: nil)
            
            print("TweetID: \(tweetID)\nUserID: \(userID)")
            
        }
        return cell
    }
    
    
    @IBAction func switchTableView(_ sender: UISegmentedControl) {
        profileTableView.reloadData()
    }
    
    func fetchHomeTweets() {
        FetchInfo.fetchHomeFeed(userID: User.currentUserID, subCollection: "UserTweet") { (homeFeed) in
            if let homeFeed = homeFeed {
                //print(homeFeed)
                let timestamp: Timestamp = homeFeed["dateTweet"] as! Timestamp
                let newTweet = Tweet(tweet: homeFeed["tweet"] as! String, dateTweet: timestamp, userID: homeFeed["userID"] as! String, tweetID: homeFeed["tweetID"] as! String)
                DispatchQueue.main.async {
                    self.tweets.append(newTweet)
                    self.profileTableView.reloadData()
                }
            }
        }
        
        
    }
    
    func fetchHomeFavourites() {
        var ref: CollectionReference? = nil
        var newRef: CollectionReference? = nil
        ref = Firestore.firestore().collection("User").document(User.currentUserID).collection("Favourite")
        
        ref?.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let userID = document.data()["userID"] as! String
                    newRef = Firestore.firestore().collection("Tweet").document(userID).collection("UserTweet")
                    newRef?.document(document.documentID).getDocument { (document, error) in
                        if let document = document, document.exists {
                            let favouriteData = document.data()
                            if let favouriteData = favouriteData {
                                //print(homeFeed)
                                let timestamp: Timestamp = favouriteData["dateTweet"] as! Timestamp
                                let newTweet = Tweet(tweet: favouriteData["tweet"] as! String, dateTweet: timestamp, userID: favouriteData["userID"] as! String, tweetID: favouriteData["tweetID"] as! String)
                                DispatchQueue.main.async {
                                    self.favourite.append(newTweet)
                                    self.profileTableView.reloadData()
                                }
                            }
                           
                        }
                        
                        else {
                            print("Document does not exist")
                        }
                    }
                }
            }
        }
        
        
    }
}
