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
    
    var tweetDictionary: [String: Any] {
        return [
            "tweet": tweet,
            "dateTweet": dateTweet
        ]
    }
}


extension Tweet {
    
    init?(dictionary: [String: Any]) {
        guard let tweet = dictionary["tweet"] as? String,
            let dateTweet = dictionary["dateTweet"] as? Timestamp else { return nil }
        
        self.init(tweet: tweet, dateTweet: dateTweet)
    }
}
