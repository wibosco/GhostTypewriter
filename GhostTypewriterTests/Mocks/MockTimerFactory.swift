//
//  MockTimerFactory.swift
//  GhostTypewriter
//
//  Created by Boles, William (Developer) on 29/01/2020.
//  Copyright © 2020 Boles. All rights reserved.
//

import Foundation

@testable import GhostTypewriter

class MockTimerFactory: TimerFactoryType {
    
    var buildScheduledTimerClosure: ((_ interval: TimeInterval, _ repeats: Bool, _ block: @escaping (TimerType) -> Void) -> ())?
    
    var mockTimer = MockTimer()
    
    func buildScheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (TimerType) -> Void) -> TimerType {
        buildScheduledTimerClosure?(interval, repeats, block)
        
        return mockTimer
    }
}
