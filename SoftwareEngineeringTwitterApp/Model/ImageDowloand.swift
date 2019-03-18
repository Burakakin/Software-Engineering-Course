//
//  ImageDowloand.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 17.03.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit
import Firebase


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



class FetchUserInfo {
    
    static func fetchUserInfo(userID: String, completion: @escaping (([String: Any]?) -> ())) {
        
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("User").document("\(userID)")
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
    
}
