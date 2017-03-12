import UIKit
import XCTest
import AudioTuning

class AudioTuningTests: XCTestCase {
    var expectedTunings = [String: Float]()
    override func setUp() {
        super.setUp()
        
        self.expectedTunings = [
            "C1": 32.8518,
            "Db1": 34.8053,
            "D1": 36.875,
            "Eb1": 39.0676,
            "E1": 41.3907,
            "F1": 43.852,
            "Gb1": 46.4595,
            "G1": 49.2222,
            "Ab1": 52.1491,
            "A1": 55.25,
            "Bb1": 58.5353,
            "B1": 62.016,
        ]
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOneOctave() {
        let setting = Tuning.Setting(
            pitch: 442,
            scaleType: .equal,
            rootTone: .C,
            transpositionTone: .C,
            octaveRange: 1..<2
        )
        let tunings = Tuning.tune(setting: setting)
        XCTAssertEqual(tunings.count, 12, "num of sounds in 1 octave should be 12.")
        
        let sounds: [String] = [
            "C1", "Db1", "D1", "Eb1", "E1", "F1",
            "Gb1", "G1", "Ab1", "A1", "Bb1", "B1"
        ]
        sounds.forEach { sound in
            guard let expectedTuning = expectedTunings[sound] else {
                XCTFail("Expected tuning nod found for sound: \(sound)."); return
            }
            guard let tuning = tunings[sound] else {
                XCTFail("Tuning nod found for sound: \(sound)."); return
            }
            XCTAssertEqualWithAccuracy(tuning, expectedTuning, accuracy: 0.0001, "\(sound) should have correct frequency.")
        }
    }
}
