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
    
    /// The interval (time gap) between each character being animated on screen.
    public var typingTimeInterval: TimeInterval = 0.1
    
    /// Factory for making timers
    var timerFactory: TimerFactoryType = TimerFactory()
    
    /// Timer instance that control's the animation.
    private var timer: TimerType?
    
    /// Current offset for next character to be revealed.
    private var currentCharacterOffset: Int = 0
    
    ///Type alias for completion closure.
    public typealias TypewriterLabelCompletion = () -> ()
    
    /// A callback closure for when the type writing animation is complete.
    private var completion: TypewriterLabelCompletion?
    
    /// Boolean for if the label is animating or not.
    public private(set) var isAnimating: Bool = false
    
    // MARK: - Lifecycle
    
    /**
     Triggered when label is added to superview, will configure label with provided transparency.
     
     - Parameter newSuperview: View that label is added to.
     */
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        hideAttributedText()
    }
    
    /**
     Tidies the animation up if it's still in progress by invalidating the timer.
     */
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Controls
    
    /**
     Starts the type writing animation.
     
     - Parameter completion: A callback closure for when the type writing animation is complete.
     */
    public func startTypewritingAnimation(completion: TypewriterLabelCompletion? = nil) {
        self.completion = completion
        
        if currentCharacterOffset == 0 {
            hideAttributedText()
        }
        
        timer = timerFactory.buildScheduledTimer(withTimeInterval: typingTimeInterval, repeats: true, block: { _ in
            /*
             As each character is revealed the `attributedText` property value of this label
             is overridden so we need to keep fetching it inside this timer block.
             */
            guard let attributedText = self.attributedText, self.currentCharacterOffset < attributedText.string.count else {
                completion?()
                self.stopTypewritingAnimation()
                return
            }
            
            let characterIndex = attributedText.string.index(attributedText.string.startIndex, offsetBy: self.currentCharacterOffset)
            self.revealCharacter(atIndex: characterIndex)
            
            self.currentCharacterOffset += 1
        })
        
        isAnimating = true
    }
    
    /**
     Adjusts the alpha value on the attributed string at the given index.
     
     - Parameter characterIndex: Index that the alpha value will be applied to.
     */
    private func revealCharacter(atIndex characterIndex: String.Index) {
        let range = characterIndex...characterIndex
  
        updateAttributedTextVisibility(to: alpha, range: range)
    }
    
    /**
     Stops the type writing animation.
     
     Any characters that have been animated on screen, remain on screen.
     */
    public func stopTypewritingAnimation() {
        isAnimating = false
        
        timer?.invalidate()
        timer = nil
    }
    
    /**
     Resets the type writing animation.
     
     Hides the labels text.
     
     Does *not* restart the animation again.
     */
    public func resetTypewritingAnimation() {
        stopTypewritingAnimation()
        hideAttributedText()
        currentCharacterOffset = 0
    }
    
    /**
     Restarts the type writing animation.
     
     - Parameter completion: A callback closure for when the type writing animation is complete.
     */
    public func restartTypewritingAnimation(completion: TypewriterLabelCompletion? = nil) {
        resetTypewritingAnimation()
        startTypewritingAnimation(completion: completion)
    }
    
    /**
     Abruptly completes the remaining type writing animation without an animation.
     */
    public func completeTypewritingAnimation() {
        stopTypewritingAnimation()
        showAttributedText()
        currentCharacterOffset = 0
        
        completion?()
    }
    
    // MARK: - Visibility
    
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
        guard let attributedText = attributedText else {
            return
        }
        let range = attributedText.string.startIndex..<attributedText.string.endIndex
        
        updateAttributedTextVisibility(to: alpha, range: range)
    }
    
    /**
     Adjusts the alpha value on the attributed string within the given range.
     
     - Parameter alpha: Alpha value the attributed string's characters will be set to.
     - Parameter range: Range of attributed string's characters that the alpha value will be applied to.
     */
    private func updateAttributedTextVisibility<R: RangeExpression>(to alpha: CGFloat, range: R) where R.Bound == String.Index {
        guard let attributedText = attributedText else {
            return
        }
        
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        let nsRange = NSRange(range, in: attributedText.string)
        attributedText.enumerateAttribute(.foregroundColor, in: nsRange, options: []) { (value, range, stop) -> Void in
            let color: UIColor
            if let colorValue = value as? UIColor {
                color = colorValue
            } else {
                color = textColor
            }
        
            let adjustedColor = color.withAlphaComponent(alpha)
            attributedString.addAttribute(.foregroundColor, value: adjustedColor, range: range)
        }
        
        self.attributedText = attributedString
    }
}
