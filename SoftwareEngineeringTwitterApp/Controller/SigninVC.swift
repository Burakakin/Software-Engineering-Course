//
//  SigninVC.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 26.02.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit

class SigninVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func presentSignUpButton(_ sender: UIButton) {
        let signInViewController = storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.present(signInViewController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
