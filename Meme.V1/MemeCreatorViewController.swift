//
//  ViewController.swift
//  Meme.V1
//
//  Created by Gareth O'Sullivan on 25/06/2018.
//  Copyright © 2018 Locust Redemption. All rights reserved.
//

import UIKit

class MemeCreatorViewController: UIViewController {
    
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
    
}

