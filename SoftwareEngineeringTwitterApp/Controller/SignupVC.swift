//
//  SignupVC.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 26.02.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class SignupVC: UIViewController {

    @IBOutlet weak var nameSurnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
   
    var ref: CollectionReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func presentSignInButton(_ sender: UIButton) {
        let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
        self.present(signUpViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let name = nameSurnameTextField.text, !name.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else { return }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            self.ref = Firestore.firestore().collection("User")
            
            if err != nil {
                print("Error")
            }
            else {
                guard let authUser = result?.user else {
                    print("User failed")
                    return
                }
                
                let newUser = User(userID: Auth.auth().currentUser!.uid, nameSurname: name, email: email, password: Int(password)!, date: Timestamp())
                
                self.ref?.addDocument(data: newUser.userDictionary)
                
                
                
                
                
            }
        }
        
        
    }
    

}
