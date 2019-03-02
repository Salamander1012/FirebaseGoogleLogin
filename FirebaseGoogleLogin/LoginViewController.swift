//
//  ViewController.swift
//  FirebaseGoogleLogin
//
//  Created by Salman Fakhri on 3/1/19.
//  Copyright © 2019 Salman Fakhri. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set google's signin delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        //check if there is already a user signed in
        if let user = Auth.auth().currentUser { //if there is present the UserViewController
            presentUserVC()
        } else {
            print("no user") //otherwise do nothingt
        }
    }
    
    func presentUserVC() {
        guard let userVC = storyboard?.instantiateViewController(withIdentifier: "userVC") else { return }
        navigationController?.pushViewController(userVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
}

extension LoginViewController: GIDSignInDelegate {
    
    // This function gets called after the google sign in was succesful
    // However we still need to sign in with firebase using the credentials from the google sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Signing in...")
        if let error = error {
            print("Sign in error")
            return
        }
        
        //get google idToken and accessToken, and exchange them for firebase credentials
        guard let authentication = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        
        //Use firebase credentials to authenticate
        Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
            if let error = error {
                print("Sign in error")
                return
            }
            print("Signed in user " + user.profile.name)
            self.presentUserVC()
            
        }
    }
    
}

