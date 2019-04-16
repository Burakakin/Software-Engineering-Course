//
//  ImageDowloand.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 17.03.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit
import Firebase


extension UIResponder {
    
    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}

extension UITableViewCell {
    
    var tableView: UITableView? {
        return next(UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}



class imageDownload {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func download(withUrl urlString: String, completion: @escaping (_ image: UIImage?)->()) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            //            guard error == nil && data != nil else { return }
            var downloadedImage: UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
            
        }
        task.resume()
    }
    
    
    
    static func getImage(withUrl urlString: String, completion: @escaping (_ image: UIImage?)->()) {
        guard let url = URL(string: urlString) else { return }
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        }
        else {
            download(withUrl: urlString, completion: completion)
        }
        
    }
    
    
    
}



class FetchInfo {
    
    static func getUserProfile(completion: @escaping ([String: Any]?) -> ()) {
        var ref: CollectionReference? = nil
        //ref = Firestore.firestore().collection("Tweet")
        ref = Firestore.firestore().collection("User")
        ref?.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    FetchInfo.fetchUserInfo(userID: document.documentID, completion: { (userData) in
                        if let userData = userData {
                           completion(userData)
                        }
                    })
                }
            }
        }
    }
    
    static func fetchUserInfo(userID: String, completion: @escaping (([String: Any]?) -> ())) {
        
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("User").document(userID)
//        var userInfo = [String: Any]()
        
        ref!.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()!
                //print("Document data: \(userData)")
                completion(userData)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    
    
    static func pushTweet(tweet: Tweet, tweetID: String) {
        var ref: CollectionReference? = nil
        ref = Firestore.firestore().collection("Tweet").document(User.currentUserID).collection("UserTweet")
        ref!.document(tweetID).setData(tweet.dictionary)
        ref = Firestore.firestore().collection("Tweet").document(User.currentUserID).collection("TweetPool")
        ref!.document(tweetID).setData(tweet.dictionary)
    }
    
    static func favouriteTweet(userID: String, tweetID: String) {
        var ref: CollectionReference? = nil
        ref = Firestore.firestore().collection("User").document(User.currentUserID).collection("Favourite")
        
        ref?.document(tweetID).getDocument { (document, error) in
            if let document = document, document.exists {
                ref?.document(tweetID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            } else {
                print("Document does not exist")
                ref?.document(tweetID).setData(["tweetID": tweetID, "userID": userID])
            }
        }
        
    }
    
    
    static func fetchHomeFeed(userID: String, subCollection: String, completion: @escaping ([String: Any]?) -> ()) {
        
        var ref: CollectionReference? = nil
        //ref = Firestore.firestore().collection("Tweet")
        ref = Firestore.firestore().collection("Tweet").document(userID).collection(subCollection)
        ref?.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    completion(document.data())
                }
            }
        }
    }
    
    
    
    static func checkFavourites(tweetID: String, completion: @escaping ([String: Any]?) -> ()) {
        
        var ref: CollectionReference? = nil
        //ref = Firestore.firestore().collection("Tweet")
        ref = Firestore.firestore().collection("User").document(User.currentUserID).collection("Favourite")
        
        ref?.document(tweetID).getDocument { (document, error) in
            if let document = document, document.exists {
                let favouriteData = document.data()!
                completion(favouriteData)
                print("Document data: \(favouriteData)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    static func addFriend(userID: String, UserTweets: [String: Any]) {
        var ref: CollectionReference? = nil
        ref = Firestore.firestore().collection("User").document(User.currentUserID).collection("Friend")
        
        ref?.document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                ref?.document(userID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            } else {
                print("Document does not exist")
                ref?.document(userID).setData(["userID": userID])
                ref = Firestore.firestore().collection("Tweet").document(User.currentUserID).collection("TweetPool")
                ref?.document("\(UserTweets["tweetID"]!)").setData(UserTweets)
            }
        }
        
    }
    
}
