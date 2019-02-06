//
//  VerificationResultViewController.swift
//  Phone Verification
//
//  Created by Kelley Robinson on 7/3/18.
//  Copyright © 2018 krobs. All rights reserved.
//

import UIKit

class VerificationResultViewController: UIViewController {
    
    @IBOutlet var successIndication: UILabel! = UILabel()
    
    var successMessage: String?
    
    override func viewDidLoad() {
        if let resultToDisplay = successMessage {
            successIndication.text = resultToDisplay
        } else {
            successIndication.text = "Something went wrong!"
        }
        super.viewDidLoad()
    }
}

