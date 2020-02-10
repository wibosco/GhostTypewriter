//
//  MockTimer.swift
//  GhostTypewriter
//
//  Created by Boles, William (Developer) on 29/01/2020.
//  Copyright © 2020 Boles. All rights reserved.
//

import Foundation

@testable import GhostTypewriter

class MockTimer: TimerType {
    
    var invalidateClosure: (() -> ())?
    
    // MARK: - Invalidate
    
    func invalidate() {
        invalidateClosure?()
    }
}
