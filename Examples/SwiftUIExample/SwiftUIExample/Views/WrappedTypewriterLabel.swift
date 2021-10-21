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
    case start
    case stop
    case reset
    case restart
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
        case .start:
            view.startTypewritingAnimation()
        case .stop:
            view.stopTypewritingAnimation()
        case .reset:
            view.resetTypewritingAnimation()
        case .restart:
            view.restartTypewritingAnimation()
        case .complete:
            view.completeTypewritingAnimation()
        }
        
        DispatchQueue.main.async {
            dynamicHeight = view.sizeThatFits(CGSize(width: view.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
        }
    }
}