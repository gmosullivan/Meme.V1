//
//  ViewController.swift
//  Meme.V1
//
//  Created by Gareth O'Sullivan on 25/06/2018.
//  Copyright © 2018 Locust Redemption. All rights reserved.
//

import UIKit

class MemeCreatorViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageForMeme:UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    //MARK: - Text Attributes
    
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: 3.0
    ]
    
    //MARK: - Application Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .center
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        shareButton.isEnabled = false //Disables the share button until user has created meme
        cameraButton.isEnabled = false //Set to disabled until we add the image picker controller
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }

    //MARK: - Button Actions
    
    @IBAction func shareMeme() {
        print("Share Meme!")
    }
    
    @IBAction func chooseImage() {
        print("Choose Image!")
    }
    
    @IBAction func takePhoto() {
        print("Take a Photo!")
    }
    
    //MARK: - Text Field Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if bottomTextField.text != "" && topTextField.text != "" {
            shareButton.isEnabled = true
        } // Checks to see if share button can be enabled
        return true
    }
    
    //MARK: - Notification functions
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
}

