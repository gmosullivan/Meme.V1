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
    @IBOutlet weak var shareButton: UIBarButtonItem!
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
        configureTextField(topTextField, withText: "TOP")
        configureTextField(bottomTextField, withText: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) // Disables camera button if no camera
        shareButton.isEnabled = imageSelected
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
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    @IBAction func takePhoto() {
        presentImagePickerWith(sourceType: .camera)
    }
    
    //MARK: - Text Field Delegate Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Image Picker Delegate Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageForMeme.image = image
            imageSelected = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Present Image Picker
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
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
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
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
        hideBars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let generatedMeme = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideBars(false)
        return generatedMeme
    }
    
    //MARK: - Saving Meme
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageForMeme.image!, memedImage: memedImage!)
    }
    
    //MARK: - Configure Text Field Functions
    
    func configureTextField(_ textField: UITextField, withText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = withText
        textField.adjustsFontSizeToFitWidth = true
    }
    
    func hideBars(_ hidden: Bool ) {
        navBar.isHidden = hidden
        toolbar.isHidden = hidden
    }
    
}

