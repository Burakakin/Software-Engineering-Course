//
//  SigninVC.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 26.02.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SigninVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func presentSignUpButton(_ sender: UIButton) {
        let signInViewController = storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.present(signInViewController, animated: true, completion: nil)
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else { return }
        
    
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if user != nil {
               
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = UINavigationController(rootViewController: MainTabbarController())
                
                let userSignedIn = UserDefaults.standard
                userSignedIn.set(true, forKey: "userSignedIn")
            }
            else {
                print(error?.localizedDescription ?? " ")
            }
           
        }
        
        
       
    }
    
    

}
