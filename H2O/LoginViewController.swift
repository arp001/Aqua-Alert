//
//  ViewController.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-10-29.
//  Copyright © 2016 Arpit. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    func uploadGIF() {
        let gifURL = "http://66.media.tumblr.com/70a5de51ef7441345e95d09bd7b84fea/tumblr_of2hkqWcmY1u5946vo1_500.gif"
        let imageURL = UIImage.gifWithURL(gifURL)
        backgroundImage.image = imageURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadGIF()
    }

}

