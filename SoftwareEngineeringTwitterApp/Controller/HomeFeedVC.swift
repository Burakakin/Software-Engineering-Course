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
        //self.view.backgroundColor = UIColor.blue
        // Do any additional setup after loading the view.
        let a = Tweet(tweet: "a", dateTweet: Timestamp(), userID: "a", tweetID: UUID())
        tweets.append(a)
        let b = Tweet(tweet: "b", dateTweet: Timestamp(), userID: "b", tweetID: UUID())
        tweets.append(b)
        let c = Tweet(tweet: "c", dateTweet: Timestamp(), userID: "c", tweetID: UUID())
        tweets.append(c)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTweet))
        
        FetchUserInfo.fetchUserInfo(userID: "\(User.currentUserID)", completion: { user in
            if let user = user {
                print(user)
            }
        })
       
    }
    

    
    @objc func addTweet() {
        print("SLM")
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
            
            print("TweetID: \(tweetID)\nUserID: \(userID)")
        }
        
        return cell
    }

}


