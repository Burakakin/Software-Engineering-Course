//
//  Tweet.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 1.03.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit
import Firebase


struct Tweet {
    
    var tweet: String
    var dateTweet: Timestamp
    var userID: String
    var tweetID: String
    
    var dictionary: [String: Any] {
        return [
            "tweet": tweet,
            "dateTweet": dateTweet,
            "userID": userID,
            "tweetID": tweetID
        ]
    }
}


extension Tweet {
    
    init?(dictionary: [String: Any]) {
        guard let tweet = dictionary["tweet"] as? String,
            let dateTweet = dictionary["dateTweet"] as? Timestamp,
            let userID = dictionary["userID"] as? String,
            let tweetID = dictionary["tweetID"] as? String else { return nil }
        
        self.init(tweet: tweet, dateTweet: dateTweet, userID: userID, tweetID: tweetID )
    }
}


let a = Tweet(tweet: "brk", dateTweet: Timestamp(), userID: User.currentUserID, tweetID: UUID().uuidString)


