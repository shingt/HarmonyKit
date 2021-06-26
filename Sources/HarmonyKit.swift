import Foundation

public struct HarmonyKit {
    public typealias OctaveRange = Range<Int>

    /// Generate frequencies for each tones.
    public static func tune(configuration: Configuration) -> [Note] {
        switch configuration.temperament {
        case .equal:
            return tuneEqual(
                pitch: configuration.pitch,
                transpositionTone: configuration.transpositionTone,
                octaveRange: configuration.octaveRange
            )
        case .pure(let pureType, let rootTone):
            return tunePure(
                pitch: configuration.pitch,
                transpositionTone: configuration.transpositionTone,
                octaveRange: configuration.octaveRange,
                pureType: pureType,
                rootTone: rootTone
            )
        }
    }

    private static let tones: [Tone] = [
        .C, .Db, .D, .Eb, .E, .F, .Gb, .G, .Ab, .A, .Bb, .B
    ]

    // https://en.wikipedia.org/wiki/Cent_(music)
    private static let octaveCents: Float = 1200.0

    private static let centOffsetsPureMajor: [Float] = [
        0.0, -29.3, 3.9, 15.6, -13.7, -2.0,
        -31.3, 2.0, -27.4, -15.6, 17.6, -11.7
    ].map { $0 / octaveCents }

    private static let centOffsetsPureMinor: [Float] = [
        0.0, 33.2, 3.9, 15.6, -13.7, -2.0,
        31.3, 2.0, 13.7, -15.6, 17.6, -11.7
    ].map { $0 / octaveCents }
}

// Equal
private extension HarmonyKit {
    static func tuneEqual(
        pitch: Float,
        transpositionTone: Tone,
        octaveRange: OctaveRange
    ) -> [Note] {
        let tuningBase = equalBase(pitch: pitch, transpositionTone: transpositionTone)
        var notes = [Note]()
        octaveRange.forEach { octave in
            let harmoniesInThisOctave = tune(octave: octave, tuningBase: tuningBase)
            notes.append(contentsOf: harmoniesInThisOctave)
        }
        return notes
    }

    // "Base" means C1, D1, ... in:
    // => http://ja.wikipedia.org/wiki/%E9%9F%B3%E5%90%8D%E3%83%BB%E9%9A%8E%E5%90%8D%E8%A1%A8%E8%A8%98
    static func equalBase(pitch: Float, transpositionTone: Tone) -> [Tone: Float] {
        // Frequencies when transpositionTone == C
        var baseFrequencies: [Float] = [
            frequency(pitch: pitch, order: 3.0)  / 16.0,  // C
            frequency(pitch: pitch, order: 4.0)  / 16.0,  // Db
            frequency(pitch: pitch, order: 5.0)  / 16.0,  // D
            frequency(pitch: pitch, order: 6.0)  / 16.0,  // Eb
            frequency(pitch: pitch, order: 7.0)  / 16.0,  // E
            frequency(pitch: pitch, order: 8.0)  / 16.0,  // F
            frequency(pitch: pitch, order: 9.0)  / 16.0,  // Gb
            frequency(pitch: pitch, order: 10.0) / 16.0,  // G
            frequency(pitch: pitch, order: 11.0) / 16.0,  // Ab
            frequency(pitch: pitch, order: 0.0)  / 8.0,   // A
            frequency(pitch: pitch, order: 1.0)  / 8.0,   // Bb
            frequency(pitch: pitch, order: 2.0)  / 8.0,   // B
        ]

        var transposedFrequencies: [Float] = []
        for (i, tone) in tones.enumerated() {
            if transpositionTone == tone {
                for j in baseFrequencies[i..<baseFrequencies.count] {
                    transposedFrequencies.append(j)
                }
                for j in baseFrequencies[0..<i] {
                    transposedFrequencies.append(j)
                }
                break
            }
            baseFrequencies[i] *= 2.0
        }

        // Go up till Gb and go down after G
        let GbIndex = 6
        guard let transpositionToneIndex = tones.firstIndex(of: transpositionTone) else {
            return [:]
        }
        if GbIndex < transpositionToneIndex {
            transposedFrequencies = transposedFrequencies.map { $0 / 2.0 }
        }

        var tuning = [Tone: Float]()
        for (i, tone) in tones.enumerated() {
            tuning[tone] = transposedFrequencies[i]
        }
        return tuning
    }

    static func frequency(pitch: Float, order: Float) -> Float {
        return pitch * pow(2.0, order / 12.0)
    }

    // Generate 12 frequencies for spacified octave by integral multiplication
    static func tune(octave: Int, tuningBase: [Tone: Float]) -> [Note] {
        var notes = [Note]()
        for key in tuningBase.keys {
            guard let baseFrequency = tuningBase[key] else { continue }
            let frequency = Float(pow(2.0, Float(octave - 1))) * baseFrequency
            let note = Note(tone: key, octave: octave, frequency: frequency)
            notes.append(note)
        }
        return notes
    }
}

// Pure
private extension HarmonyKit {
    static func tunePure(
        pitch: Float,
        transpositionTone: Tone,
        octaveRange: OctaveRange,
        pureType: Temperament.Pure,
        rootTone: Tone
    ) -> [Note] {
        let centOffets: [Float]
        switch pureType {
        case .major: centOffets = centOffsetsPureMajor
        case .minor: centOffets = centOffsetsPureMinor
        }

        let tuningBase = pureBase(
            pitch: pitch,
            transpositionTone: transpositionTone,
            rootTone: rootTone,
            centOffsets: centOffets
        )
        return tunePure(octaveRange: octaveRange, tuningBase: tuningBase)
    }

    static func pureBase(
        pitch: Float,
        transpositionTone: Tone,
        rootTone: Tone,
        centOffsets: [Float]
    ) -> [Tone: Float] {
        let tones = arrangeTones(rootTone: rootTone)
        let tuningBase = equalBase(pitch: pitch, transpositionTone: transpositionTone)

        var tuning = [Tone: Float]()
        for (i, tone) in tones.enumerated() {
            guard let baseFrequency = tuningBase[tone] else { continue }
            let frequency = baseFrequency * pow(2.0, centOffsets[i])
            tuning[tone] = frequency
        }
        return tuning
    }

    // Generate one-octave tones based on specified root tone
    static func arrangeTones(rootTone: Tone) -> [Tone] {
        guard var rootIndex = tones.firstIndex(of: rootTone) else { return [] }

        var arrangedTones = [Tone]()
        tones.forEach { _ in
            rootIndex = rootIndex == tones.count ? 0 : rootIndex
            arrangedTones.append(tones[rootIndex])
            rootIndex += 1
        }
        return arrangedTones
    }

    static func tunePure(octaveRange: OctaveRange, tuningBase: [Tone: Float]) -> [Note] {
        var notes = [Note]()
        octaveRange.forEach { octave in
            let notesInOctave = tune(octave: octave, tuningBase: tuningBase)
            notes.append(contentsOf: notesInOctave)
        }
        return notes
    }
}
