//
//  Login.swift
//  Gestur
//
//  Created by tk on 08/11/2017.
//  Copyright © 2017 tk. All rights reserved.
//
import UIKit
import Foundation
import FirebaseAuth
import Firebase

class logInController: UIViewController {
    
    @IBOutlet var layoverStatus: UILabel!
    var handle: AuthStateDidChangeListenerHandle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.layoverStatus.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            print(auth)
            if let user = user {
                print(user)
             
            }
        }
    }
    
    @IBOutlet var lblTopBar: UILabel!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBAction func LoginButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        Auth.auth().signIn(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { (user, error) in
            if let error = error {
                    self.layoverStatus.isHidden = false
                    self.layoverStatus.text = error.localizedDescription
            }
            else if let user = user {
                print(user)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "welcome") as UIViewController
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    @IBAction func forgetPassword(_ sender: UIButton) {
        if (txtEmail.text != ""){
        Auth.auth().sendPasswordReset(withEmail: self.txtEmail.text!) { error in
            
        }
            self.layoverStatus.isHidden = false
            self.layoverStatus.text = "An email has sent to" + self.txtEmail.text!
        }else{
            self.layoverStatus.isHidden = false
            self.layoverStatus.text = "Please fill in username!"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
}
