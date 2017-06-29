//
//  User.swift
//  Makestagram
//
//  Created by Quang Vu on 6/27/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    
    // MARK: - Properties
    
    let uid: String
    let username: String
    
    // MARK: - Singleton
    
    // hold our current user - our single user that is used across the app
    // the user is being encapsulated
    private static var _current: User?
    
    // MARK: - Init
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        super.init()
    }
    
    // Create a failable init - if username or uid is nil, we will return nil
    init?(snapshot: DataSnapshot) {
        // check if we have any data and downcast our data to [String : Any] type
        // Also, check user exist
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        super.init()
    }
    
    // Part of the NSCoding protocol - we need to implement this required initializer
    // to decode the Data
    required init?(coder aDecoder: NSCoder) {
        // Decode data objects to initialize our uid and username
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String
            else { return nil }
        
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
    // MARK: - Class Methods
    
    // setter - set our current user
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        // Write the user object to UserDefaults
        if writeToUserDefaults {
            // NSKeyedArchiver encode our user object into NSData
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            // Store the data in UserDefaults
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
    
    // getter - get current user
    static var current: User {
        // crash with a fatalError when there is no current user
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // return the current user
        return currentUser
    }
}

// Conform to NSCoding to convert/encode User objects to Data
extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        // Encode our uid and username to Data objects in UserDefaults
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
    }
}

