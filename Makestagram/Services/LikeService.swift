//
//  LikeService.swift
//  Makestagram
//
//  Created by Quang Vu on 6/30/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import Foundation
import Firebase

class LikeService {
    
    /**
     Trigger like or dislike action
    */
    static func setIsLiked(_ isLiked: Bool, for post: Post, success: @escaping (Bool) -> Void) {
        if isLiked {
            likePost(for: post, success: success)
        } else {
            dislikePost(for: post, success: success)
        }
    }
    
    /**
     Capture the like action and write the data to our database
    */
    static func likePost(for post: Post, success: @escaping (Bool) -> Void){
        
        // Grab the key of the post
        guard let key = post.key else {
            return success(false)
        }
        // Grab the current user's id
        let currentID = User.current.uid
        // Construct the path to write data
        let likesReference = Database.database().reference().child("postLikes/\(key)/\(currentID)")
        likesReference.setValue(true) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
            // Using run transaction block to prevent corruption when multiple writes to same location happen at the same time
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                // Grab the data and downcast it to Int
                let currentCount = mutableData.value as? Int ?? 0
                // Increment
                mutableData.value = currentCount + 1
                
                // Save new value
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    success(false)
                } else {
                    success(true)
                }
            })
        }
    }
    
    /**
     Capture the dislike action and update our data in the database
    */
    static func dislikePost(for post: Post, success: @escaping (Bool) -> Void) {
        // Grab the key of the post
        guard let key = post.key else {
            return success(false)
        }
        
        // Grab the userID
        let currentID = User.current.uid
        let dislikeReference = Database.database().reference().child("postLikes/\(key)/\(currentID)")
        dislikeReference.setValue(nil) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            // Construct the path to our likeCount
            let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                // Grab the data and downcast it to Int
                let numberOfLikes = mutableData.value as? Int ?? 0
                mutableData.value = numberOfLikes - 1
                
                return TransactionResult.success(withValue: mutableData)
            
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return success(false)
                }else {
                    return success(true)
                }
            
            })
        }
    }
    
    /**
     Gather info to check if the post is liked already by the current user
    */
    static func isPostLiked(_ post: Post, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        guard let key = post.key else {
            assertionFailure("Error: post must have key.")
            return completion(false)
        }
        
        let likesRef = Database.database().reference().child("postLikes").child(key)
        print(likesRef.queryEqual(toValue: nil, childKey: User.current.uid))
        likesRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String : Bool] {
                print("Current snapshot value \(value)")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
}
