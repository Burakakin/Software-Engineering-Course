//
//  User.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 26.02.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var userID: String
    var nameSurname: String
    var email: String
    var password: Int
    var profileImageUrl: String
    var date: Timestamp
    
    var userDictionary: [String: Any] {
        return [
            "userID": userID,
            "nameSurname": nameSurname,
            "email": email,
            "password": password,
            "profileImageUrl": profileImageUrl,
            "date":date
        ]
    }
    
    
     static var currentUserId: String {
        return (Auth.auth().currentUser?.uid)!
    }
    
    
}

extension User {
    init?(dictionary: [String: Any]) {
        guard let userID = dictionary["userID"] as? String,
            let nameSurname = dictionary["nameSurname"] as? String,
            let email = dictionary["email"] as? String,
            let password = dictionary["password"] as? Int,
            let profileImageUrl = dictionary["profileImageUrl"] as? String,
            let date = dictionary["date"] as? Timestamp else { return nil }
        
        self.init(userID: userID, nameSurname: nameSurname, email: email, password: password, profileImageUrl: profileImageUrl, date: date)
    }
}
