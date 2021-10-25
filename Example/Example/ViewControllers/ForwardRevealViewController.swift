//
//  ViewController.swift
//  Example
//
//  Created by William Boles on 19/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit
import GhostTypewriter

class ForwardRevealViewController: UIViewController {
    @IBOutlet weak private var stackView: UIStackView!
    
    @IBOutlet weak private var startButton: UIButton!
    @IBOutlet weak private var stopButton: UIButton!
    @IBOutlet weak private var resetButton: UIButton!
    @IBOutlet weak private var restartButton: UIButton!
    @IBOutlet weak private var completeButton: UIButton!
    
    @IBOutlet weak private var titleLabel: UILabel! {
        didSet {
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.numberOfLines = 0
            titleLabelTypewriterAnimator = TypewriterAnimator.forwardlyRevealing(label: titleLabel)
        }
    }
    
    private var titleLabelTypewriterAnimator: TypewriterAnimator!
    
    @IBOutlet weak private var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.lineBreakMode = .byWordWrapping
            descriptionLabel.numberOfLines = 0
            descriptionLabelTypewriterAnimator = TypewriterAnimator.forwardlyRevealing(label: descriptionLabel)
        }
    }
    
    private var descriptionLabelTypewriterAnimator: TypewriterAnimator!
    
    private lazy var programmaticLabel: UILabel = {
        let programmaticLabel = UILabel()
        programmaticLabel.lineBreakMode = .byWordWrapping
        programmaticLabel.numberOfLines = 0
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
        
        programmaticLabelTypewriterAnimator = TypewriterAnimator.forwardlyRevealing(label: programmaticLabel)
        
        return programmaticLabel
    }()
    
    private var programmaticLabelTypewriterAnimator: TypewriterAnimator!
    
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

        titleLabelTypewriterAnimator.startTypewritingAnimation {
            if !(self.descriptionLabelTypewriterAnimator.isComplete) {
                self.descriptionLabelTypewriterAnimator.startTypewritingAnimation {
                    if !(self.programmaticLabelTypewriterAnimator.isComplete) {
                        self.programmaticLabelTypewriterAnimator.startTypewritingAnimation {
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
        
        titleLabelTypewriterAnimator.stopTypewritingAnimation()
        descriptionLabelTypewriterAnimator.stopTypewritingAnimation()
        programmaticLabelTypewriterAnimator.stopTypewritingAnimation()
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        startButton.isEnabled = true
        stopButton.isEnabled = false
        resetButton.isEnabled = false
        completeButton.isEnabled = true
        restartButton.isEnabled = false
        
        titleLabelTypewriterAnimator.resetTypewritingAnimation()
        descriptionLabelTypewriterAnimator.resetTypewritingAnimation()
        programmaticLabelTypewriterAnimator.resetTypewritingAnimation()
    }
    
    @IBAction func restartButtonPressed(_ sender: Any) {
        startButton.isEnabled = false
        stopButton.isEnabled = true
        resetButton.isEnabled = true
        completeButton.isEnabled = true
        restartButton.isEnabled = true
        
        descriptionLabelTypewriterAnimator.resetTypewritingAnimation()
        programmaticLabelTypewriterAnimator.resetTypewritingAnimation()
        titleLabelTypewriterAnimator.restartTypewritingAnimation {
            if !(self.descriptionLabelTypewriterAnimator.isComplete) {
                self.descriptionLabelTypewriterAnimator.startTypewritingAnimation {
                    if !(self.programmaticLabelTypewriterAnimator.isComplete) {
                        self.programmaticLabelTypewriterAnimator.startTypewritingAnimation {
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
        
        titleLabelTypewriterAnimator.completeTypewritingAnimation()
        descriptionLabelTypewriterAnimator.completeTypewritingAnimation()
        programmaticLabelTypewriterAnimator.completeTypewritingAnimation()
    }
}
