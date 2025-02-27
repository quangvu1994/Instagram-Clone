//
//  MainTabBarController.swift
//  Makestagram
//
//  Created by Quang Vu on 6/28/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    let mgPhotoHelper = MGPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define the callback to handle the image after we received it from MGPhotoHelper
        mgPhotoHelper.completionHandler = { image in
            // Create post - write data to Firebase Storage and Firebase Database
            PostService.create(for: image)
        }
        // Set our delegate to handle the changes made to our tab bar's items 
        // - our delegate needs to conform to UITabBarControllerDelegate
        delegate = self
        // Change the tint color (đường viền xung quanh) of the unselected item to be black
        tabBar.unselectedItemTintColor = .black
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    // This method handle the event when user select a tab bar item
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // We want to know which tab bar was selected
        if viewController.tabBarItem.tag == 1 {
            mgPhotoHelper.presentActionSheet(from: self)
            // Don't want to display the current view
            return false
        }
        
        return true
        
    }
}
