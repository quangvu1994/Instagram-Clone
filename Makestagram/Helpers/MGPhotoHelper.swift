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
     
     - parameter viewController: the view controller that is going to present this alert popup
    */
    func presentActionSheet(from viewController: UIViewController) {
        // Instatiate a UIAlertController object
        let alertController = UIAlertController(title: nil, message: "Post Picture", preferredStyle: .actionSheet)
        
        // Check to see if the device has camera
        // Personal note: isSourceTypeAvailalbe is a type method that is declared as "class" which means
        // subclass can override it (not like static method)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Create an action
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                self.presentImagePickerController(with: .camera, from: viewController)
            })
            
            // Add the action on the alert popup
            alertController.addAction(capturePhotoAction)
        }
        
        // Check to see if the photo library is available on the device
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { action in
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
            })
            
            alertController.addAction(uploadAction)
        }
        
        // Create a cancel action and add it on the alert pop up
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present our alert pop up using our passed-in view controller
        viewController.present(alertController, animated: true)
    }
    
    /**
     Method to display the UIImagePickerController 
     - parameter sourceType: type of image picker (i.e camerea, photo library)
     - parameter viewController: a reference to a view controller that present this image picker controller
    */
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        // Initialize our UIImagePickerController
        let imagePickerController = UIImagePickerController()
        
        // Set UIImagePickerController delegate
        imagePickerController.delegate = self
        // Set the sourceType
        imagePickerController.sourceType = sourceType
        
        // Present it
        viewController.present(imagePickerController, animated: true)
    }
}

/**
 Conform to UIImagePickerControllerDelegate to handle the selected image
 */
extension MGPhotoHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // UIImagePickerControllerOriginalImage is a key in our "info" dictionary - the value is the UIImage that the user selected
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // Handle the image
            completionHandler?(selectedImage)
        }
        
        // dismiss the picker which is subclass of UINavigationController
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
