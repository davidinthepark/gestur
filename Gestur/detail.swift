//
//  detail.swift
//  Gestur
//
//  Created by tk on 08/11/2017.
//  Copyright © 2017 tk. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class detailController: UIViewController {
    
    @IBOutlet weak var mainStackView: UIStackView!
    var userEmail:String?
    
    @IBOutlet weak var accountEmail: UILabel!
    @IBOutlet weak var accountUserName: UILabel!
    @IBOutlet weak var oneThreePack: UIButton!
    @IBOutlet weak var fourSixPack: UIButton!
    @IBOutlet weak var sevenNinePack: UIButton!
    @IBOutlet var settingTitle: UINavigationBar!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
//    <? Account Section
    @IBAction func ChangePasswordClicked(_ sender: UIButton) {
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                Auth.auth().sendPasswordReset(withEmail: (user?.email)!) { error in
                }
                let alert = UIAlertController(title: "Change Password", message: "Are you sure you want to change your password?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .`default`, handler: { _ in
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .`cancel`, handler: { _ in
                    let alert = UIAlertController(title: "Change Password", message: "Changing password email has been sent to your email address.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                self.switchStoryboard()
            }
        }
    }
    
    @IBAction func logOutClicked(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.switchStoryboard()
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
                self.accountEmail.text = user?.email
                Database.database().reference().child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let username = value?["username"] as? String ?? ""
                    self.accountUserName.text = username
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
            }else{
                self.switchStoryboard()
            }
        }
        
        mainStackView.layoutMargins = UIEdgeInsets(top:0, left:20, bottom:0, right:20)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        
        if (lblAccount.text == "Account"){
            disableButton(button: EnglishButton)
        }else{
            disableButton(button: ChineseButton)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    Account section>
    
    
//    <? purchase function
    func buyPack(message: String){
        let alert = UIAlertController(title: "Purchase Language Pack", message: "You are purchasing " + message + " pack. After purchasing this language pack, your device will be able to translate " + message + " .", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Purchase", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func oneThreeButtonClicked(_ sender: UIButton) {
        buyPack(message: (sender.titleLabel?.text)!)
    }
    
    @IBAction func fourSixButtonClicked(_ sender: UIButton) {
        buyPack(message: (sender.titleLabel?.text)!)
    }
    
    @IBAction func sevenNineButtonClicked(_ sender: UIButton) {
        buyPack(message: (sender.titleLabel?.text)!)
    }
//   purchase function>



    @IBAction func cameraButtonClicked(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let camera = storyBoard.instantiateViewController(withIdentifier: "camera")
        self.present(camera, animated: true, completion: nil)
    }
    //    <? language support

    @IBOutlet var EnglishButton: UIButton!
    @IBOutlet var ChineseButton: UIButton!
    @IBOutlet var lblAccount: UILabel!
    @IBOutlet var lblPayment: UILabel!
    @IBOutlet var lblLanguage: UILabel!
    
   
    
    @IBAction func EnglishButtonClicked(_ sender: UIButton) {
        EnglishClicked()
    }
    @IBAction func ChineseButtonClicked(_ sender: UIButton) {
        ChineseClicked()
    }
    func EnglishClicked() {
        ChineseButton.setTitle("Chinese/中文", for: .normal)
        EnglishButton.setTitle("English", for: .normal)
        settingTitle.topItem?.title = "Setting"
        lblAccount.text = "Account"
        lblPayment.text = "Payment"
        lblLanguage.text = "Language"
        ChineseButton.isEnabled = true
        disableButton(button: EnglishButton)
    }
    
    func ChineseClicked() {
        ChineseButton.setTitle("简体中文/Simplified Chinese", for: .normal)
        EnglishButton.setTitle("英文／English", for: .normal)
        settingTitle.topItem?.title = "设置"
        lblAccount.text = "账户"
        lblPayment.text = "支付"
        lblLanguage.text = "语言"
        EnglishButton.isEnabled = true
        disableButton(button: ChineseButton)
    }
    
    func disableButton(button: UIButton){
        button.isEnabled = false
        button.setTitleColor(UIColor.lightGray, for: .disabled)
    }
//    language support>
}
