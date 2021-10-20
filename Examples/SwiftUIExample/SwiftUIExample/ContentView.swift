//
//  ContentView.swift
//  SwiftUIExample
//
//  Created by William Boles on 15/10/2021.
//

import SwiftUI
import GhostTypewriter

struct ContentView: View {
    @State private var animationState: TypewriterLabelAnimationState = .stop
    
    @State private var typewriterContentHeight: CGFloat = 0
    
    @State private var animating = false

    private var typewriter: some View {
        WrappedTypewriterLabel(animationState: $animationState, dynamicHeight: $typewriterContentHeight) { typewriterLabel in
            typewriterLabel.styleAsMultilineForwardlyRevealingAnimation()
            
            let title = "The heroic tale 💪 of one developer's pursuit of the perfect typing animation - there will be a 🐲!"
            
            let firstParagraph = "OK...truth time...the part about a dragon and the part about being heroic - not true 😫.\n\nThis really is just an excuse to show you the animation in action and how it can handle any type of regular label text data  😀."
            
            let secondParagraph = "Still not convinced...\n\nWell what about a colourful label? - may that repair our fresh friendship"
            
            let attributedString = NSMutableAttributedString(string: "\(title)\n\n\(firstParagraph)\n\n\(secondParagraph)")

            if let textRange = attributedString.string.range(of: title) {
                let textRange = NSRange(textRange, in: attributedString.string)
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                attributedString.addAttribute(.paragraphStyle, value: style, range: textRange)
                attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: textRange)
            }

            if let textRange = attributedString.string.range(of: firstParagraph) {
                let textRange = NSRange(textRange, in: attributedString.string)
                let style = NSMutableParagraphStyle()
                style.alignment = .left
                attributedString.addAttribute(.paragraphStyle, value: style, range: textRange)
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: textRange)
            }

            if let textRange = attributedString.string.range(of: secondParagraph) {
                let textRange = NSRange(textRange, in: attributedString.string)
                let style = NSMutableParagraphStyle()
                style.alignment = .left
                attributedString.addAttribute(.paragraphStyle, value: style, range: textRange)
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: textRange)
            }

            if let textRange = attributedString.string.range(of: "Still") {
                let textRange = NSRange(textRange, in: attributedString.string)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: textRange)
            }
            
            if let textRange = attributedString.string.range(of: "colourful") {
                let textRange = NSRange(textRange, in: attributedString.string)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: textRange)
            }
            
            if let textRange = attributedString.string.range(of: "fresh") {
                let textRange = NSRange(textRange, in: attributedString.string)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: textRange)
            }
            
            typewriterLabel.attributedText = attributedString
        }
        .frame(height: typewriterContentHeight)
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
        typewriter
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
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
        animationState = .start
        
        animating = true
    }
    
    private func stopAnimation() {
        animationState = .stop
        
        animating = false
    }
    
    private func resetAnimation() {
        animationState = .reset
        
        animating = false
    }
    
    private func restartAnimation() {
        animationState = .restart
    }
    
    private func completeAnimation() {
        animationState = .finish
        
        animating = false
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
