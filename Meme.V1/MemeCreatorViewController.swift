//
//  ViewController.swift
//  Meme.V1
//
//  Created by Gareth O'Sullivan on 25/06/2018.
//  Copyright © 2018 Locust Redemption. All rights reserved.
//

import UIKit

class MemeCreatorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageForMeme:UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    //MARK: - Memed image
    
    var memedImage: UIImage?
    var imageSelected = false
    
    struct Meme {
        let topText: String
        let bottomText: String
        let originalImage: UIImage
        var memedImage: UIImage
    }
    
    //MARK: - Text Attributes
    
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.0
    ]
    
    //MARK: - Application Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        configureTextField(topTextField, withText: "Top")
        configureTextField(bottomTextField, withText: "Bottom")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        shareButton.isEnabled = false //Disables the share button until user has created meme
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) // Disables camera button if no camera
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeToKeyboardNotifications()
    }

    //MARK: - Button Actions
    
    @IBAction func shareMeme() {
        let generatedMeme = generateMemedImage()
        memedImage = generatedMeme
        let activityController = UIActivityViewController(activityItems: [generatedMeme], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success && error == nil {
                self.save()
                self.dismiss(animated: true, completion: nil)
            } else if error != nil {
                // Handle error
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func chooseImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Text Field Delegate Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.sizeToFit()
        if imageSelected {
        } // Checks to see if share button can be enabled
        return true
    }
    
    //MARK: - Image Picker Delegate Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageSelected = true
            imageForMeme.image = image
        }
        if imageSelected {
            shareButton.isEnabled = true
        } // Checks to see if share button can be enabled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Notification Functions
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -1 * getKeyboardHeight(notification)
            toolbar.isHidden = true
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
        toolbar.isHidden = false
    }
    
    //MARK: - Subscription Functions
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK: - Generating Meme
    
    func generateMemedImage() -> UIImage {
        navBar.isHidden = true
        toolbar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let generatedMeme = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        navBar.isHidden = false
        toolbar.isHidden = false
        return generatedMeme
    }
    
    //MARK: - Saving Meme
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageForMeme.image!, memedImage: memedImage!)
    }
    
    //MARK: - Configure Text Function
    
    func configureTextField(_ textField: UITextField, withText: String) {
        textField.textAlignment = .center
        textField.defaultTextAttributes = memeTextAttributes
        textField.adjustsFontSizeToFitWidth = true
    }
    
}

