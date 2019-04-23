//
//  PushTweetViewController.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 23.04.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit
import Firebase

class PushTweetVC: UIViewController {
    
    @IBOutlet weak var tweetTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
   
    
    @IBAction func closePopUp(_ sender: UIButton) {
        self.removeAnimate()
        
        if let tweet = tweetTextField.text, !tweet.isEmpty {
            print("New Tweet Pushed")
            let tweetID = UUID().uuidString
            let newTweet = Tweet(tweet: tweetTextField.text!, dateTweet: Timestamp(), userID: User.currentUserID, tweetID: tweetID)
            FetchInfo.pushTweet(tweet: newTweet, tweetID: tweetID)
        }
        //self.view.removeFromSuperview()
       
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
}
