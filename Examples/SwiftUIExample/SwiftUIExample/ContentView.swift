//
//  ContentView.swift
//  SwiftUIExample
//
//  Created by William Boles on 15/10/2021.
//

import SwiftUI
import GhostTypewriter

struct ContentView: View {
    @State private var firstAnimationState: TypewriterLabelAnimationState = .stop
    @State private var secondAnimationState: TypewriterLabelAnimationState = .stop
    @State private var thirdAnimationState: TypewriterLabelAnimationState = .stop
    
    @State private var firstHeight: CGFloat = 0
    @State private var secondHeight: CGFloat = 0
    @State private var thirdHeight: CGFloat = 0
    
    @State private var animating = false
    
    private var first: some View {
        WrappedTypewriterLabel(animationState: $firstAnimationState, dynamicHeight: $firstHeight) { typewriterLabel in
            typewriterLabel.styleAsMultilineForwardlyRevealingAnimation()
            typewriterLabel.font = UIFont.boldSystemFont(ofSize: 24)
            typewriterLabel.textAlignment = .center
            typewriterLabel.text = "The heroic tale 💪 of one developer's pursuit of the perfect typing animation - there will be a 🐲!"
        }
        .frame(height: firstHeight)
    }
    
    private var second: some View {
        WrappedTypewriterLabel(animationState: $secondAnimationState, dynamicHeight: $secondHeight) { typewriterLabel in
            typewriterLabel.styleAsMultilineForwardlyRevealingAnimation()
            typewriterLabel.font = UIFont.systemFont(ofSize: 17)
            typewriterLabel.text = "OK...truth time...the part about a dragon and the part about being heroic - not true 😫.\n\nThis really is just an excuse to show you the animation in action and how it can handle any type of regular label text data  😀."
        }
        .frame(height: secondHeight)
    }
    
    private var third: some View {
        WrappedTypewriterLabel(animationState: $thirdAnimationState, dynamicHeight: $thirdHeight) { typewriterLabel in
            typewriterLabel.styleAsMultilineForwardlyRevealingAnimation()
            typewriterLabel.font = UIFont.systemFont(ofSize: 15)
            let text = "Still not convinced...\n\nWell this label shows support for animating an attributed label - maybe that will soothe you."
            
            let attributedString = NSMutableAttributedString(string: text)

            if let firstTextRange = text.range(of: "Well") {
                let textRange = NSRange(firstTextRange, in: attributedString.string)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: textRange)
            }
            
            if let secondTextRange = text.range(of: "support") {
                let textRange = NSRange(secondTextRange, in: attributedString.string)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: textRange)
            }
            
            if let thirdTextRange = text.range(of: "soothe") {
                let textRange = NSRange(thirdTextRange, in: attributedString.string)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: textRange)
            }
            
            typewriterLabel.attributedText = attributedString
        }
        .frame(height: thirdHeight)
    }
    
    private var startButton: some View {
        Button("Start") {
           startAnimation()
        }
        .disabled(animating == true)
    }
    
    private var stopButton: some View {
        Button("Stop") {
           stopAnimation()
        }
        .disabled(animating == false)
    }
    
    private var resetButton: some View {
        Button("Reset") {
           resetAnimation()
        }
        .disabled(animating == false)
    }
    
    private var restartButton: some View {
        Button("Restart") {
           restartAnimation()
        }
        .disabled(animating == false)
    }
    
    private var completeButton: some View {
        Button("Complete") {
           completeAnimation()
        }
        .disabled(animating == false)
    }
    
    // MARK: - Body
    
    var body: some View {
        first
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
        second
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        third
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        Spacer()
        startButton
        .padding(.bottom, 8)
        HStack {
            Spacer()
            stopButton
            Spacer()
            resetButton
            Spacer()
            restartButton
            Spacer()
            completeButton
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
    
    // MARK: - Controls
    
    private func startAnimation() {
        resetAnimation()
        
        firstAnimationState = .start {
            secondAnimationState = .start {
                thirdAnimationState = .start {
                    animating = false
                }
            }
        }
        
        animating = true
    }
    
    private func stopAnimation() {
        firstAnimationState = .stop
        secondAnimationState = .stop
        thirdAnimationState = .stop
        
        animating = false
    }
    
    private func resetAnimation() {
        firstAnimationState = .reset
        secondAnimationState = .reset
        thirdAnimationState = .reset
        
        animating = false
    }
    
    private func restartAnimation() {
        resetAnimation()
        
        firstAnimationState = .restart {
            secondAnimationState = .restart {
                thirdAnimationState = .restart {
                    animating = false
                }
            }
        }
        
        animating = true
    }
    
    private func completeAnimation() {
        firstAnimationState = .complete
        secondAnimationState = .complete
        thirdAnimationState = .complete
        
        animating = false
    }
}

private extension TypewriterLabel {
    func styleAsMultilineForwardlyRevealingAnimation() {
        animationStyle = .reveal
        animationDirection = .forward
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
   }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
