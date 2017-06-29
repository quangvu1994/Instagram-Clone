//
//  StorageReference+Post.swift
//  Makestagram
//
//  Created by Quang Vu on 6/29/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import Foundation
import FirebaseStorage

extension StorageReference {
    static let dateFormatter = ISO8601DateFormatter()
    
    /**
     Construct Storage Reference path to store images
    */
    static func newPostImageReference() -> StorageReference {
        let uid = User.current.uid
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")
    }
}
