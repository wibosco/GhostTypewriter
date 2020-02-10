//
//  TimerFactory.swift
//  GhostTypewriter
//
//  Created by Boles, William (Developer) on 29/01/2020.
//  Copyright © 2020 Boles. All rights reserved.
//

import Foundation

/// A protocol to wrap Timer in to allow for test mocks.
protocol TimerType {
    func invalidate()
}

extension Timer: TimerType { }

/// A protocol to wrap TimerFactory in to allow for test mocks.
protocol TimerFactoryType {
    func buildScheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block:  @escaping (TimerType) -> Void) -> TimerType
}

/// A factory to handle the creation of Timer instances.
class TimerFactory: TimerFactoryType {
    
    // MARK: - Timer
    
    /**
     A factory method to create a timer and is then scheduled on the current run loop in the default mode.
     
     - Parameter interval: The number of seconds between firings of the timer. If interval is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead.
     - Parameter repeats: If true, the timer will repeatedly reschedule itself until invalidated. If false, the timer will be invalidated after it fires.
     - Parameter block: A block to be executed when the timer fires. The block takes a single Timer parameter and has no return value.
     */
    func buildScheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (TimerType) -> Void) -> TimerType {
        return Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
    }
}
