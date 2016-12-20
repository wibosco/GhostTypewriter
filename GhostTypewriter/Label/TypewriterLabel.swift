//
//  GhoastTypewriter.swift
//  GhostTypeWriter
//
//  Created by William Boles on 19/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

public class TypewriterLabel: UILabel {
    
    /// Interval (time gap) between each character being animated on screen.
    public var typingTimeInterval: TimeInterval = 0.1
    
    /// Timer instance that control's the animation.
    private var animationTimer: Timer?
    
    /// Allows for text to be hidden before animation begins.
    public var hideTextBeforeTypewritingAnimation = true {
        didSet {
            if hideTextBeforeTypewritingAnimation {
                setAttributedTextColorToTransparent()
            } else {
                setAttributedTextColorToOpaque()
            }
        }
    }
    
    // MARK: - Init
    
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
        setAttributedTextColorToTransparent()
        stopTypewritingAnimation()
        var animateUntilCharacterIndex = 1
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: typingTimeInterval, repeats: true, block: { (timer: Timer) in
            guard let labelText = self.attributedText?.string else {
                return
            }
        
            let charactersCount = labelText.characters.count
            
            if animateUntilCharacterIndex <= charactersCount {
                self.setAlphaOnAttributedText(alpha: CGFloat(1), until: animateUntilCharacterIndex)
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
     Adjusts the alpha value on the attributed string so that it is transparent.
     */
    private func setAttributedTextColorToTransparent() {
        if hideTextBeforeTypewritingAnimation {
            if let text = text {
                setAlphaOnAttributedText(alpha: CGFloat(0), until: text.characters.count)
            }
        }
    }
    
    /**
     Adjusts the alpha value on the attributed string so that it is opaque.
     */
    private func setAttributedTextColorToOpaque() {
        if !hideTextBeforeTypewritingAnimation {
            if let text = text {
                setAlphaOnAttributedText(alpha: CGFloat(1), until: text.characters.count)
            }
        }
    }
    
    /**
     Adjusts the alpha value on the attributed string until (inclusive) a certain character length.
     
     - Parameter alpha: alpha value the attributed string's characters will be set to.
     - Parameter until: upper bound of attributed string's characters that the alpha value will be applied to.
     */
    private func setAlphaOnAttributedText(alpha: CGFloat, until: Int) {
        let attributedString = NSMutableAttributedString(attributedString: attributedText!)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor.withAlphaComponent(alpha), range: NSRange(location:0, length: until))
        attributedText = attributedString
    }
}
