//
//  TypewriterAnimator.swift
//  GhostTypewriter
//
//  Created by William Boles on 25/10/2021.
//  Copyright © 2021 Boles. All rights reserved.
//

import UIKit

/// An enum to control the direction of the animation i.e. from index 0 or index `n-1`.
public enum AnimationDirection {
    case forward
    case backward
    
    // MARK: - Helpers
    
    /**
     A helper to determine if the enum case is `forward`.
     
     - Returns: `true` if it is `forward`, `false` otherwise.
     */
    var isForward: Bool {
        self == .forward
    }
    
    /**
     A helper to determine if the enum case is `backward`.
     
     - Returns: `true` if it is `backward`, `false` otherwise.
     */
    var isBackward: Bool {
        self == .backward
    }
}

/// An enum to control whether the animation reveals or hides each character it comes to.
public enum AnimationStyle {
    case reveal
    case hide
    
    // MARK: - Helpers
    
    /**
     A helper to determine if the enum case is `reveal`.
     
     - Returns: `true` if it is `reveal`, `false` otherwise.
     */
    var isReveal: Bool {
        self == .reveal
    }
    
    /**
     A helper to determine if the enum case is `hide`.
     
     - Returns: `true` if it is `hide`, `false` otherwise.
     */
    var isHide: Bool {
        self == .hide
    }
}


public class TypewriterAnimator {
    private let label: UILabel
    
    public var typingTimeInterval: TimeInterval = 0.1
    
    /// Boolean for if the label is animating or not.
    public private(set) var isAnimating: Bool = false
    
    /// Boolean for if the typewriter animation is complete or not.
    public var isComplete: Bool {
        guard let attributedText = label.attributedText else {
            return true
        }
        
        if animationDirection.isForward {
            return currentCharacterOffset == attributedText.string.count
        } else {
            return currentCharacterOffset == -1
        }
    }
    
    /// The style that will be used when animating each character.
    public var animationStyle: AnimationStyle = .reveal {
        didSet {
            resetTypewritingAnimation()
        }
    }
    
    /// The direction that the animation will traverse the labels content in.
    public var animationDirection: AnimationDirection = .forward {
        didSet {
            resetTypewritingAnimation()
        }
    }
    
    /// Factory for making timers
    var timerFactory: TimerFactoryType = TimerFactory()
    
    /// Timer instance that control's the animation.
    private var timer: TimerType?
    
    /// Current offset for next character to be revealed.
    private var currentCharacterOffset: Int = 0
    
    /// Starting character offset
    private var startingCharacterOffset: Int {
        if animationDirection.isForward {
            return 0
        } else {
            return ((label.attributedText?.string.count ?? 1) - 1)
        }
    }
    
    ///Type alias for completion closure.
    public typealias TypewriterLabelCompletion = () -> ()
    
    /// A callback closure for when the type writing animation is complete.
    private var completion: TypewriterLabelCompletion?
    
    // MARK: - Lifecycle
    
    public init(label: UILabel) {
        self.label = label
        resetTypewritingAnimation()
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
        
        if startingCharacterOffset == currentCharacterOffset {
            resetTypewritingAnimation()
        }
        
        timer = timerFactory.buildScheduledTimer(withTimeInterval: typingTimeInterval, repeats: true, block: { _ in
            /*
             As each character is revealed the `attributedText` property value of this label
             is overridden so we need to keep fetching it inside this timer block.
             */
            guard let attributedText = self.label.attributedText, !self.isComplete else {
                completion?()
                self.stopTypewritingAnimation()
                return
            }
            
            let characterIndex = attributedText.string.index(attributedText.string.startIndex, offsetBy: self.currentCharacterOffset)
            self.updateCharacterPresentation(atIndex: characterIndex)
            
            self.iterateToNextCharacterOffset()
        })
        
        isAnimating = true
    }
    
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
        updateToStartPresentationState()
        resetCharacterOffset()
    }
    
    
    /**
     Resets character offset back to it's initial offset based on config settings.
     */
    private func resetCharacterOffset() {
        if animationDirection.isForward {
            currentCharacterOffset = 0
        } else {
            currentCharacterOffset = ((label.attributedText?.string.count ?? 1) - 1)
        }
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
        updateToFinishedPresentationState()
        resetCharacterOffset()
        
        completion?()
    }
    
    // MARK: - Visibility
    
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
    private func updateToFinishedPresentationState() {
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
        guard let attributedText = label.attributedText else {
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
        guard let attributedText = label.attributedText else {
            return
        }
        
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        let nsRange = NSRange(range, in: attributedText.string)
        attributedText.enumerateAttribute(.foregroundColor, in: nsRange, options: []) { (value, range, stop) -> Void in
            let color: UIColor
            if let colorValue = value as? UIColor {
                color = colorValue
            } else {
                color = label.textColor
            }
            
            let adjustedColor = color.withAlphaComponent(alpha)
            attributedString.addAttribute(.foregroundColor, value: adjustedColor, range: range)
        }
        
        self.label.attributedText = attributedString
    }
}

public extension TypewriterAnimator {
    static func forwardlyRevealing(label: UILabel) -> TypewriterAnimator {
        let animator = TypewriterAnimator(label: label)
        animator.animationDirection = .forward
        animator.animationStyle = .reveal
        
        return animator
    }
    
    static func backwardlyHiding(label: UILabel) -> TypewriterAnimator {
        let animator = TypewriterAnimator(label: label)
        animator.animationDirection = .backward
        animator.animationStyle = .hide
        
        return animator
    }
}
