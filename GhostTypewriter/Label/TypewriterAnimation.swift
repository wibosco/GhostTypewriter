//
//  TypewriterViewModel.swift
//  GhostTypewriter
//
//  Created by William Boles on 25/10/2021.
//  Copyright © 2021 Boles. All rights reserved.
//

import UIKit

protocol TypewriterAnimationDelegate: AnyObject {
    func update(to attributedText: NSAttributedString)
}

class TypewriterAnimation {
    weak var delegate: TypewriterAnimationDelegate?
    var attributedText: NSAttributedString = NSAttributedString(string: "")
    var nonAttributedTextColor: UIColor = .black
    
    /// The interval (time gap) between each character being animated on screen.
    var typingTimeInterval: TimeInterval = 0.1
    
    /// Boolean for if the label is animating or not.
    private(set) var isAnimating: Bool = false
    
    /// Boolean for if the typewriter animation is complete or not.
    public var isComplete: Bool {
        if animationDirection.isForward {
            return currentCharacterOffset == attributedText.string.count
        } else {
            return currentCharacterOffset == -1
        }
    }
    
    /// The style that will be used when animating each character. NB. Setting this will cause the animation to reset.
    var animationStyle: AnimationStyle = .reveal {
        didSet {
            resetTypewritingAnimation()
        }
    }
    
    /// The direction that the animation will traverse the labels content in. NB. Setting this will cause the animation to reset.
    var animationDirection: AnimationDirection = .forward {
        didSet {
            resetTypewritingAnimation()
        }
    }
    
    /// Factory for making timers
    var timerFactory: TimerFactoryType = TimerFactory()
    
    /// Timer instance that control's the animation.
    private var timer: TimerType? {
        didSet {
            oldValue?.invalidate()
        }
    }
    
    /// Current offset for next character to be revealed.
    private var currentCharacterOffset: Int = 0
    
    /// Starting character offset
    private var startingCharacterOffset: Int {
        if animationDirection.isForward {
            return 0
        } else {
            return attributedText.string.count
        }
    }
    
    /// A callback closure for when the type writing animation is complete.
    private var completion: TypewriterLabel.TypewriterLabelCompletion?
    
    // MARK: - Lifecycle

    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Controls
    
    /**
     Starts the type writing animation.
     
     If the animation was previously stopped, calling `play` will resume the animation from the stopped position.
     
     - Parameter completion: A callback closure for when the type writing animation is complete.
     */
    func startTypewritingAnimation(completion: TypewriterLabel.TypewriterLabelCompletion? = nil) {
        self.completion = completion
        
        if startingCharacterOffset == currentCharacterOffset {
            resetTypewritingAnimation()
        }
        
        timer = timerFactory.buildScheduledTimer(withTimeInterval: typingTimeInterval, repeats: true, block: { _ in
            guard !self.isComplete else {
                self.completion?()
                self.stopTypewritingAnimation()
                return
            }
            
            let characterIndex = self.attributedText.string.index(self.attributedText.string.startIndex, offsetBy: self.currentCharacterOffset)
            self.updateCharacterPresentation(atIndex: characterIndex)
            
            self.iterateToNextCharacterOffset()
        })
        
        isAnimating = true
    }
    
    /**
     Stops the type writing animation.
     
     Any characters that have been animated on/off screen, remain on/off screen.
     */
    func stopTypewritingAnimation() {
        isAnimating = false
        
        timer = nil
    }
    
    /**
     Resets the type writing animation back to its starting state.
     
     Does *not* restart the animation again.
     */
    func resetTypewritingAnimation() {
        stopTypewritingAnimation()
        updateToStartPresentationState()
        resetCharacterOffset()
    }
    
    /**
     Restarts the type writing animation from its initial state.
     */
    func restartTypewritingAnimation(completion: TypewriterLabel.TypewriterLabelCompletion? = nil) {
        resetTypewritingAnimation()
        startTypewritingAnimation(completion: completion)
    }
    
