//
//  TypeWritingLabel.swift
//  TypeWritingLabel
//
//  Created by William Boles on 19/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class TypeWritingLabel: UILabel {
    
    /// Interval (tiem gap) between each character being animated on screen
    var typingTimeInterval: TimeInterval = 0.1
    
    /// Timer instance that control's the animation
    private var animationTimer: Timer?
    
    /// Allows for text to be hidden before animation begins
    var hideTextBeforeTypewritingAnimation = false {
        didSet {
            if hideTextBeforeTypewritingAnimation {
                if let text = text {
                    setAlphaOnAttributedText(alpha: CGFloat(0), until: text.characters.count)
                }
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
     
     - Parameter completion: a callback block/closure for when the type writing animation is complete. This can be useful for chaining multiple animations together
     */
    func startTypewritingAnimation(completion: (() -> Void)?) {
        stopTypewritingAnimation()
        var animateUntilCharacterIndex = 0
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: typingTimeInterval, repeats: true, block: { (timer: Timer) in
            guard let labelText = self.attributedText?.string else {
                return
            }

            animateUntilCharacterIndex += 1
            let charactersCount = labelText.characters.count
            
            if animateUntilCharacterIndex <= charactersCount {
                self.setAlphaOnAttributedText(alpha: CGFloat(1), until: animateUntilCharacterIndex)
            } else {
                completion?()
                self.stopTypewritingAnimation()
            }
        })
    }
    
    /**
     Stops the type writing animation.
     */
    func stopTypewritingAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    // MARK: - Configure
    
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
