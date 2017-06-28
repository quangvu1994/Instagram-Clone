//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Quang Vu on 6/22/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuthUI
// Firebase Realtime Database library
import FirebaseDatabase

/** 
 Inorder to differentiate User class in FirebaseAuth lib with ours User class,
 we create a typealias variable
 */
typealias FIRUser = FirebaseAuth.User


class LoginViewController: UIViewController {
    
    @IBAction func registerOrLogin(_ sender: UIButton) {
        // instantiate an instance of the FUIAuth - we use the default one
        guard let authUI = FUIAuth.defaultAuthUI() else {
            return
        }
        
        // Set our view controller to be the autUI's delegator
        authUI.delegate = self
        
        // Instantiate the initial authentication view (pre-built), and display it
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

// We've set LoginViewController to be authUI's delegate -> Need to conform to FUIAuthDelegate
extension LoginViewController: FUIAuthDelegate {
    // method to handle error during authentication
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        // Safely unwrap user -> make sure that user has logged in
        guard let user = user else {
            return
        }
        
        // Read the data for that user
        UserService.show(forUID: user.uid) { (user) in
            // User found -> set current user and show the main storyboard
            if let user = user {
                // Set our current user which will be retained for the rest of the app lifecycle
                User.setCurrent(user)
                
                // Grab our main storyboard
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                
                // Instantiate our initial view controller from the storyboard
                if let initialViewController = storyboard.instantiateInitialViewController() {
                    // Make it the rootViewController
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
                
            } else {
                // No account found -> perform our createUsername segue to move to the
                // create new user view
                self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
            }
            
        }
    }
}

