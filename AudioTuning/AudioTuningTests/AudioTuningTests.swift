//
//  AudioTuningTests.swift
//  AudioTuningTests
//
//  Created by Shinichi Goto on 5/28/15.
//  Copyright (c) 2015 Shinichi Goto. All rights reserved.
//

import XCTest

import AudioTuning

class AudioTuningTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
        let info = TuningInfo(
            pitch:             442,
            tuningType:        TuningType.Equal,
            rootSound:         SoundBaseC,
            transpositionNote: SoundBaseC,
            octaveRange:       OctaveRange(start:1, end: 2)
        )
        let tuning: [SoundName:Float] = Tuning.generateByInfo(info)
        for sound in tuning.keys {
            let freq = tuning[sound]!
            println("Sound: \(sound) => Freq: \(freq)")
        }

        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        self.measureBlock() {
        }
    }
}
