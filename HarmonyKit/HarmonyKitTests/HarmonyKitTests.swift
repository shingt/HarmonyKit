import UIKit
import XCTest
import HarmonyKit

final class HarmonyKitTests: XCTestCase {
    lazy var expectedHarmonies: [HarmonyKit.Harmony] = {
        return [
            HarmonyKit.Harmony(tone: .C,  octave: 1, frequency: 32.8518),
            HarmonyKit.Harmony(tone: .Db, octave: 1, frequency: 34.8053),
            HarmonyKit.Harmony(tone: .D,  octave: 1, frequency: 36.875),
            HarmonyKit.Harmony(tone: .Eb, octave: 1, frequency: 39.0676),
            HarmonyKit.Harmony(tone: .E,  octave: 1, frequency: 41.3907),
            HarmonyKit.Harmony(tone: .F,  octave: 1, frequency: 43.852),
            HarmonyKit.Harmony(tone: .Gb, octave: 1, frequency: 46.4595),
            HarmonyKit.Harmony(tone: .G,  octave: 1, frequency: 49.2222),
            HarmonyKit.Harmony(tone: .Ab, octave: 1, frequency: 52.1491),
            HarmonyKit.Harmony(tone: .A,  octave: 1, frequency: 55.25),
            HarmonyKit.Harmony(tone: .Bb, octave: 1, frequency: 58.5353),
            HarmonyKit.Harmony(tone: .B,  octave: 1, frequency: 62.016)
        ]
    }()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOneOctave() {
        let setting = HarmonyKit.Setting(
            pitch: 442,
            scaleType: .equal,
            rootTone: .C,
            transpositionTone: .C,
            octaveRange: 1..<2
        )
        let harmonies = HarmonyKit.tune(setting: setting)
        let sortedHarmonies = harmonies.sorted()
        sortedHarmonies.forEach { print($0) }
        
        XCTAssertEqual(harmonies.count, 12, "num of sounds in 1 octave should be 12.")
     
        harmonies.forEach { harmony in
            guard expectedHarmonies.contains(harmony) else {
                XCTFail("Expected harmony could not be found: \(harmony)."); return
            }
        }
    }
}
