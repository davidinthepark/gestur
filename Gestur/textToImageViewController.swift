//
//  textToImageViewController.swift
//  Gestur
//
//  Created by tk on 23/04/2018.
//  Copyright © 2018 tk. All rights reserved.
//

import UIKit
import Firebase

class textToImageViewController: UIViewController {

    @IBOutlet var translateButton: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var yPosition:CGFloat = 0;
    var scrollViewContentSize:CGFloat = 0
    @IBAction func translateButtonClicked(_ sender: Any) {
        let subViews = self.scrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
            yPosition = 0;
            scrollViewContentSize = 0;
        }
        let text = textField.text;
        let newArr = text!.split(separator: " ");
        for i in stride(from: 0, to:newArr.count , by: 1){
            let imageName = newArr[i] + ".jpg";
            print("________________________________"+imageName.uppercased());
            let image = UIImage(named: imageName.uppercased());
            let imageView = UIImageView(image: image);
            let textView = UITextView();
            textView.text = String(newArr[i]);
            print("---------- textView: ", textView.text);
            imageView.frame.size.width = scrollView.frame.size.width;
            imageView.frame.size.height = scrollView.frame.size.height;
            imageView.frame.origin.x = 10;
            imageView.frame.origin.y = yPosition;
            textView.frame.size.width = scrollView.frame.size.width;
            textView.frame.size.height = scrollView.frame.size.height;
            textView.frame.origin.x = 10;
            textView.frame.origin.y = yPosition;
            scrollView.addSubview(textView);
            scrollView.addSubview(imageView);
            
            yPosition += imageView.frame.size.height;
            scrollViewContentSize += imageView.frame.size.height;
            scrollView.contentSize = CGSize(width:scrollView.frame.size.width, height: scrollViewContentSize);
        }
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
