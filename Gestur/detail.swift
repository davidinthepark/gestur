//
//  detail.swift
//  Gestur
//
//  Created by tk on 08/11/2017.
//  Copyright © 2017 tk. All rights reserved.
//

import Foundation
import UIKit

class detailController: UIViewController {
   
    @IBOutlet var settingTitle: UINavigationBar!
    @IBOutlet var EnglishButton: UIButton!
    @IBOutlet var ChineseButton: UIButton!
    @IBOutlet var SelectButton: UIButton!
    @IBOutlet var CameraButton: UIBarButtonItem!
    @IBOutlet var buttons: [UIButton]!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnglishButton.isEnabled = false
        EnglishButton.setTitleColor(UIColor.lightGray, for: .disabled)
        ChineseButton.setTitleColor(UIColor.lightGray, for: .disabled)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func handleButtonSelection(){
        buttons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    @IBAction func handleSelection(_ sender: UIButton) {
       handleButtonSelection()
    }
    
    @IBAction func cameraButtonClicked(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let camera = storyBoard.instantiateViewController(withIdentifier: "camera")
        self.present(camera, animated: true, completion: nil)
    }
    @IBAction func EnglishClicked(_ sender: UIButton) {
        SelectButton.setTitle("Select a language", for: .normal)
        ChineseButton.setTitle("Chinese/中文", for: .normal)
        EnglishButton.setTitle("English", for: .normal)
        CameraButton.title="Camera"
        settingTitle.topItem?.title = "Setting"
        EnglishButton.isEnabled = false
        EnglishButton.setTitleColor(UIColor.lightGray, for: .disabled)
        ChineseButton.isEnabled = true
        handleButtonSelection()
    }
    
    @IBAction func ChineseClicked(_ sender: UIButton) {
       SelectButton.setTitle("请选择语言", for: .normal)
        ChineseButton.setTitle("中文", for: .normal)
        EnglishButton.setTitle("英文／English", for: .normal)
        CameraButton.title="相机"
        settingTitle.topItem?.title = "设置"
        ChineseButton.isEnabled = false
        EnglishButton.isEnabled = true
        handleButtonSelection()
    }
    
}
