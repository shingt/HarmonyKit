//
//  AudioTuningTests.swift
//  AudioTuningTests
//
//  Created by Shinichi Goto on 5/31/15.
//  Copyright (c) 2015 Shinichi Goto. All rights reserved.
//

import UIKit
import XCTest

import AudioTuning

class AudioTuningTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let info = TuningInfo(
            pitch:             442,
            tuningType:        TuningType.Equal,
            rootSound:         "C",
            transpositionNote: "C",
            octaveRange:       OctaveRange(start:1, end: 2)
        )
        let tuning = Tuning.generateByInfo(info)
        for sound in tuning.keys {
            let freq = tuning[sound]!
            println("Sound: \(sound) => Freq: \(freq)")
        }
        
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
