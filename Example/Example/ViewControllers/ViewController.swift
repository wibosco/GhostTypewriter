//
//  ViewController.swift
//  Example
//
//  Created by William Boles on 19/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit
import GhostTypewriter

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: TypewriterLabel!
    @IBOutlet weak var descriptionLabel: TypewriterLabel!
    @IBOutlet weak var endLabel: TypewriterLabel!
    
    // MARK: ButtonAction
    
    @IBAction func startAnimationButtonPressed(_ sender: Any) {
        titleLabel.cancelTypewritingAnimation()
        descriptionLabel.cancelTypewritingAnimation()
        endLabel.cancelTypewritingAnimation()
        
        titleLabel.startTypewritingAnimation {
            self.descriptionLabel.startTypewritingAnimation {
                self.endLabel.startTypewritingAnimation(completion: nil)
            }
        }
    }
}

