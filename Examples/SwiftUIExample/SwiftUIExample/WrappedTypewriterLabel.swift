//
//  WrappedTypewriterLabel.swift
//  SwiftUIExample
//
//  Created by William Boles on 18/10/2021.
//

import Foundation
import SwiftUI
import GhostTypewriter

enum TypewriterLabelAnimationState {
    case start(_ completion: TypewriterLabel.TypewriterLabelCompletion? = nil)
    case stop
    case reset
    case restart(_ completion: TypewriterLabel.TypewriterLabelCompletion? = nil)
    case complete
}

struct WrappedTypewriterLabel: UIViewRepresentable {
    @Binding var dynamicHeight: CGFloat
    @Binding var animationState: TypewriterLabelAnimationState
    
    private let configuration: (TypewriterLabel) -> ()
    
    // MARK: - Init
    
    init(animationState: Binding<TypewriterLabelAnimationState>,
         dynamicHeight: Binding<CGFloat>,
         configuration: @escaping ((TypewriterLabel) -> ())) {
        self._animationState = animationState
        self._dynamicHeight = dynamicHeight
        self.configuration = configuration
    }
    
    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> TypewriterLabel {
        let typewriterLabel = TypewriterLabel()
        typewriterLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        configuration(typewriterLabel)
        
        return typewriterLabel
    }

    func updateUIView(_ view: TypewriterLabel, context: Context) {
        switch animationState {
        case .start(let completion):
            view.startTypewritingAnimation(completion: completion)
        case .stop:
            view.stopTypewritingAnimation()
        case .reset:
            view.resetTypewritingAnimation()
        case .restart(let completion):
            view.restartTypewritingAnimation(completion: completion)
        case .complete:
            view.completeTypewritingAnimation()
        }
        
        DispatchQueue.main.async {
            dynamicHeight = view.sizeThatFits(CGSize(width: view.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
        }
    }
}