    /**
     Completes the type writing animation.
     */
    func completeTypewritingAnimation() {
        stopTypewritingAnimation()
        updateToEndPresentationState()
        resetCharacterOffset()
        
        completion?()
    }
    
    // MARK: - CharacterOffset
    
    /**
     Updates character offset to next index based on config settings.
     */
    private func iterateToNextCharacterOffset() {
        if animationDirection.isForward {
            currentCharacterOffset += 1
        } else {
            currentCharacterOffset -= 1
        }
    }
    
    /**
     Resets character offset back to it's initial offset based on config settings.
     */
    private func resetCharacterOffset() {
        if animationDirection.isForward {
            currentCharacterOffset = 0
        } else {
            currentCharacterOffset = (attributedText.string.count - 1)
        }
    }
    
    // MARK: - Visibility
    
    /**
     Updates the presentation of a character to reveal or hide based on the config settings.
     
     - Parameter characterIndex: Index that the alpha value will be applied to.
     */
    private func updateCharacterPresentation(atIndex characterIndex: String.Index) {
        if animationStyle.isReveal {
            revealCharacter(atIndex: characterIndex)
        } else {
            hideCharacter(atIndex: characterIndex)
        }
    }
    
    /**
     Adjusts the alpha value on the attributed string at the given index to reveal that character.
     
     - Parameter characterIndex: Index that the alpha value will be applied to.
     */
    private func revealCharacter(atIndex characterIndex: String.Index) {
        let range = characterIndex...characterIndex
        
        updateAttributedTextVisibility(to: 1, range: range)
    }
    
    /**
     Adjusts the alpha value on the attributed string at the given index to hide that character.
     
     - Parameter characterIndex: Index that the alpha value will be applied to.
     */
    private func hideCharacter(atIndex characterIndex: String.Index) {
        let range = characterIndex...characterIndex
        
        updateAttributedTextVisibility(to: 0, range: range)
    }
    
    /**
     Sets string to it's start presentation state based on config settings.
     */
    private func updateToStartPresentationState() {
        if animationStyle.isReveal {
            hideAttributedText()
        } else {
            showAttributedText()
        }
    }
    
    /**
     Sets string to it's finished presentation state based on config settings.
     */
    private func updateToEndPresentationState() {
        if animationStyle.isReveal {
            showAttributedText()
        } else {
            hideAttributedText()
        }
    }
    
    /**
     Adjusts the alpha value on the attributed string so that it is transparent.
     */
    private func hideAttributedText() {
        updateAttributedTextVisibility(to: 0)
    }
    
    /**
     Adjusts the alpha value on the attributed string so that it is opaque.
     */
    private func showAttributedText() {
        updateAttributedTextVisibility(to: 1)
    }
    
    /**
     Adjusts the alpha value on the full attributed string.
     
     - Parameter alpha: Alpha value the attributed string's characters will be set to.
     */
    private func updateAttributedTextVisibility(to alpha: CGFloat) {
        let range = attributedText.string.startIndex..<attributedText.string.endIndex
        
        updateAttributedTextVisibility(to: alpha, range: range)
    }
    
    /**
     Adjusts the alpha value on the attributed string within the given range.
     
     - Parameter alpha: Alpha value the attributed string's characters will be set to.
     - Parameter range: Range of attributed string's characters that the alpha value will be applied to.
     */
    private func updateAttributedTextVisibility<R: RangeExpression>(to alpha: CGFloat, range: R) where R.Bound == String.Index {
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        let nsRange = NSRange(range, in: attributedText.string)
        attributedText.enumerateAttribute(.foregroundColor, in: nsRange, options: []) { (value, range, stop) -> Void in
            let textColor: UIColor
            if let attributedTextColor = value as? UIColor {
                textColor = attributedTextColor
            } else {
                textColor = nonAttributedTextColor
            }
            
            let adjustedTextColor = textColor.withAlphaComponent(alpha)
            attributedString.addAttribute(.foregroundColor, value: adjustedTextColor, range: range)
        }
        
        self.attributedText = attributedString
        
        delegate?.update(to: attributedString)
    }
}
