//
//  chineseSettingsTableViewController.swift
//  Gestur
//
//  Created by jxsonl on 4/21/18.
//  Copyright © 2018 tk. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class chineseSettingsTableViewController: UITableViewController {

    @IBOutlet weak var chineseAccountEmail: UILabel!
    @IBOutlet weak var chineseAccountUserName: UILabel!
    
    @IBAction func chineseChangePasswordClicked(_ sender: UIButton) {
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                Auth.auth().sendPasswordReset(withEmail: (user?.email)!) { error in
                }
                let alert = UIAlertController(title: "重设密码", message: "您确定要更改密码吗？", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: "Default action"), style: .`default`, handler: { _ in
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("是", comment: "Default action"), style: .`cancel`, handler: { _ in
                    let alert = UIAlertController(title: "Change Password", message: "请查看您的电子邮件以获取更多指导", preferredStyle: .alert)
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
    
    func switchStoryboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "mainController") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.chineseAccountEmail.text = user?.email
                Database.database().reference().child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let username = value?["username"] as? String ?? ""
                    self.chineseAccountUserName.text = username
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
            }else{
                self.switchStoryboard()
            }
        }
    }
    
    @IBAction func chineseLanguagePack1(_ sender: UIButton) {
        let alert = UIAlertController(title: "购买语言", message: "正在施工", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("购买", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func chineseLanguagePack2(_ sender: UIButton) {
        let alert = UIAlertController(title: "购买语言", message: "正在施工", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("购买", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func chineseLogOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.switchStoryboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
