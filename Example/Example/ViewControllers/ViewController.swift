//
//  ViewController.swift
//  Example
//
//  Created by William Boles on 19/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit
import TypeWriting

class ViewController: UIViewController {

    @IBOutlet var titleLabel: TypeWritingLabel!
    @IBOutlet var descriptionLabel: TypeWritingLabel!
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.hideTextBeforeTypewritingAnimation = true
        descriptionLabel.hideTextBeforeTypewritingAnimation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateLabels()
    }
    
    // MARK: - Animation
    
    func animateLabels() {
        titleLabel.startTypewritingAnimation { 
            self.descriptionLabel.startTypewritingAnimation(completion: nil)
        }
    }
}

