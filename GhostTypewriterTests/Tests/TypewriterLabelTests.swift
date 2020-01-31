//
//  TypewriterLabelTests.swift
//  GhostTypewriterTests
//
//  Created by William Boles on 19/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest
@testable import GhostTypewriter

class TypewriterLabelTests: XCTestCase {
    
    var sut: TypewriterLabel!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        sut = TypewriterLabel()
        sut.text = "Test"
        sut.textColor = .black
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    // MARK: TypingTimeInterval
    
    func test_typingTimeInterval_changeFromDefault() {
        let newTypingTimeInterval = 20.0
        
        let timerFactory = MockTimerFactory()
        
        let timerExpectation = expectation(description: "timerExpectation")
        timerFactory.buildScheduledTimerClosure = { interval, _, _ in
            XCTAssertEqual(interval, newTypingTimeInterval)
            
            timerExpectation.fulfill()
        }
        
        sut.timerFactory = timerFactory
        sut.typingTimeInterval = newTypingTimeInterval
        sut.startTypewritingAnimation()
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    // MARK: Start
    
    func test_start_revealOneCharacterAtATime() {
        let timerFactory = MockTimerFactory()
        
        var timerClosure: ((TimerType) -> ())?
        let timerExpectation = expectation(description: "timerExpectation")
        timerFactory.buildScheduledTimerClosure = { _, _, block in
            timerClosure = block
            
            timerExpectation.fulfill()
        }
        
        sut.timerFactory = timerFactory
        sut.startTypewritingAnimation()
        
        waitForExpectations(timeout: 3.0, handler: nil)
    
        timerClosure?(timerFactory.mockTimer)
        
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, sut.attributedText!.length), options: []) { (value, range, _) -> Void in
            let blackRange = NSRange(location: 0, length: 1)
            let clearRange = NSRange(location: 1, length: 3)

            if range == blackRange {
               XCTAssertEqual(value as! UIColor, UIColor.black)
            } else if range == clearRange {
               XCTAssertEqual(value as! UIColor, UIColor.clear)
            } else {
               XCTFail("Unexpected color")
            }
        }
        
