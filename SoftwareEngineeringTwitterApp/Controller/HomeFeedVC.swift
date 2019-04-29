//
//  HomeFeedVC.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 26.02.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit
import Firebase

class HomeFeedVC: UITableViewController {
    var tweets = [Tweet]()
    var refresh = UIRefreshControl()
    @IBOutlet var homeFeedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        homeFeedTableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshHomeFeed), for: .valueChanged)
        FetchInfo.fetchHomeFeed(userID: User.currentUserID, subCollection: "TweetPool") { (homeFeed) in
            if let homeFeed = homeFeed {
                //print(homeFeed)
                let timestamp: Timestamp = homeFeed["dateTweet"] as! Timestamp
                let newTweet = Tweet(tweet: homeFeed["tweet"] as! String, dateTweet: timestamp, userID: homeFeed["userID"] as! String, tweetID: homeFeed["tweetID"] as! String)
                DispatchQueue.main.async {
                    self.tweets.append(newTweet)
                    self.tableView.reloadData()
                }
            }
            
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTweet))
       
    }
    
    
    @objc func refreshHomeFeed (sender: AnyObject) {
       
        tweets.removeAll()
        tableView.reloadData()
        FetchInfo.fetchHomeFeed(userID: User.currentUserID, subCollection: "TweetPool") { (homeFeed) in
            if let homeFeed = homeFeed {
                //print(homeFeed)
                let timestamp: Timestamp = homeFeed["dateTweet"] as! Timestamp
                let newTweet = Tweet(tweet: homeFeed["tweet"] as! String, dateTweet: timestamp, userID: homeFeed["userID"] as! String, tweetID: homeFeed["tweetID"] as! String)
                DispatchQueue.main.async {
                    self.tweets.append(newTweet)
                    self.tableView.reloadData()
                     self.refresh.endRefreshing()
                }
            }
            
        }
       
    }

    
    @objc func addTweet() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pushTweetPopUp = storyboard.instantiateViewController(withIdentifier: "PushTweetVC") as! PushTweetVC
        self.addChild(pushTweetPopUp)
        pushTweetPopUp.view.frame = self.view.frame
        self.view.addSubview(pushTweetPopUp.view)
        pushTweetPopUp.didMove(toParent: self)
//        print("SLM")
//        let tweetID = UUID().uuidString
//        let newTweet = Tweet(tweet: "SA", dateTweet: Timestamp(), userID: User.currentUserID, tweetID: tweetID)
//        FetchInfo.pushTweet(tweet: newTweet, tweetID: tweetID)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! HomeFeedTableViewCell
        let tweet = tweets[indexPath.row]
        cell.selectionStyle = .none
        cell.configureCell(tweet: tweet)
        
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
            let tweetIDNew = "burak" + tweetID
            let first4IDNew = String(tweetIDNew.prefix(4))
            let first4ID = String(tweetID.prefix(4))
            
            let alert = UIAlertController(title: "Confirm", message: "Would you like the Retweet ", preferredStyle: UIAlertController.Style.alert)
           
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
                if cell.retweetButton.isSelected == true {
                    cell.retweetButton.isSelected = true
                } else {
                    cell.retweetButton.isSelected = false
                }
            }))
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
                var ref: CollectionReference? = nil
               
                if first4IDNew == first4ID {
                    print("You already Retweed ")
                    ref = Firestore.firestore().collection("Tweet").document(User.currentUserID).collection("UserTweet")
                    ref!.document(tweetID).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    ref = Firestore.firestore().collection("Tweet").document(User.currentUserID).collection("TweetPool")
                    ref!.document(tweetID).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    ref = Firestore.firestore().collection("User").document(User.currentUserID).collection("Retweet")
                    ref!.document(tweetID).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }
                else {
                    if cell.retweetButton.isSelected == true {
                        cell.retweetButton.isSelected = false
                    } else {
                        cell.retweetButton.isSelected = true
                    }
                    
                    let retweetTweet = Tweet(tweet: tweetNew, dateTweet: Timestamp(), userID: userID, tweetID: tweetIDNew)
                    ref = Firestore.firestore().collection("User").document(User.currentUserID).collection("Retweet")
                    ref?.document(tweetIDNew).setData(retweetTweet.dictionary)
                    ref = Firestore.firestore().collection("Tweet").document(User.currentUserID).collection("UserTweet")
                    ref!.document(tweetIDNew).setData(retweetTweet.dictionary)
                    ref = Firestore.firestore().collection("Tweet").document(User.currentUserID).collection("TweetPool")
                    ref!.document(tweetIDNew).setData(retweetTweet.dictionary)
                }
               
               
                
                
            }))
            self.present(alert, animated: true, completion: nil)
            
            print("TweetID: \(tweetID)\nUserID: \(userID)")
            
        }
       
        
        return cell
    }

//    func showAlertWithDistructiveButton(title: String) {
//        let alert = UIAlertController(title: "Confirm", message: "Confirm the \(title)", preferredStyle: UIAlertController.Style.alert)
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
//            //Cancel Action
//        }))
//        alert.addAction(UIAlertAction(title: "Confirm",
//                                      style: UIAlertAction.Style.destructive,
//                                      handler: {(_: UIAlertAction!) in
//
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
}


