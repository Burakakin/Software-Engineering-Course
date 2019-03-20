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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        //self.view.backgroundColor = UIColor.blue
        // Do any additional setup after loading the view.
//        let a = Tweet(tweet: "a", dateTweet: Timestamp(), userID: "a", tweetID: UUID().uuidString)
//        tweets.append(a)
//        let b = Tweet(tweet: "b", dateTweet: Timestamp(), userID: "b", tweetID: UUID().uuidString)
//        tweets.append(b)
//        let c = Tweet(tweet: "c", dateTweet: Timestamp(), userID: "FpjBlBcMZWVQYHFXHZavJWHZUk33", tweetID: UUID().uuidString)
//        tweets.append(c)
        FetchInfo.fetchHomeFeed { (homeFeed) in
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
    

    
    @objc func addTweet() {
        print("SLM")
        let tweetID = UUID().uuidString
        let newTweet = Tweet(tweet: "selam", dateTweet: Timestamp(), userID: "FpjBlBcMZWVQYHFXHZavJWHZUk33", tweetID: tweetID)
        FetchInfo.pushTweet(tweet: newTweet, tweetID: tweetID)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! HomeFeedTableViewCell
        let tweet = tweets[indexPath.row]
        
        cell.configureCell(tweet: tweet)
        
        cell.indexForSelectedCell = { index in
            let tweetID = tweet.tweetID
            let userID = tweet.userID
            FetchInfo.favouriteTweet(userID: userID, tweetID: tweetID)
            
            print("TweetID: \(tweetID)\nUserID: \(userID)")
        }
        
       
        
        return cell
    }

}


