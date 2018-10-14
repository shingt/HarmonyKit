import Foundation

public enum ScaleType {
    case equal
    case pureMajor
    case pureMinor
    // case pythagorean
    // case userDefined
}

public struct HarmonyKit {
    /// - `let pitch: Base pitch.`
    /// - `let scaleType: Scale type for harmony.`
    /// - `let rootTone: Root tone.`
    /// - `let transpositionTone: Transposition tone.`
    /// - `let octaveRange: Octave range indicated by integer.`
    public struct Setting {
        public var pitch: Float
        public var scaleType: ScaleType
        public var rootTone: Tone
        public var transpositionTone: Tone
        public var octaveRange: CountableRange<Int>
    }

    /// Generate frequencies for each tones.
    /// - `let setting: Harmonies information is generated based on this setting.`
    public static func tune(setting: Setting) -> [Harmony] {
        switch setting.scaleType {
        case .equal:
            return tuneEqual(setting: setting)
        case .pureMajor:
            return tunePureMajor(setting: setting)
        case .pureMinor:
            return tunePureMinor(setting: setting)
        }
    }

    private static let tones: [Tone] = [
        .C, .Db, .D, .Eb, .E, .F, .Gb, .G, .Ab, .A, .Bb, .B
    ]

    // Offsets for Pure-Major scale.
    // Frequency ratio for standard pitch: r = 2^(n/12 + m/1200)
    // n: Interval difference (1 for semitone)
    // m: Difference from equal temperament (in cent)
    private static let centOffsetsForPureMajor: [Float] = {
        let offset1: Float =   0.0 / 1200.0
        let offset2: Float = -29.3 / 1200.0
        let offset3: Float =   3.9 / 1200.0
        let offset4: Float =  15.6 / 1200.0
        let offset5: Float = -13.7 / 1200.0
        let offset6: Float =  -2.0 / 1200.0
        let offset7: Float = -31.3 / 1200.0
        let offset8: Float =   2.0 / 1200.0
        let offset9: Float = -27.4 / 1200.0
        let offset10: Float = -15.6 / 1200.0
        let offset11: Float =  17.6 / 1200.0
        let offset12: Float = -11.7 / 1200.0
        return [
            offset1, offset2, offset3, offset4, offset5, offset6,
            offset7, offset8, offset9, offset10, offset11, offset12
        ]
    }()

    // Offsets for Pure-Minor scale
    // Frequency ratio for standard pitch: r = 2^(n/12 + m/1200)
    private static let centOffsetsForPureMinor: [Float] = {
        let offset1: Float =   0.0 / 1200.0
        let offset2: Float =  33.2 / 1200.0
        let offset3: Float =   3.9 / 1200.0
        let offset4: Float =  15.6 / 1200.0
        let offset5: Float = -13.7 / 1200.0
        let offset6: Float =  -2.0 / 1200.0
        let offset7: Float =  31.3 / 1200.0
        let offset8: Float =   2.0 / 1200.0
        let offset9: Float =  13.7 / 1200.0
        let offset10: Float = -15.6 / 1200.0
        let offset11: Float =  17.6 / 1200.0
        let offset12: Float = -11.7 / 1200.0
        return [
            offset1, offset2, offset3, offset4, offset5, offset6,
            offset7, offset8, offset9, offset10, offset11, offset12
        ]
    }()
}

extension HarmonyKit.Setting: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "pitch: \(pitch), scaleType: \(scaleType), rootSound: \(rootTone.rawValue), transpositionTone: \(transpositionTone)"
    }
}

extension HarmonyKit {
    static func tuneEqual(setting: Setting) -> [Harmony] {
        let tuningBase = equalBase(pitch: setting.pitch, transpositionTone: setting.transpositionTone)

        var harmonies = [Harmony]()
        setting.octaveRange.forEach { octave in
            let harmoniesInThisOctave = calculateTuning(octave: octave, tuningBase: tuningBase)
            harmonies.append(contentsOf: harmoniesInThisOctave)
        }
        return harmonies
    }

    static func tunePureMajor(setting: Setting) -> [Harmony] {
        let tuningPureMajorBase = pureBase(setting: setting, centOffsets: centOffsetsForPureMajor)
        return tuneWholePure(setting: setting, tuningPureBase: tuningPureMajorBase)
    }

    static func tunePureMinor(setting: Setting) -> [Harmony] {
        let tuningPureMinorBase = pureBase(setting: setting, centOffsets: centOffsetsForPureMinor)
        return tuneWholePure(setting: setting, tuningPureBase: tuningPureMinorBase)
    }

    static func tuneWholePure(setting: Setting, tuningPureBase: [Tone: Float]) -> [Harmony] {
        var harmonies = [Harmony]()
        setting.octaveRange.forEach { octave in
            let harmoniesInOctave = calculateTuning(octave: octave, tuningBase: tuningPureBase)
            harmonies.append(contentsOf: harmoniesInOctave)
        }
        return harmonies
    }

    // "Base" means C1, D1, ... in:
    // => http://ja.wikipedia.org/wiki/%E9%9F%B3%E5%90%8D%E3%83%BB%E9%9A%8E%E5%90%8D%E8%A1%A8%E8%A8%98
    static func equalBase(pitch: Float, transpositionTone: Tone) -> [Tone: Float] {

        // Frequencies when transpositionTone = C
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
        guard let indexOfTranspositionTone = tones.index(of: transpositionTone) else { return [:] }
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

    // Generate one-octave tones based on specified root tone
    static func arrangeTones(rootTone: Tone) -> [Tone] {
        guard var rootIndex = tones.index(of: rootTone) else { return [] }

        var arrangedTones = [Tone]()
        tones.forEach { _ in
            rootIndex = rootIndex == tones.count ? 0 : rootIndex
            arrangedTones.append(tones[rootIndex])
            rootIndex += 1
        }
        return arrangedTones
    }

    static func pureBase(setting: Setting, centOffsets: [Float]) -> [Tone: Float] {
        let tones = arrangeTones(rootTone: setting.rootTone)
        let tuningEqualBase = equalBase(pitch: setting.pitch, transpositionTone: setting.transpositionTone)

        var tuning = [Tone: Float]()
        for (i, tone) in tones.enumerated() {
            guard let frequencyForEqual = tuningEqualBase[tone] else { continue }
            let frequency = frequencyForEqual * pow(2.0, centOffsets[i])
            tuning[tone] = frequency
        }
        return tuning
    }
}
