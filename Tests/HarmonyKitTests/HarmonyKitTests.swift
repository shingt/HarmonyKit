import UIKit
import XCTest
@testable
import HarmonyKit

final class HarmonyKitTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    private let expectedHarmonies: [Harmony] = [
        .init(tone: .C, octave: 1, frequency: 32.851845),
        .init(tone: .Db, octave: 1, frequency: 34.80532),
        .init(tone: .D, octave: 1, frequency: 36.87495),
        .init(tone: .Eb, octave: 1, frequency: 39.06765),
        .init(tone: .E, octave: 1, frequency: 41.390736),
        .init(tone: .F, octave: 1, frequency: 43.851955),
        .init(tone: .Gb, octave: 1, frequency: 46.459526),
        .init(tone: .G, octave: 1, frequency: 49.222153),
        .init(tone: .Ab, octave: 1, frequency: 52.149055),
        .init(tone: .A, octave: 1, frequency: 55.25),
        .init(tone: .Bb, octave: 1, frequency: 58.53534),
        .init(tone: .B, octave: 1, frequency: 62.016026)
    ]

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
