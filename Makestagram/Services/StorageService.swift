//
//  StorageService.swift
//  Makestagram
//
//  Created by Quang Vu on 6/28/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage


/**
 Handle uploading image to Firebase Storage
 */
class StorageService {
    
    /**
     Upload image to a specify storage reference
     
     - parameter image: image to uploa 
     - parameter reference: storage reference (path in the storage)
     - parameter completion: handle the download URL
    */
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void){
        // Convert image to Data and lower the quality (Read class description) -> faster to upload
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        // Upload data to Firebase Storage
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // Check to see if there is an error while uploading
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            // Handle the downloadURL of the data
            completion(metadata?.downloadURL())
        })
    }
}
