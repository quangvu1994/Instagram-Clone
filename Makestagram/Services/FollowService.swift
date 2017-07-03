//
//  FollowService.swift
//  Makestagram
//
//  Created by Quang Vu on 7/1/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FollowService: NSObject {
    
    static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followee: User, success: @escaping (Bool) -> Void) {
        if isFollowing {
            followUser(followee, success: success)
        } else {
            unfollowUser(followee, success: success)
        }
    }
    
    /**
     Write to the database with whom you are following
    */
    static func followUser(_ user: User, success: @escaping (Bool) -> Void){
        let currentUID = User.current.uid
        let followData = ["followers/\(user.uid)/\(currentUID)" : true,
                          "following/\(currentUID)/\(user.uid)" : true]
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            success(true)
        }
    }

    static func unfollowUser(_ user: User, success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let followData = ["followers/\(user.uid)/\(currentUID)" : NSNull(),
                          "following/\(currentUID)/\(user.uid)" : NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            success(true)
        }
    }
    
    /**
     Checking if an user is being followed by the current user
    */
    static func isFollow(_ user: User, success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        // Construct the path to our following node
        let followingRef = Database.database().reference().child("followers/\(user.uid)/\(currentUID)")
        followingRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value {
                return success(true)
            }else {
                return success(false)
            }
        })
    }
    
}
