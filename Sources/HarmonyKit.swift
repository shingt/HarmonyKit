import Foundation

public struct HarmonyKit {
    /// - `let scaleType: Scale type for harmony.`
    /// - `let pitch: Base pitch.`
    /// - `let transpositionTone: Transposition tone.`
    /// - `let octaveRange: Octave range indicated by integer.`
    public struct Setting {
        public var scaleType: ScaleType
        public var pitch: Float
        public var transpositionTone: Tone
        public var octaveRange: CountableRange<Int>
    }

    /// Generate frequencies for each tones.
    public static func tune(setting: Setting) -> [Harmony] {
        switch setting.scaleType {
        case .equal:
            return tuneEqual(
                pitch: setting.pitch,
                transpositionTone: setting.transpositionTone,
                octaveRange: setting.octaveRange
            )
        case .pure(let pureType, let rootTone):
            return tunePure(
                pitch: setting.pitch,
                transpositionTone: setting.transpositionTone,
                octaveRange: setting.octaveRange,
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

    // Offsets for Pure-Major scale.
    // Frequency ratio for standard pitch: r = 2^(n/12 + m/1200)
    // n: Interval difference (1 for semitone)
    // m: Difference from equal temperament (in cent)
    private static let centOffsetsForPureMajor: [Float] = [
        0.0, -29.3, 3.9, 15.6, -13.7, -2.0,
        -31.3, 2.0, -27.4, -15.6, 17.6, -11.7
    ].map { $0 / octaveCents }

    // Offsets for Pure-Minor scale
    // Frequency ratio for standard pitch: r = 2^(n/12 + m/1200)
    private static let centOffsetsForPureMinor: [Float] = [
        0.0, 33.2, 3.9, 15.6, -13.7, -2.0,
        31.3, 2.0, 13.7, -15.6, 17.6, -11.7
    ].map { $0 / octaveCents }
}

// General and Equal
extension HarmonyKit {
    // Generate 12 frequencies for spacified octave by integral multiplication
    static func calculateTuning(octave: Int, tuningBase: [Tone: Float]) -> [Harmony] {
        var harmonies = [Harmony]()
        for key in tuningBase.keys {
            guard let baseFrequency = tuningBase[key] else { continue }
            let frequency = Float(pow(2.0, Float(octave - 1))) * baseFrequency
            let harmony = Harmony(tone: key, octave: octave, frequency: frequency)
            harmonies.append(harmony)
        }
        return harmonies
    }

    static func tuneEqual(
        pitch: Float,
        transpositionTone: Tone,
        octaveRange: CountableRange<Int>
    ) -> [Harmony] {
        let tuningBase = equalBase(pitch: pitch, transpositionTone: transpositionTone)
        var harmonies = [Harmony]()
        octaveRange.forEach { octave in
            let harmoniesInThisOctave = calculateTuning(octave: octave, tuningBase: tuningBase)
            harmonies.append(contentsOf: harmoniesInThisOctave)
        }
        return harmonies
    }

    // "Base" means C1, D1, ... in:
    // => http://ja.wikipedia.org/wiki/%E9%9F%B3%E5%90%8D%E3%83%BB%E9%9A%8E%E5%90%8D%E8%A1%A8%E8%A8%98
    static func equalBase(pitch: Float, transpositionTone: Tone) -> [Tone: Float] {

        // Frequencies when transpositionTone == C
        var baseTuning: [Float] = [
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

        var rearrangedBaseTuning: [Float] = []

        for (i, tone) in tones.enumerated() {
            if transpositionTone == tone {
                for j in baseTuning[i..<baseTuning.count] {
                    rearrangedBaseTuning.append(j)
                }
                for j in baseTuning[0..<i] {
                    rearrangedBaseTuning.append(j)
                }
                break
            }
            baseTuning[i] *= 2.0
        }

        // Go up till Gb and go down after G
        let indexOfBoundary = 6  //Gb
        guard let indexOfTranspositionTone = tones.firstIndex(of: transpositionTone) else { return [:] }
        if indexOfBoundary < indexOfTranspositionTone {
            rearrangedBaseTuning = rearrangedBaseTuning.map { $0 / 2.0 }
        }

        var tuning = [Tone: Float]()
        for (i, tone) in tones.enumerated() {
            tuning[tone] = rearrangedBaseTuning[i]
        }
        return tuning
    }

    static func frequency(pitch: Float, order: Float) -> Float {
        return pitch * pow(2.0, order / 12.0)
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
}

// Pure
extension HarmonyKit {
    static func tunePure(
        pitch: Float,
        transpositionTone: Tone,
        octaveRange: CountableRange<Int>,
        pureType: ScaleType.Pure,
        rootTone: Tone
    ) -> [Harmony] {
        let centOffets: [Float]
        switch pureType {
        case .major: centOffets = centOffsetsForPureMajor
        case .minor: centOffets = centOffsetsForPureMinor
        }

        let tuningPureBase = pureBase(
            pitch: pitch,
            transpositionTone: transpositionTone,
            rootTone: rootTone,
            centOffsets: centOffets
        )
        return tuneWholePure(octaveRange: octaveRange, tuningPureBase: tuningPureBase)
    }

    static func pureBase(
        pitch: Float,
        transpositionTone: Tone,
        rootTone: Tone,
        centOffsets: [Float]
    ) -> [Tone: Float] {
        let tones = arrangeTones(rootTone: rootTone)
        let tuningEqualBase = equalBase(pitch: pitch, transpositionTone: transpositionTone)

        var tuning = [Tone: Float]()
        for (i, tone) in tones.enumerated() {
            guard let frequencyForEqual = tuningEqualBase[tone] else { continue }
            let frequency = frequencyForEqual * pow(2.0, centOffsets[i])
            tuning[tone] = frequency
        }
        return tuning
    }

    static func tuneWholePure(
        octaveRange: CountableRange<Int>,
        tuningPureBase: [Tone: Float]
    ) -> [Harmony] {
        var harmonies = [Harmony]()
        octaveRange.forEach { octave in
            let harmoniesInOctave = calculateTuning(octave: octave, tuningBase: tuningPureBase)
            harmonies.append(contentsOf: harmoniesInOctave)
        }
        return harmonies
    }
}

// Debugging
extension HarmonyKit.Setting: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "type: \(scaleType), pitch: \(pitch), scaleType: \(scaleType), transpositionTone: \(transpositionTone)"
    }
}
