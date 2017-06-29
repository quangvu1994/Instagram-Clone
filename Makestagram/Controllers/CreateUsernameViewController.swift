//
//  CreateUsernameViewController.swift
//  Makestagram
//
//  Created by Quang Vu on 6/27/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateUsernameViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        /**
         - obtain the current user using Auth class
         - grab the username text field and make sure that user has selected a username
        */
        guard let currUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else {return}
        
        // This is the same as the commented code above, just different syntax
        UserService.create(currUser, username: username) { (user) in
            // Making sure that we do have a new user. If so, we will send them to the main storyboard
            // Also, set our single current user
            guard let user = user else {
                return
            }
            
            User.setCurrent(user, writeToUserDefaults: true)
            // Grab our main storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
            // Instantiate our initial view controller from the storyboard
            if let initialViewController = storyboard.instantiateInitialViewController() {
                // Make it the rootViewController
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the corner of the button to be curvy
        nextButton.layer.cornerRadius = 6
    }
}
