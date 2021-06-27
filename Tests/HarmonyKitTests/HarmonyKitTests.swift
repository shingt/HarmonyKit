import XCTest
import HarmonyKit

final class HarmonyKitTests: XCTestCase {
    func testTune_Equal() {
        let configuration = HarmonyKit.Configuration(
            temperament: .equal,
            pitch: 442,
            transpositionTone: .C,
            octaveRange: 1..<2
        )
        let notes = HarmonyKit.tune(configuration: configuration)
        XCTAssertEqual(notes.count, 12)

        let expectedNotes: [HarmonyKit.Note] = [
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
        XCTAssertEqual(Set(notes), Set(expectedNotes))
    }

    func testTune_Equal_MultipleOctaves() {
        let configuration = HarmonyKit.Configuration(
            temperament: .equal,
            pitch: 442,
            transpositionTone: .C,
            octaveRange: 1..<3  // 2 octaves == 24 notes
        )
        let notes = HarmonyKit.tune(configuration: configuration)
        XCTAssertEqual(notes.count, 24)
    }

    func testTune_Equal_TranspositionBoundary() {
        let configuration = HarmonyKit.Configuration(
            temperament: .equal,
            pitch: 442,
            // Gb/G is boundary of transpostion.
            transpositionTone: .G,
            octaveRange: 1..<2
        )
        let notes = HarmonyKit.tune(configuration: configuration)

        let expectedNotes: [HarmonyKit.Note] = [
            .init(tone: .C, octave: 1, frequency: 24.611076),
            .init(tone: .Db, octave: 1, frequency: 26.074528),
            .init(tone: .D, octave: 1, frequency: 27.625),
            .init(tone: .Eb, octave: 1, frequency: 29.26767),
            .init(tone: .E, octave: 1, frequency: 31.008013),
            .init(tone: .F, octave: 1, frequency: 32.851845),
            .init(tone: .Gb, octave: 1, frequency: 34.80532),
            .init(tone: .G, octave: 1, frequency: 36.87495),
            .init(tone: .Ab, octave: 1, frequency: 39.06765),
            .init(tone: .A, octave: 1, frequency: 41.390736),
            .init(tone: .Bb, octave: 1, frequency: 43.851955),
            .init(tone: .B, octave: 1, frequency: 46.459526),
        ]
        XCTAssertEqual(Set(notes), Set(expectedNotes))
    }

    func testTune_Pure_Major() {
        let configuration = HarmonyKit.Configuration(
            temperament: .pure(.major, rootTone: .C),
            pitch: 442,
            transpositionTone: .C,
            octaveRange: 1..<2
        )
        let notes = HarmonyKit.tune(configuration: configuration)
        XCTAssertEqual(notes.count, 12)

        let expectedNotes: [HarmonyKit.Note] = [
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
        XCTAssertEqual(Set(notes), Set(expectedNotes))
    }

    func testTune_Pure_Minor() {
        let configuration = HarmonyKit.Configuration(
            temperament: .pure(.minor, rootTone: .C),
            pitch: 442,
            transpositionTone: .C,
            octaveRange: 1..<2
        )
        let notes = HarmonyKit.tune(configuration: configuration)
        XCTAssertEqual(notes.count, 12)

        let expectedNotes: [HarmonyKit.Note] = [
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
        XCTAssertEqual(Set(notes), Set(expectedNotes))
    }

    func testTune_Pure_DifferentRoot() {
        let configuration = HarmonyKit.Configuration(
            temperament: .pure(.major, rootTone: .A),
            pitch: 442,
            transpositionTone: .C,
            octaveRange: 1..<2
        )
        let notes = HarmonyKit.tune(configuration: configuration)

        let expectedNotes: [HarmonyKit.Note] = [
            .init(tone: .C, octave: 1, frequency: 33.149208),
            .init(tone: .Db, octave: 1, frequency: 34.53098),
            .init(tone: .D, octave: 1, frequency: 36.832375),
            .init(tone: .Eb, octave: 1, frequency: 38.36767),
            .init(tone: .E, octave: 1, frequency: 41.438583),
            .init(tone: .F, octave: 1, frequency: 43.16338),
            .init(tone: .Gb, octave: 1, frequency: 46.042763),
            .init(tone: .G, octave: 1, frequency: 49.725105),
            .init(tone: .Ab, octave: 1, frequency: 51.797813),
            .init(tone: .A, octave: 1, frequency: 55.25),
            .init(tone: .Bb, octave: 1, frequency: 57.553005),
            .init(tone: .B, octave: 1, frequency: 62.15589),
        ]
        XCTAssertEqual(Set(notes), Set(expectedNotes))
    }
}
