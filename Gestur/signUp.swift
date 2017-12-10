//
//  signUp.swift
//  Gestur
//
//  Created by tk on 08/11/2017.
//  Copyright © 2017 tk. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth 
class signUpController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var lblStatus: UILabel!
    
    @IBAction func CreateUser(_ sender: UIButton) {
        self.view.endEditing(true)
        
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.lblStatus.isHidden = false
                self.lblStatus.text = error.localizedDescription
            }
            else if let user = user {
                print(user)

                let setting = self.storyboard?.instantiateViewController(withIdentifier: "setting") as! detailController
                setting.userEmail = user.email
                self.present(setting, animated: true)
            }
        }
    }
}
