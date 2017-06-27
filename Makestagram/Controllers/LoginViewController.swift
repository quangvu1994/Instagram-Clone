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
        
        // Safely unwrap our authenticated user
        guard let user = user
            else { return }
        
        // Grab our root reference in the Firebase Database
        let rootRef = Database.database().reference()
        // Find our User tree -> find our user using the uid
        let userRef = rootRef.child("User").child(user.uid)
        
        // Gather data using observeSingleEvent method
        // ?? When is the snapshot is being sent ??
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in 
            if let data = snapshot.value as? [String: Any] {
                print(data.debugDescription)
            }else {
                print("not exist")
            }
        })
    }
}

