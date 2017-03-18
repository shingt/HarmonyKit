import UIKit
import XCTest
import AudioTuning

final class AudioTuningTests: XCTestCase {
    lazy var expectedHarmonies: [Tuning.Harmony] = {
        return [
            Tuning.Harmony(tone: .C,  octave: 1, frequency: 32.8518),
            Tuning.Harmony(tone: .Db, octave: 1, frequency: 34.8053),
            Tuning.Harmony(tone: .D,  octave: 1, frequency: 36.875),
            Tuning.Harmony(tone: .Eb, octave: 1, frequency: 39.0676),
            Tuning.Harmony(tone: .E,  octave: 1, frequency: 41.3907),
            Tuning.Harmony(tone: .F,  octave: 1, frequency: 43.852),
            Tuning.Harmony(tone: .Gb, octave: 1, frequency: 46.4595),
            Tuning.Harmony(tone: .G,  octave: 1, frequency: 49.2222),
            Tuning.Harmony(tone: .Ab, octave: 1, frequency: 52.1491),
            Tuning.Harmony(tone: .A,  octave: 1, frequency: 55.25),
            Tuning.Harmony(tone: .Bb, octave: 1, frequency: 58.5353),
            Tuning.Harmony(tone: .B,  octave: 1, frequency: 62.016)
        ]
    }()
    
    override func setUp() {
        super.setUp()
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
        let harmonies = Tuning.tune(setting: setting)
        XCTAssertEqual(harmonies.count, 12, "num of sounds in 1 octave should be 12.")
     
        harmonies.forEach { harmony in
            guard expectedHarmonies.contains(harmony) else {
                XCTFail("Expected harmony could not be found: \(harmony)."); return
            }
        }
    }
}
