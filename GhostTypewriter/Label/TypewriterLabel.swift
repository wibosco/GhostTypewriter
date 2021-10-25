//
//  GhoastTypewriter.swift
//  GhostTypeWriter
//
//  Created by William Boles on 19/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
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

/// A UILabel subclass that adds a ghost type writing animation effect.
public final class TypewriterLabel: UILabel {
    
    private lazy var animation: TypewriterAnimation = {
        let animation = TypewriterAnimation()
        animation.delegate = self
        
        return animation
    }()
    
    /// The interval (time gap) between each character being animated on screen.
    public var typingTimeInterval: TimeInterval {
        get {
            animation.typingTimeInterval
        }
        set {
            animation.typingTimeInterval = newValue
        }
    }
    
    /// Boolean for if the label is animating or not.
    public var isAnimating: Bool {
        animation.isAnimating
    }
    
    /// Boolean indicting if the label has completed its animation.
    public var isComplete: Bool {
        animation.isComplete
    }
    
    /// The style that will be used when animating each character. NB. Setting this will cause the animation to reset.
    public var animationStyle: AnimationStyle {
        get {
            animation.animationStyle
        }
        set {
            animation.animationStyle = newValue
        }
    }
    
    /// The direction that the animation will traverse the labels content in. NB. Setting this will cause the animation to reset.
    public var animationDirection: AnimationDirection {
        get {
            animation.animationDirection
        }
        set {
            animation.animationDirection = newValue
        }
    }
    
    ///Type alias for completion closure.
    public typealias TypewriterLabelCompletion = () -> ()

    // MARK: - Lifecycle
    
    /**
     Triggered when label is added to superview, will configure label with provided transparency.
     
     - Parameter newSuperview: View that the label is added to.
     */
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    
        animation.attributedText = attributedText ?? NSAttributedString(string: "")
        animation.nonAttributedTextColor = textColor
        animation.resetTypewritingAnimation()
    }
    
    /**
     Triggered when label created via the storyboard.
     */
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        animation.resetTypewritingAnimation()
    }

    // MARK: - Controls
    
    /**
     Starts the type writing animation.
     
     If the animation was previously stopped, calling `play` will resume the animation from the stopped position.
     
     - Parameter completion: A callback closure for when the type writing animation is complete.
     */
    public func startTypewritingAnimation(completion: TypewriterLabelCompletion? = nil) {
        animation.startTypewritingAnimation(completion: completion)
    }
    
    /**
     Stops the type writing animation.
     
     Any characters that have been animated on/off screen, remain on/off screen.
     */
    public func stopTypewritingAnimation() {
        animation.stopTypewritingAnimation()
    }
    
    /**
     Resets the type writing animation back to its starting state.
     
     Does *not* restart the animation again.
     */
    public func resetTypewritingAnimation() {
        animation.resetTypewritingAnimation()
    }
    
    /**
     Restarts the type writing animation from its initial state.
     */
    public func restartTypewritingAnimation(completion: TypewriterLabelCompletion? = nil) {
        animation.restartTypewritingAnimation(completion: completion)
    }
    
    /**
     Completes the type writing animation.
     */
    public func completeTypewritingAnimation() {
        animation.completeTypewritingAnimation()
    }
}

extension TypewriterLabel: TypewriterAnimationDelegate {
    func update(to attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }
}

public extension TypewriterLabel {
    func styleAsMultilineForwardlyRevealingAnimation() {
        animationStyle = .reveal
        animationDirection = .forward
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    func styleAsMultilineBackwardlyHidingAnimation() {
        animationStyle = .hide
        animationDirection = .backward
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
}
