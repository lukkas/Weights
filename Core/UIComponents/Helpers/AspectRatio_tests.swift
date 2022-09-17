//
//  AspectRatio_tests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 17/09/2022.
//

@testable import Core
import XCTest

class AspectRatioTests: XCTestCase {
    func testHeight_whenInitilizedWithInts() {
        // given
        let ratio = AspectRatio(width: 1920, height: 1080)
        
        // when
        let height = ratio.height(forWidth: 16)
        
        // then
        XCTAssertEqual(height, 9)
    }
    
    func testWidth_whenInitilizedWithFloats() {
        // given
        let ratio = AspectRatio(width: 16 as CGFloat, height: 9)
        
        // when
        let width = ratio.width(forHeight: 1080)
        
        // then
        XCTAssertEqual(width, 1920)
    }
    
    func testHeight_whenInitWithSize() {
        // given
        let ratio = AspectRatio(size: CGSize(width: 1920, height: 1080))
        
        // when
        let height = ratio.height(forWidth: 16)
        
        // then
        XCTAssertEqual(height, 9)
    }
    
    func testSize_whenInitWithSize() {
        // given
        let ratio = AspectRatio(size: CGSize(width: 9, height: 16))
        
        // when
        let size = ratio.size(forWidth: 1080)
        
        // then
        XCTAssertEqual(size, CGSize(width: 1080, height: 1920))
    }
}
