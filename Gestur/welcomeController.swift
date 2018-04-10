//
//  welcomeController.swift
//  Gestur
//
//  Created by David Park on 4/10/18.
//  Copyright © 2018 tk. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class welcomeController: UIViewController {

    @IBOutlet weak var mainStackView: UIStackView!
    var userEmail:String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func switchStoryboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "mainController") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
            Database.database().reference().child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }else{
                self.switchStoryboard()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
