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
   
    var expectedTunings = [String: Float]()
    
    override func setUp() {
        super.setUp()
        
        self.expectedTunings = [
            "C1": 32.8518,
            "D♭1": 34.8053,
            "D1": 36.875,
            "E♭1": 39.0676,
            "E1": 41.3907,
            "F1": 43.852,
            "G♭1": 46.4595,
            "G1": 49.2222,
            "A♭1": 52.1491,
            "A1": 55.25,
            "B♭1": 58.5353,
            "B1": 62.016,
        ]
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testOneOctave() {
        let info = TuningInfo(
            pitch:             442,
            tuningType:        TuningType.Equal,
            rootSound:         SoundBaseC,
            transpositionNote: SoundBaseC,
            octaveRange:       OctaveRange(start:1, end: 1)
        )
        let tunings = Tuning.generateByInfo(info)
        XCTAssertEqual(tunings.count, 12, "num of sounds in 1 octave should be 12.")
        
        let testSounds: [String] = [
            "C1", "D♭1", "D1", "E♭1", "E1", "F1",
            "G♭1", "G1", "A♭1", "A1", "B♭1", "B1"
        ]
        for sound: String in testSounds {
            let expectedTuning: Float = self.expectedTunings[sound]!
            XCTAssertEqualWithAccuracy(tunings[sound]!, expectedTuning, 0.0001, "\(sound) should have correct frequency.")
        }
    }
}
