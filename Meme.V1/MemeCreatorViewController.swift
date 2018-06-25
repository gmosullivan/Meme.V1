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
    @IBOutlet weak var shareButton: UIButton!
    
    //MARK: - Application Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        shareButton.isEnabled = false //Disables the share button until user has created meme
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
    
}

