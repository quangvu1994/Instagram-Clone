//
//  MGPhotoHelper.swift
//  Makestagram
//
//  Created by Quang Vu on 6/28/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import UIKit

class MGPhotoHelper: NSObject {
    // MARK: - Properties
    
    var completionHandler: ((UIImage) -> Void)?
    
    // MARK: - Helper Methods
    
    /**
     This method will present an alert popup allowing user to choose to take a picture or choose a photo from the library.
     
     @param viewController: the view controller that is going to present this alert popup
    */
    func presentActionSheet(from viewController: UIViewController) {
        // Instatiate a UIAlertController object
        let alertController = UIAlertController(title: nil, message: "Post Picture", preferredStyle: .actionSheet)
        
        // Check to see if the device has camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Create an action
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                // do nothing yet...
            })
            
            // Add the action on the alert popup
            alertController.addAction(capturePhotoAction)
        }
        
        // Check to see if the photo library is available on the device
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { action in
                // do nothing yet...
            })
            
            alertController.addAction(uploadAction)
        }
        
        // Create a cancel action and add it on the alert pop up
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present our alert pop up using our passed-in view controller
        viewController.present(alertController, animated: true)
    }
}
