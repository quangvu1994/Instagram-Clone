//
//  PostService.swift
//  Makestagram
//
//  Created by Quang Vu on 6/29/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

class PostService {
    
    /** 
     Create post and upload the image on the Firebase Storage
     - parameter image: image to post and to upload
    */
    static func create (for image: UIImage) {
        // Define the path to upload our image
        let imageReference = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageReference, completion: { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            let imageAspectHeight = image.aspectHeight
            self.create(forURLString: urlString, aspectHeight: imageAspectHeight)
        })
    }
    /**
     Helper method to write a new post on Firebase Database
     - parameter urlString: downloadURL of the image
     - parameter aspectHeight: height of the image so that we know how to display it later on the phone
    */
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        // Get the current User
        let currentUser = User.current
        // Instantiate a new Post object
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        // Convert post object into dictionary type in order to store it on database
        let dict = post.dictValue
        
        // Define the path to write on database
        // childByAutoID generates a new child underneath of the "currentUser.uid" child
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
        // Write
        postRef.updateChildValues(dict)
    }
}
