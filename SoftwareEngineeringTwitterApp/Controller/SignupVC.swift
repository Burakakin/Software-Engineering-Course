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
import FirebaseStorage

class SignupVC: UIViewController {
    
    @IBOutlet weak var nameSurnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    var ref: CollectionReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
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
            let storageRef = Storage.storage().reference().child("UserProfileImage/\(email)")
            
            if err != nil {
                print("Error")
            }
            else {
              
                let uploadMetadata = StorageMetadata()
                uploadMetadata.contentType = "image/jpeg"
                let uploadImage = self.profileImageView.image?.jpegData(compressionQuality: 0.8)
                storageRef.putData(uploadImage!, metadata: uploadMetadata) { (metadata, error) in
                    guard let metadata = metadata else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    if error != nil {
                        print("Error! \(String(describing: error?.localizedDescription))")
                    }
                    else{
                        print("Upload Complete! \(String(describing: metadata))")
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        let photo = downloadURL.absoluteString
                        
                        let newUser = User(userID: Auth.auth().currentUser!.uid, nameSurname: name, email: email, password: Int(password)!, profileImageUrl: photo, date: Timestamp())
                        
                        self.ref?.addDocument(data: newUser.userDictionary)
                        
                        
                        
                        print(User.currentUserID)
                    }
                }
                
                
                
                
                
                
            }
        }
        
        
    }
    
    
}

extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let profileImg = UIImagePickerController()
        profileImg.delegate = self
        profileImg.allowsEditing = false
        profileImg.sourceType = .photoLibrary
        profileImg.allowsEditing = false
        present(profileImg, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedProfileImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.image = pickedProfileImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}
