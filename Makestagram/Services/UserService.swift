//
//  UserService.swift
//  Makestagram
//
//  Created by Quang Vu on 6/27/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    // Create a new user and write new data in the Database
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username]
        
        // Define the path in our Database
        let ref = Database.database().reference().child("users").child(firUser.uid)
        // Write our data on the above path
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                // Create a new User after we successfully wrote data on Database
                let user = User(snapshot: snapshot)
                // Call our completion callback function to transit to new View
                completion(user)
            })
        }
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        // READING DATA - Grab our root reference in the Firebase Database
        let rootRef = Database.database().reference()
        // Find our User tree -> find our user using the uid
        let userRef = rootRef.child("users").child(uid)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            guard let currUser = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(currUser)
        })
    }
    /**
     Read post data from the Firebase Database
     - parameter user: user who we want to grab the post from
     - parameter completion: closure to handle the retrieved post
    */
    static func fetchPosts(for user: User, completion: @escaping ([Post]) -> Void) {
        // relative reference path
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Gather all posts and downcast it to an array of data snapshot
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            // Reverse the snapshot list
            // Flat map will iterate through the list and convert each element using the given transformation
            // which is our Post initialization.
            let posts = snapshot.reversed().flatMap(Post.init)
            completion(posts)
        })
    }
}
