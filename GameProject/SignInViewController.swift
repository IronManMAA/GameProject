//
//  SignInViewController.swift
//  GameProject
//
//  Created by Marco Almeida on 1/13/17.
//  Copyright © 2017 THE IRON YARD. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var PlayButton: GIDSignInButton!
    @IBOutlet weak var VaderImage: UIImageView!

    @IBAction func PlayButton(_ sender: UIButton)
    {
//        print("SignedIn?: \(AppState.sharedInstance.signedIn)")
//        print("User Name?: \(AppState.sharedInstance.userName)")

//        if !AppState.sharedInstance.signedIn
//        {
////            print("SignedIn?: \(AppState.sharedInstance.signedIn)")
////            print("User Name?: \(AppState.sharedInstance.userName)")
//
//        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Star Wars Game"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        googleSignInButton.style = GIDSignInButtonStyle.standard
        googleSignInButton.colorScheme = GIDSignInButtonColorScheme.light
        
VaderImage.image = UIImage(named: "Vader")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


} // End of Class

