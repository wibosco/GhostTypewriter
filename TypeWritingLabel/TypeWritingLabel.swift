//
//  TypeWritingLabel.swift
//  TypeWritingLabel
//
//  Created by William Boles on 19/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class TypeWritingLabel: UILabel {
    
    var typingTimeInterval: TimeInterval = 0.1
    var animationTimer: Timer?
    
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
    
    deinit {
        animationTimer?.invalidate()
    }
    
    // MARK: - TypingAnimation
    
    func startTypewriterAnimation(completion: (() -> Void)?) {
        stopTypewriterAnimation()
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
                self.stopTypewriterAnimation()
            }
        })
    }
    
    func stopTypewriterAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    // MARK: - Configure
    
    private func setAlphaOnAttributedText(alpha: CGFloat, until: Int) {
        let attributedString = NSMutableAttributedString(attributedString: attributedText!)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor.withAlphaComponent(alpha), range: NSRange(location:0, length: until))
        attributedText = attributedString
    }
}
