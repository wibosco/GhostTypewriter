//
//  TypewriterLabelTests.swift
//  GhostTypewriterTests
//
//  Created by William Boles on 19/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest
@testable import GhostTypewriter

// TODO: - test delegate methods
class TypewriterLabelTests: XCTestCase {
    
    var label: TypewriterLabel!
    var view: UIView!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        view = UIView()
        label = TypewriterLabel()
        view.addSubview(label)
    }
    
    // MARK: - Tests
    
    // MARK: TypingTimeInterval
    
    func test_typingTimeInterval_change() {
        label.attributedText = NSAttributedString(string: "test")
        label.typingTimeInterval = 0.5
        label.startTypewritingAnimation()
        
        let expectation = self.expectation(description: "Handler called")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            var foregroundColorApplied = 0
            self.label.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, self.label.attributedText!.length), options: []) { (value, range, stop) -> Void in
                foregroundColorApplied += 1
            }
            XCTAssertEqual(foregroundColorApplied, 2) // Hasn't been able to complete the animation due the time interval
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    // MARK: Start
    
    func test_start_inProgress() {
        label.attributedText = NSAttributedString(string: "A significantly large test string")
        label.startTypewritingAnimation()
        
        let expectation = self.expectation(description: "Handler called")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var foregroundColorApplied = 0
            self.label.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, self.label.attributedText!.length), options: []) { (value, range, stop) -> Void in
                foregroundColorApplied += 1
            }
            XCTAssertEqual(foregroundColorApplied, 2)
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func test_start_completionCallback() {
        label.attributedText = NSAttributedString(string: "A test string")
        let expectation = self.expectation(description: "Handler called")
        
        label.startTypewritingAnimation {
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func test_start_completionAllCharactersVisible() {
        label.attributedText = NSAttributedString(string: "A test string")
        let expectation = self.expectation(description: "Handler called")
        
        label.startTypewritingAnimation {
            self.label.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, self.label.attributedText!.length), options: []) { (value, range, stop) -> Void in
                let expectedRange = NSRange(location: 0, length: self.label.attributedText!.length)
                
                XCTAssertEqual(value as! UIColor, UIColor.black)
                XCTAssertEqual(range.location, expectedRange.location)
                XCTAssertEqual(range.length, expectedRange.length)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    // MARK: Cancel
    
    func test_cancel_clearText() {
        label.attributedText = NSAttributedString(string: "A significantly large test string")
        label.startTypewritingAnimation()
        
        let expectation = self.expectation(description: "Handler called")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.label.cancelTypewritingAnimation(clearText: true)
            
            self.label.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, self.label.attributedText!.length), options: []) { (value, range, stop) -> Void in
                XCTAssertEqual(value as! UIColor, UIColor.clear)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func test_cancel_doNotClearText() {
        label.attributedText = NSAttributedString(string: "A significantly large test string")
        label.startTypewritingAnimation()
        
        let expectation = self.expectation(description: "Handler called")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.label.cancelTypewritingAnimation(clearText: false)
            
            var foregroundColorApplied = 0
            self.label.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, self.label.attributedText!.length), options: []) { (value, range, stop) -> Void in
                foregroundColorApplied += 1
            }
            XCTAssertEqual(foregroundColorApplied, 2)
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    // MARK: Stop
    
    func test_stop_leavesLabelAsIs() {
        label.attributedText = NSAttributedString(string: "A significantly large test string")
        label.startTypewritingAnimation()
        
        let expectation = self.expectation(description: "Handler called")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.label.stopTypewritingAnimation()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            var foregroundColorApplied = 0
            self.label.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, self.label.attributedText!.length), options: []) { (value, range, stop) -> Void in
                foregroundColorApplied += 1
            }
            XCTAssertEqual(foregroundColorApplied, 2)
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    // MARK: HideTextBeforeTypewritingAnimation
    
    func test_hideTextBeforeTypewritingAnimation_false() {
        label.attributedText = NSAttributedString(string: "A significantly large test string")
        label.hideTextBeforeTypewritingAnimation = false
        
        self.label.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, self.label.attributedText!.length), options: []) { (value, range, stop) -> Void in
            XCTAssertEqual(value as! UIColor, UIColor.black)
        }
    }
    
    func test_hideTextBeforeTypewritingAnimation_true() {
        label.attributedText = NSAttributedString(string: "A significantly large test string")
        label.hideTextBeforeTypewritingAnimation = true
        
        self.label.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, self.label.attributedText!.length), options: []) { (value, range, stop) -> Void in
            XCTAssertEqual(value as! UIColor, UIColor.clear)
        }
    }
    
    func test_hideTextBeforeTypewritingAnimation_switching() {
        label.attributedText = NSAttributedString(string: "A significantly large test string")
        label.hideTextBeforeTypewritingAnimation = false
        label.hideTextBeforeTypewritingAnimation = true
        
        self.label.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, self.label.attributedText!.length), options: []) { (value, range, stop) -> Void in
            XCTAssertEqual(value as! UIColor, UIColor.clear)
        }
    }
    
    // MARK: Subview
    
    func test_subview_appliesTrueTransparentOptionWhenAddedAsSubview() {
        let subviewLabel = TypewriterLabel()
        subviewLabel.attributedText = NSAttributedString(string: "A significantly large test string")
        
        let superView = UIView()
        superView.addSubview(subviewLabel)
        
        subviewLabel.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, subviewLabel.attributedText!.length), options: []) { (value, range, stop) -> Void in
            XCTAssertEqual(value as! UIColor, UIColor.clear)
        }
    }
    
    func test_subview_appliesFalseTransparentOptionWhenAddedAsSubview() {
        let subviewLabel = TypewriterLabel()
        subviewLabel.attributedText = NSAttributedString(string: "A significantly large test string")
        subviewLabel.hideTextBeforeTypewritingAnimation = false
        
        let superView = UIView()
        superView.addSubview(subviewLabel)
        
        subviewLabel.attributedText!.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, subviewLabel.attributedText!.length), options: []) { (value, range, stop) -> Void in
            XCTAssertEqual(value as! UIColor, UIColor.black)
        }
    }
}
