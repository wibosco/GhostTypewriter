//
//  TimerFactory.swift
//  GhostTypewriter
//
//  Created by Boles, William (Developer) on 29/01/2020.
//  Copyright © 2020 Boles. All rights reserved.
//

import Foundation

protocol TimerType {
    func invalidate()
}

extension Timer: TimerType { }

protocol TimerFactoryType {
    func buildScheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block:  @escaping (TimerType) -> Void) -> TimerType
}

class TimerFactory: TimerFactoryType {
    
    // MARK: - Timer
    
    func buildScheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block:  @escaping (TimerType) -> Void) -> TimerType {
        return Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
    }
}
