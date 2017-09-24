import UIKit
import XCTest
@testable
import HarmonyKit

final class HarmonyKitTests: XCTestCase {
    lazy var expectedHarmonies: [Harmony] = {
        return [
            Harmony(tone: .C, octave: 1, frequency: 32.8518),
            Harmony(tone: .Db, octave: 1, frequency: 34.8053),
            Harmony(tone: .D, octave: 1, frequency: 36.875),
            Harmony(tone: .Eb, octave: 1, frequency: 39.0676),
            Harmony(tone: .E, octave: 1, frequency: 41.3907),
            Harmony(tone: .F, octave: 1, frequency: 43.852),
            Harmony(tone: .Gb, octave: 1, frequency: 46.4595),
            Harmony(tone: .G, octave: 1, frequency: 49.2222),
            Harmony(tone: .Ab, octave: 1, frequency: 52.1491),
            Harmony(tone: .A, octave: 1, frequency: 55.25),
            Harmony(tone: .Bb, octave: 1, frequency: 58.5353),
            Harmony(tone: .B, octave: 1, frequency: 62.016)
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
