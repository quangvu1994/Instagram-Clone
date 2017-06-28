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

class User {
    
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
    }
    
    // MARK: - Class Methods
    
    // setter - set our current user
    static func setCurrent(_ user: User) {
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
