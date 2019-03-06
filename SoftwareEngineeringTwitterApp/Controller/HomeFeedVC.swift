//
//  HomeFeedVC.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 26.02.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit

class HomeFeedVC: UITableViewController {
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.blue
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTweet))
    }
    

    
    @objc func addTweet() {
        print("SLM")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath)
        let tweet = tweets[indexPath.row]
        
        cell.textLabel?.text = tweet.tweet
        cell.detailTextLabel?.text = "\(tweet.dateTweet.dateValue())"
        
        return cell
    }

}