        timerClosure?(timerFactory.mockTimer)
        
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, sut.attributedText!.length), options: []) { (value, range, _) -> Void in
            let blackRange = NSRange(location: 0, length: 2)
            let clearRange = NSRange(location: 2, length: 2)

            if range == blackRange {
               XCTAssertEqual(value as! UIColor, UIColor.black)
            } else if range == clearRange {
               XCTAssertEqual(value as! UIColor, UIColor.clear)
            } else {
               XCTFail("Unexpected color")
            }
        }
    }
    
    func test_start_triggerCompletionCallback() {
        let handlerExpectation = expectation(description: "handlerExpectation")
        
        sut.startTypewritingAnimation {
            handlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func test_start_animationCompletes_revealFullText() {
        let handlerExpectation = expectation(description: "handlerExpectation")
        sut.startTypewritingAnimation {
            handlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
        
        let fullRange = NSMakeRange(0, sut.attributedText!.length)
        
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: fullRange, options: [])  { (value, range, _) -> Void in
            let blackRange = NSRange(location: 0, length: 4)
            
            XCTAssertEqual(value as! UIColor, UIColor.black)
            XCTAssertEqual(range, blackRange)
        }
    }
    
    func test_start_multipleTextStylesApplied_completes_stylesPerserved() {
        let blackText = "black"
        let redText = "red"
        let combinedText = blackText + " " + redText
        let attributedString = NSMutableAttributedString(string: combinedText)
        
        let blackTextRange = combinedText.range(of: blackText)!
        let blackTextNSRange = NSRange(blackTextRange, in: attributedString.string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: blackTextNSRange)
        
        let redTextRange = combinedText.range(of: redText)!
        let redTextNSRange = NSRange(redTextRange, in: attributedString.string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: redTextNSRange)
        
        sut.attributedText = attributedString
        
        let handlerExpectation = expectation(description: "handlerExpectation")
        sut.startTypewritingAnimation {
            handlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
        
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: blackTextNSRange, options: [])  { (value, range, _) -> Void in
            XCTAssertEqual(value as! UIColor, UIColor.black)
        }
        
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: redTextNSRange, options: [])  { (value, range, _) -> Void in
            XCTAssertEqual(value as! UIColor, UIColor.red)
        }
    }
    
    // MARK: Reset
    
    func test_reset_animationCompleted_hidesFullText() {
        let startExpectation = expectation(description: "startExpectation")
        sut.startTypewritingAnimation {
            startExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
        
        sut.resetTypewritingAnimation()
        
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, sut.attributedText!.length), options: []) { (value, range, _) -> Void in
            XCTAssertEqual(value as! UIColor, UIColor.clear)
        }
    }
    
    func test_reset_animationInProgress_hidesFullText() {
        let timerFactory = MockTimerFactory()
        
        var timerClosure: ((TimerType) -> ())?
        let timerExpectation = expectation(description: "timerExpectation")
        timerFactory.buildScheduledTimerClosure = { _, _, block in
            timerClosure = block
            
            timerExpectation.fulfill()
        }
        
        sut.timerFactory = timerFactory
        sut.startTypewritingAnimation()
        
        waitForExpectations(timeout: 3.0, handler: nil)
        
        timerClosure?(timerFactory.mockTimer)
        
        sut.resetTypewritingAnimation()
        
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, sut.attributedText!.length), options: []) { (value, range, _) -> Void in
            XCTAssertEqual(value as! UIColor, UIColor.clear)
        }
    }
    
    // MARK: Restart
    
    func test_restart_completedAnimation_scheduleNewTimer() {
        let startExpectation = expectation(description: "startExpectation")
        sut.startTypewritingAnimation {
            startExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        let timerFactory = MockTimerFactory()
        
        let timerExpectation = expectation(description: "timerExpectation")
        timerFactory.buildScheduledTimerClosure = { _, _, _ in
            timerExpectation.fulfill()
        }
        
        sut.timerFactory = timerFactory
        sut.restartTypewritingAnimation()
        
       waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_reset_animationInProgress_hidesText_timerFires_revealsFirstCharacter() {
        let firstTimerFactory = MockTimerFactory()
        
        var firstTimerClosure: ((TimerType) -> ())?
        let firstTimerExpectation = expectation(description: "firstTimerExpectation")
        firstTimerFactory.buildScheduledTimerClosure = { _, _, block in
            firstTimerClosure = block
            
            firstTimerExpectation.fulfill()
        }
        
        sut.timerFactory = firstTimerFactory
        sut.startTypewritingAnimation()
        
        wait(for: [firstTimerExpectation], timeout: 3.0)
        
        firstTimerClosure?(firstTimerFactory.mockTimer)
        
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, sut.attributedText!.length), options: []) { (value, range, _) -> Void in
            let blackRange = NSRange(location: 0, length: 1)
            let clearRange = NSRange(location: 1, length: 3)

            if range == blackRange {
               XCTAssertEqual(value as! UIColor, UIColor.black)
            } else if range == clearRange {
               XCTAssertEqual(value as! UIColor, UIColor.clear)
            } else {
               XCTFail("Unexpected color")
            }
        }
        
        let secondTimerFactory = MockTimerFactory()
        
        var secondTimerClosure: ((TimerType) -> ())?
        let secondTimerExpectation = expectation(description: "secondTimerExpectation")
        secondTimerFactory.buildScheduledTimerClosure = { _, _, block in
            secondTimerClosure = block
            
            secondTimerExpectation.fulfill()
        }
        
        sut.timerFactory = secondTimerFactory
        
        sut.restartTypewritingAnimation()
        
        wait(for: [secondTimerExpectation], timeout: 3.0)
        
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, sut.attributedText!.length), options: []) { (value, range, _) -> Void in
            XCTAssertEqual(value as! UIColor, UIColor.clear)
        }
        
        secondTimerClosure?(secondTimerFactory.mockTimer)
               
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, sut.attributedText!.length), options: []) { (value, range, _) -> Void in
            let blackRange = NSRange(location: 0, length: 1)
            let clearRange = NSRange(location: 1, length: 3)
            
            if range == blackRange {
                XCTAssertEqual(value as! UIColor, UIColor.black)
            } else if range == clearRange {
                XCTAssertEqual(value as! UIColor, UIColor.clear)
            } else {
                XCTFail("Unexpected color")
            }
        }
    }
    
    func test_restart_completedAnimation_whenRestartedAnimationCompletes_triggerCompletionCallback() {
        let startExpectation = expectation(description: "startExpectation")
        sut.startTypewritingAnimation {
            startExpectation.fulfill()
        }
        
        wait(for: [startExpectation], timeout: 3.0)
        
        let restartExpectation = expectation(description: "restartExpectation")
        sut.restartTypewritingAnimation {
            restartExpectation.fulfill()
        }
        
        wait(for: [restartExpectation], timeout: 3.0)
    }
    
    // MARK: Stop
    
    func test_stop_leavesTextAsIs() {
        let timerFactory = MockTimerFactory()
        
        var timerClosure: ((TimerType) -> ())?
        let timerExpectation = expectation(description: "timerExpectation")
        timerFactory.buildScheduledTimerClosure = { _, _, block in
            timerClosure = block
            
            timerExpectation.fulfill()
        }
        
        sut.timerFactory = timerFactory
        sut.startTypewritingAnimation()
        
        wait(for: [timerExpectation], timeout: 3.0)
    
        timerClosure?(timerFactory.mockTimer)
        
        let invalidateExpectation = expectation(description: "invalidateExpectation")
        timerFactory.mockTimer.invalidateClosure = {
            invalidateExpectation.fulfill()
        }
        
        sut.stopTypewritingAnimation()
        
        wait(for: [invalidateExpectation], timeout: 3.0)
        
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, sut.attributedText!.length), options: []) { (value, range, _) -> Void in
            let blackRange = NSRange(location: 0, length: 1)
            let clearRange = NSRange(location: 1, length: 3)
            
            if range == blackRange {
                XCTAssertEqual(value as! UIColor, UIColor.black)
            } else if range == clearRange {
                XCTAssertEqual(value as! UIColor, UIColor.clear)
            } else {
                XCTFail("Unexpected color")
            }
        }
    }
    
    // MARK: Complete
    
    func test_complete_revealsFullText() {
        let timerFactory = MockTimerFactory()
        
        var timerClosure: ((TimerType) -> ())?
        let timerExpectation = expectation(description: "timerExpectation")
        timerFactory.buildScheduledTimerClosure = { _, _, block in
            timerClosure = block
            
            timerExpectation.fulfill()
        }
        
        sut.timerFactory = timerFactory
        
        sut.startTypewritingAnimation()
        
        wait(for: [timerExpectation], timeout: 3.0)
        
        sut.completeTypewritingAnimation()
        
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, sut.attributedText!.length), options: []) { (value, range, _) -> Void in
            let blackRange = NSRange(location: 0, length: self.sut.attributedText!.length)
            
            XCTAssertEqual(value as! UIColor, UIColor.black)
            XCTAssertEqual(range, blackRange)
        }
    }
    
    // MARK: Subview
    
    func test_labelAddedAsSubview_hidesText() {
        let view = UIView()
        view.addSubview(sut)
        
        sut.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, sut.attributedText!.length), options: []) { (value, range, _) -> Void in
            XCTAssertEqual(value as! UIColor, UIColor.clear)
        }
    }
}
