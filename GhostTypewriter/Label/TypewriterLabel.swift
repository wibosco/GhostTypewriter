//
//  GhoastTypewriter.swift
//  GhostTypeWriter
//
//  Created by William Boles on 19/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

/// A UILabel subclass that adds a ghost type writing animation effect.
public class TypewriterLabel: UILabel {
    
    /// Interval (time gap) between each character being animated on screen.
    public var typingTimeInterval: TimeInterval = 0.1
    
    /// Timer instance that control's the animation.
    private var animationTimer: Timer?
    
    /// Allows for text to be hidden before animation begins.
    public var hideTextBeforeTypewritingAnimation = true {
        didSet {
            configureTransparency()
        }
    }
    
    /// Tracks the location of the next character using UTF16 encoding.
    private var utf16CharacterLocation = 0
    
    // MARK: - Lifecycle
    
    /**
     Triggered when label is added to superview, will configure label with provided transparency.
     
     - Parameter toSuperview: view that label is added to.
     */
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configureTransparency()
    }
    
    /**
     Tidies the animation up if it's still in progress by invalidating the timer.
     */
    deinit {
        animationTimer?.invalidate()
    }
    
    // MARK: - TypingAnimation
    
    /**
     Starts the type writing animation.
     
     - Parameter completion: a callback block/closure for when the type writing animation is complete. This can be useful for chaining multiple animations together.
     */
    public func startTypewritingAnimation(completion: (() -> Void)?) {
        guard let attributedText = attributedText else {
            return
        }
        
        setAttributedTextColorToTransparent()
        stopTypewritingAnimation()
        var animateUntilCharacterIndex = 0
        let charactersCount = attributedText.string.count
        utf16CharacterLocation = 0
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: typingTimeInterval, repeats: true, block: { (timer: Timer) in
            if animateUntilCharacterIndex < charactersCount {
                self.setAlphaOnAttributedText(alpha: CGFloat(1), characterIndex: animateUntilCharacterIndex)
                animateUntilCharacterIndex += 1
            } else {
                completion?()
                self.stopTypewritingAnimation()
            }
        })
    }
    
    /**
     Stops the type writing animation.
     */
    public func stopTypewritingAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    /**
     Cancels the typing animation and can clear label's content if `clear` is `true`.
     
     - Parameter clear: sets label's content to transparent when animation is cancelled.
     */
    public func cancelTypewritingAnimation(clearText: Bool = true) {
        if clearText {
            setAttributedTextColorToTransparent()
        }
        stopTypewritingAnimation()
    }
    
    // MARK: - Configure
    
    /**
     Adjust transparency to match value set for `hideTextBeforeTypewritingAnimation`.
    */
    private func configureTransparency() {
        if hideTextBeforeTypewritingAnimation {
            setAttributedTextColorToTransparent()
        } else {
            setAttributedTextColorToOpaque()
        }
    }
    
    /**
     Adjusts the alpha value on the attributed string so that it is transparent.
     */
    private func setAttributedTextColorToTransparent() {
        if hideTextBeforeTypewritingAnimation {
            setAlphaOnAttributedText(alpha: CGFloat(0))
        }
    }
    
    /**
     Adjusts the alpha value on the attributed string so that it is opaque.
     */
    private func setAttributedTextColorToOpaque() {
        if !hideTextBeforeTypewritingAnimation {
            setAlphaOnAttributedText(alpha: CGFloat(1))
        }
    }
    
    /**
     Adjusts the alpha value on the full attributed string.
     
     - Parameter alpha: alpha value the attributed string's characters will be set to.
     */
    private func setAlphaOnAttributedText(alpha: CGFloat) {
        guard let attributedText = attributedText else {
            return
        }
        
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        attributedString.addAttribute(.foregroundColor, value: textColor.withAlphaComponent(alpha), range: NSRange(location:0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
    /**
     Adjusts the alpha value on the attributed string until (inclusive) a certain character length.
     
     - Parameter alpha: alpha value the attributed string's characters will be set to.
     - Parameter characterIndex: upper bound of attributed string's characters that the alpha value will be applied to.
     */
    private func setAlphaOnAttributedText(alpha: CGFloat, characterIndex: Int) {
        guard let attributedText = attributedText else {
            return
        }
        
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        let index = attributedString.string.index(attributedString.string.startIndex, offsetBy: characterIndex)
        let character = "\(attributedString.string[index])"
        let count = character.utf16.count
        attributedString.addAttribute(.foregroundColor, value: textColor.withAlphaComponent(alpha), range: NSRange(location: utf16CharacterLocation, length: count))
        self.attributedText = attributedString
        
        utf16CharacterLocation += count
    }
}
