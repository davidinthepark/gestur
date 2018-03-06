//
//  ViewController.swift
//  Gestur
//
//  Created by tk on 31/10/2017.
//  Copyright © 2017 tk. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import Firebase

class mainController: UIViewController {

    let animator = Animator()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.ifLoggedInSwitch()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ifLoggedInSwitch() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "setting") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        destination.transitioningDelegate = animator
    }

}

