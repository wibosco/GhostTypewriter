//
//  ViewController.swift
//  Example
//
//  Created by William Boles on 19/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit
import GhostTypewriter

class BackwardHideViewController: UIViewController {
    @IBOutlet weak private var stackView: UIStackView!
    
    @IBOutlet weak private var startButton: UIButton!
    @IBOutlet weak private var stopButton: UIButton!
    @IBOutlet weak private var resetButton: UIButton!
    @IBOutlet weak private var restartButton: UIButton!
    @IBOutlet weak private var completeButton: UIButton!
    
    @IBOutlet weak private var titleLabel: TypewriterLabel! {
        didSet {
            titleLabel.styleAsMultilineBackwardlyHidingAnimation()
        }
    }
    
    @IBOutlet weak private var descriptionLabel: TypewriterLabel! {
        didSet {
            descriptionLabel.styleAsMultilineBackwardlyHidingAnimation()
        }
    }
    
    private lazy var programmaticLabel: TypewriterLabel = {
        let programmaticLabel = TypewriterLabel()
        programmaticLabel.styleAsMultilineBackwardlyHidingAnimation()
        programmaticLabel.font = UIFont(name: "American Typewriter", size: 15)
        
        let text = "Still not convinced...\n\nWell this label shows support for attributed labels created programmatically rather than via storyboards so maybe that will soothe you."
        
        let attributedString = NSMutableAttributedString(string: text)

        if let programmaticallyTextRange = text.range(of: "programmatically") {
            let programmaticallyTextNSRange = NSRange(programmaticallyTextRange, in: attributedString.string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: programmaticallyTextNSRange)
        }
        
        if let storyboardsTextRange = text.range(of: "storyboards") {
            let storyboardsTextNSRange = NSRange(storyboardsTextRange, in: attributedString.string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: storyboardsTextNSRange)
        }
        
        programmaticLabel.attributedText = attributedString
        
        return programmaticLabel
    }()
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.addArrangedSubview(programmaticLabel)
    }
    
    // MARK: ButtonActions
    
    @IBAction func startAnimationButtonPressed(_ sender: Any) {
        startButton.isEnabled = false
        stopButton.isEnabled = true
        resetButton.isEnabled = true
        completeButton.isEnabled = true
        restartButton.isEnabled = true
        
        programmaticLabel.startTypewritingAnimation {
            if !(self.descriptionLabel.isComplete) {
                self.descriptionLabel.startTypewritingAnimation {
                    if !(self.titleLabel.isComplete) {
                        self.titleLabel.startTypewritingAnimation {
                            self.stopButtonPressed(self.stopButton!)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        startButton.isEnabled = true
        stopButton.isEnabled = false
        resetButton.isEnabled = true
        completeButton.isEnabled = true
        restartButton.isEnabled = true
        
        titleLabel.stopTypewritingAnimation()
        descriptionLabel.stopTypewritingAnimation()
        programmaticLabel.stopTypewritingAnimation()
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        startButton.isEnabled = true
        stopButton.isEnabled = false
        resetButton.isEnabled = false
        completeButton.isEnabled = true
        restartButton.isEnabled = false
        
        titleLabel.resetTypewritingAnimation()
        descriptionLabel.resetTypewritingAnimation()
        programmaticLabel.resetTypewritingAnimation()
    }
    
    @IBAction func restartButtonPressed(_ sender: Any) {
        startButton.isEnabled = false
        stopButton.isEnabled = true
        resetButton.isEnabled = true
        completeButton.isEnabled = true
        restartButton.isEnabled = true
        
        titleLabel.resetTypewritingAnimation()
        descriptionLabel.resetTypewritingAnimation()
        programmaticLabel.restartTypewritingAnimation {
            if !(self.descriptionLabel.isComplete) {
                self.descriptionLabel.startTypewritingAnimation {
                    if !(self.titleLabel.isComplete) {
                        self.titleLabel.startTypewritingAnimation {
                            self.stopButtonPressed(self.stopButton!)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        startButton.isEnabled = false
        stopButton.isEnabled = false
        resetButton.isEnabled = true
        completeButton.isEnabled = false
        restartButton.isEnabled = true
        
        programmaticLabel.completeTypewritingAnimation()
        descriptionLabel.completeTypewritingAnimation()
        titleLabel.completeTypewritingAnimation()
    }
}
