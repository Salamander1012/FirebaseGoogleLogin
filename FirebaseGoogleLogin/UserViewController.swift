//
//  UserViewController.swift
//  FirebaseGoogleLogin
//
//  Created by Salman Fakhri on 3/1/19.
//  Copyright © 2019 Salman Fakhri. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class UserViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var userIdToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        nameLabel.text = "Hi " + (Auth.auth().currentUser?.displayName!)!
        //This is how we get the idToken to send to the server
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { (token, error) in
            if let error = error {
                print(error)
                return
            }
            self.userIdToken = token
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        let firebaseAuth = Auth.auth()
        print("Signing out...")
        do {
            try firebaseAuth.signOut()
            print("Signed out")
        } catch let signoutError as NSError {
            print("Error signing out: %@", signoutError)
        }
        navigationController?.popViewController(animated: true)
    }
    

}
