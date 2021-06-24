import UIKit
import XCTest
@testable
import HarmonyKit

final class HarmonyKitTests: XCTestCase {
    func testHarmonies_equalOneOctave() {
        let setting = HarmonyKit.Setting(
            scaleType: .equal,
            pitch: 442,
            transpositionTone: .C,
            octaveRange: 1..<2
        )
        let harmonies = HarmonyKit.tune(setting: setting)

        XCTAssertEqual(harmonies.count, 12, "num of sounds in 1 octave should be 12.")

        let expectedHarmonies: [Harmony] = [
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
        harmonies.forEach { harmony in
            guard expectedHarmonies.contains(harmony) else {
                XCTFail("Expected harmony could not be found: \(harmony)."); return
            }
        }
    }

    func testPure_oneOctave() {
        XCTContext.runActivity(named: "major") { _ in
            let setting = HarmonyKit.Setting(
                scaleType: .pure(.major, rootTone: .C),
                pitch: 442,
                transpositionTone: .C,
                octaveRange: 1..<2
            )
            let harmonies = HarmonyKit.tune(setting: setting)

            XCTAssertEqual(harmonies.count, 12, "num of sounds in 1 octave should be 12.")

            let expectedHarmonies: [Harmony] = [
                .init(tone: .C, octave: 1, frequency: 32.851845),
                .init(tone: .Db, octave: 1, frequency: 34.221222),
                .init(tone: .D, octave: 1, frequency: 36.958115),
                .init(tone: .Eb, octave: 1, frequency: 39.421276),
                .init(tone: .E, octave: 1, frequency: 41.064487),
                .init(tone: .F, octave: 1, frequency: 43.801323),
                .init(tone: .Gb, octave: 1, frequency: 45.6271),
                .init(tone: .G, octave: 1, frequency: 49.279053),
                .init(tone: .Ab, octave: 1, frequency: 51.330196),
                .init(tone: .A, octave: 1, frequency: 54.754383),
                .init(tone: .Bb, octave: 1, frequency: 59.133453),
                .init(tone: .B, octave: 1, frequency: 61.598324)
            ]
            harmonies.forEach { harmony in
                guard expectedHarmonies.contains(harmony) else {
                    XCTFail("Expected harmony could not be found: \(harmony)."); return
                }
            }
        }

        XCTContext.runActivity(named: "minor") { _ in
            let setting = HarmonyKit.Setting(
                scaleType: .pure(.minor, rootTone: .C),
                pitch: 442,
                transpositionTone: .C,
                octaveRange: 1..<2
            )
            let harmonies = HarmonyKit.tune(setting: setting)

            XCTAssertEqual(harmonies.count, 12, "num of sounds in 1 octave should be 12.")

            let expectedHarmonies: [Harmony] = [
                .init(tone: .C, octave: 1, frequency: 32.851845),
                .init(tone: .Db, octave: 1, frequency: 35.479225),
                .init(tone: .D, octave: 1, frequency: 36.958115),
                .init(tone: .Eb, octave: 1, frequency: 39.421276),
                .init(tone: .E, octave: 1, frequency: 41.064487),
                .init(tone: .F, octave: 1, frequency: 43.801323),
                .init(tone: .Gb, octave: 1, frequency: 47.307137),
                .init(tone: .G, octave: 1, frequency: 49.279053),
                .init(tone: .Ab, octave: 1, frequency: 52.56337),
                .init(tone: .A, octave: 1, frequency: 54.754383),
                .init(tone: .Bb, octave: 1, frequency: 59.133453),
                .init(tone: .B, octave: 1, frequency: 61.598324),
            ]
            harmonies.forEach { harmony in
                guard expectedHarmonies.contains(harmony) else {
                    XCTFail("Expected harmony could not be found: \(harmony)."); return
                }
            }
        }
    }
}
