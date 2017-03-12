import Foundation

public class Tuning {
    public struct Setting {
        let pitch: Float
        let scaleType: ScaleType
        let rootTone: Tone
        let transpositionTone: Tone
        let octaveRange: CountableRange<Int>
    }
    
    public enum Tone: String {
        case A
        case Bb
        case B
        case C
        case Db
        case D
        case Eb
        case E
        case F
        case Gb
        case G
        case Ab
    }
    
    public enum ScaleType {
        case equal
        case pureMajor
        case pureMinor
        // case pythagorean
        // case userDefined
    }
    
    public static func tune(setting: Setting) -> [String: Float] {
        var tuning = [String: Float]()
        
        switch setting.scaleType {
        case .equal:
            tuning = tuneEqual(setting: setting)
        case .pureMajor:
            tuning = tunePureMajor(setting: setting)
        case .pureMinor:
            tuning = tunePureMinor(setting: setting)
        // case .pythagorean:
        // case .userDefined:
        }
        
        return tuning
    }
    
    private static func frequency(ofPitch pitch: Float, order: Float) -> Float {
        return pitch * pow(2.0,  order / 12.0)
    }
    
    // Base refers C1, D1, ... in:
    // => http://ja.wikipedia.org/wiki/%E9%9F%B3%E5%90%8D%E3%83%BB%E9%9A%8E%E5%90%8D%E8%A1%A8%E8%A8%98
    private static func equalBase(pitch: Float, transpositionTone: Tone) -> [Tone: Float] {
        
        // Frequencies when transpositionTone = C
        var baseTuning: [Float] = [
            frequency(ofPitch: pitch, order: 3.0)  / 16.0,  // C
            frequency(ofPitch: pitch, order: 4.0)  / 16.0,  // Db
            frequency(ofPitch: pitch, order: 5.0)  / 16.0,  // D
            frequency(ofPitch: pitch, order: 6.0)  / 16.0,  // Eb
            frequency(ofPitch: pitch, order: 7.0)  / 16.0,  // E
            frequency(ofPitch: pitch, order: 8.0)  / 16.0,  // F
            frequency(ofPitch: pitch, order: 9.0)  / 16.0,  // Gb
            frequency(ofPitch: pitch, order: 10.0) / 16.0,  // G
            frequency(ofPitch: pitch, order: 11.0) / 16.0,  // Ab
            frequency(ofPitch: pitch, order: 0.0)  / 8.0,   // A
            frequency(ofPitch: pitch, order: 1.0)  / 8.0,   // Bb
            frequency(ofPitch: pitch, order: 2.0)  / 8.0,   // B
        ]
        
        let tones: [Tone] = [
            .C, .Db, .D, .Eb, .E, .F, .Gb, .G, .Ab, .A, .Bb, .B
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
        let indexBoundary = 6  // index of Gb
        let indexOfTranspositionTone = tones.index(of: transpositionTone)!
        if (indexBoundary < indexOfTranspositionTone) {
            for i in 0..<rearrangedBaseTuning.count {
                rearrangedBaseTuning[i] /= 2.0
            }
        }
        
        var tuning = [Tone: Float]()
        for i in 0..<tones.count {
            tuning[tones[i]] = rearrangedBaseTuning[i]
        }
        return tuning
    }
    
    // Generate 12 frequencies for spacified octave by integral multiplication
    private static func calculateTuning(ofOctave octave: Int, tuningBase: [Tone: Float]) -> [String: Float] {
        var tuningOfCurrentOctave = [String: Float]()
        for key in tuningBase.keys {
            let currentOctaveString = String(octave)
            guard let baseFrequency = tuningBase[key] else { continue }
            let frequencyForCurrentOctave = Float(pow(2.0, Float(octave - 1))) * baseFrequency as Float
            let currentOctaveKey = key.rawValue + currentOctaveString
            tuningOfCurrentOctave[currentOctaveKey] = frequencyForCurrentOctave
        }
        return tuningOfCurrentOctave
    }
    
    // Tuning Equal
    private static func transposeTuningBase(_ tuningBase: [String: Float], transpositionTone: String) -> [String: Float] {
        return tuningBase
    }
    
    private static func tuneEqual(setting: Setting) -> [String: Float] {
        let tuningBase = equalBase(pitch: setting.pitch, transpositionTone: setting.transpositionTone)
        
        var tuning = [String: Float]()
        let octaveRange = setting.octaveRange
        octaveRange.forEach { octave in
            let tuningForThisOctave = calculateTuning(ofOctave: octave, tuningBase: tuningBase)
            for (soundName, Frequency) in tuningForThisOctave {
                tuning[soundName] = Frequency
            }        
        }
        return tuning
    }
    
    // Tuning Pure Major
    // Frequency ratio for standard pitch: r = 2^(n/12 + m/1200)
    // n: Interval difference (1 for semitone)
    // m: Difference from equal temperament (in cent)
    private static func centOffsetsForPureMajor() -> [Float] {
        let offset1:  Float =   0.0 / 1200.0
        let offset2:  Float = -29.3 / 1200.0
        let offset3:  Float =   3.9 / 1200.0
        let offset4:  Float =  15.6 / 1200.0
        let offset5:  Float = -13.7 / 1200.0
        let offset6:  Float =  -2.0 / 1200.0
        let offset7:  Float = -31.3 / 1200.0
        let offset8:  Float =   2.0 / 1200.0
        let offset9:  Float = -27.4 / 1200.0
        let offset10: Float = -15.6 / 1200.0
        let offset11: Float =  17.6 / 1200.0
        let offset12: Float = -11.7 / 1200.0
        return [offset1, offset2, offset3, offset4, offset5, offset6,
                offset7, offset8, offset9, offset10, offset11, offset12]
    }
    
    // Tuning Pure Minor
    // Frequency ratio for standard pitch: r = 2^(n/12 + m/1200)
    private static func centOffsetsForPureMinor() -> [Float] {
        let offset1:  Float =   0.0 / 1200.0
        let offset2:  Float =  33.2 / 1200.0
        let offset3:  Float =   3.9 / 1200.0
        let offset4:  Float =  15.6 / 1200.0
        let offset5:  Float = -13.7 / 1200.0
        let offset6:  Float =  -2.0 / 1200.0
        let offset7:  Float =  31.3 / 1200.0
        let offset8:  Float =   2.0 / 1200.0
        let offset9:  Float =  13.7 / 1200.0
        let offset10: Float = -15.6 / 1200.0
        let offset11: Float =  17.6 / 1200.0
        let offset12: Float = -11.7 / 1200.0
        return [offset1, offset2, offset3, offset4, offset5, offset6,
                offset7, offset8, offset9, offset10, offset11, offset12]
    }
    
    // Generate one-octave tones based on specified root tone
    private static func arrangeSoundNames(rootTone: Tone) -> [Tone] {
        let tones: [Tone] = [
            .A, .Bb, .B, .C, .Db, .D, .Eb, .E, .F, .Gb, .G, .Ab
        ];
        var newTones = [Tone]()
        let rootIndex: Int = tones.index(of: rootTone)!
        
        var currentRootIndex = rootIndex
        for _ in 0..<tones.count {
            currentRootIndex = currentRootIndex == tones.count ? 0 : currentRootIndex
            newTones.append(tones[currentRootIndex])
            currentRootIndex += 1
        }
        return newTones
    }
    
    private static func pureBase(setting: Setting, centOffsets: [Float]) -> [Tone: Float] {
        var tuning = [Tone: Float]()
        let tones = arrangeSoundNames(rootTone: setting.rootTone)
        
        // Calculatte based on equal-tuning
        let tuningEqualBase = equalBase(pitch: setting.pitch, transpositionTone: setting.transpositionTone)
        
        for i in 0..<tones.count {
            let tone = tones[i]
            let frequencyForEqual: Float = tuningEqualBase[tone] as Float!
            let frequency = frequencyForEqual * pow(2.0, centOffsets[i] as Float)
            
            tuning[tone] = frequency
        }
        return tuning
    }
    
    private static func tunePureMajor(setting: Setting) -> [String: Float] {
        let centOffsetsPureMajor: [Float] = centOffsetsForPureMajor()
        let tuningPureMajorBase = pureBase(setting: setting, centOffsets: centOffsetsPureMajor)
        let tuning = tuneWholePure(setting: setting, tuningPureBase: tuningPureMajorBase)
        return tuning
    }
    
    private static func tunePureMinor(setting: Setting) -> [String: Float] {
        let centOffsetsPureMinor: [Float] = centOffsetsForPureMinor()
        let tuningPureMinorBase = pureBase(setting: setting, centOffsets: centOffsetsPureMinor)
        let tuning = tuneWholePure(setting: setting, tuningPureBase: tuningPureMinorBase)
        return tuning
    }
    
    private static func tuneWholePure(setting: Setting, tuningPureBase: [Tone: Float]) -> [String: Float] {
        var tuning = [String: Float]()
        setting.octaveRange.forEach { octave in
            let tuningOfCurrentOctave = calculateTuning(ofOctave: octave, tuningBase: tuningPureBase)
            for (soundName, Frequency) in tuningOfCurrentOctave {
                tuning[soundName] = Frequency
            }
        }
        return tuning
    }
}

extension Tuning.Setting: CustomStringConvertible {
    public var description: String {
        return "pitch => \(pitch), scaleType => \(scaleType), rootSound => \(rootTone.rawValue), transpositionTone => \(transpositionTone)"
    }
}
