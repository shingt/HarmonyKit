import Foundation

public struct TuningInfo {
    let pitch:             Float
    let tuningType:        TuningType
    let rootSound:         String
    let transpositionNote: String
    let octaveRange:       CountableRange<Int>
}

extension TuningInfo: CustomStringConvertible {
    public var description: String {
        return "pitch => \(pitch), tuningType => \(tuningType), rootSound => \(rootSound), transpositionNote => \(transpositionNote)"
    }
}

public enum TuningType {
    case equal
    case pureMajor
    case pureMinor
    case pythagorean
    case userDefined
}

// FIXME: enum doesn't work as we need "A1", "B2" as well.
public let SoundBaseA  = "A"
public let SoundBaseBb = "B♭"
public let SoundBaseB  = "B"
public let SoundBaseC  = "C"
public let SoundBaseDb = "D♭"
public let SoundBaseD  = "D"
public let SoundBaseEb = "E♭"
public let SoundBaseE  = "E"
public let SoundBaseF  = "F"
public let SoundBaseGb = "G♭"
public let SoundBaseG  = "G"
public let SoundBaseAb = "A♭"

open class Tuning {
    
    open class func tuningByInfo(info: TuningInfo) -> [String: Float] {
        var tuning = [String: Float]()
        
        switch info.tuningType {
        case TuningType.equal:
            tuning = equalByInfo(info)
        case TuningType.pureMajor:
            tuning = pureMajorByInfo(info: info)
        case TuningType.pureMinor:
            tuning = pureMinorByInfo(info: info)
        // case TuningType.Pythagorean:
        // case TuningType.UserDefined:
        default:
            print("Unexpected tuning type: \(info.tuningType)")
        }
        
        return tuning
    }
    
    fileprivate class func frequency(ofPitch pitch: Float, order: Float) -> Float {
        return pitch * pow(2.0,  order / 12.0)
    }
    
    // Base refers C1, D1, ... in:
    // => http://ja.wikipedia.org/wiki/%E9%9F%B3%E5%90%8D%E3%83%BB%E9%9A%8E%E5%90%8D%E8%A1%A8%E8%A8%98
    fileprivate class func equalBase(pitch: Float, transpositionNote: String) -> [String: Float] {
        
        // Frequencies when transpositionNote = C
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
        
        let sounds: [String] = [
            SoundBaseC,  SoundBaseDb, SoundBaseD,  SoundBaseEb, SoundBaseE,  SoundBaseF,
            SoundBaseGb, SoundBaseG,  SoundBaseAb, SoundBaseA,  SoundBaseBb, SoundBaseB
        ]
        
        var rearrangedBaseTuning: [Float] = []
        
        for i in 0..<sounds.count {
            if transpositionNote == sounds[i] as String {
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
        let indexOfTranspositionNote = sounds.index(of: transpositionNote)!
        if (indexBoundary < indexOfTranspositionNote) {
        for i in 0..<rearrangedBaseTuning.count {
            rearrangedBaseTuning[i] /= 2.0
        }
    }
    
    var tuning = [String: Float]()
    for i in 0..<sounds.count {
        tuning[sounds[i]] = rearrangedBaseTuning[i]
    }
    return tuning
    }
    
    // Generate 12 frequencies for spacified octave by integral multiplication
    fileprivate class func calculateTuning(ofOctave octave: Int, tuningBase: [String: Float]) -> [String: Float] {
        var tuningOfCurrentOctave = [String: Float]()
        for key in tuningBase.keys {
            let currentOctaveString = String(octave)
            guard let baseFrequency = tuningBase[key] else { continue }
            let frequencyForCurrentOctave = Float(pow(2.0, Float(octave - 1))) * baseFrequency as Float
            let currentOctaveKey = key + currentOctaveString
            tuningOfCurrentOctave[currentOctaveKey] = frequencyForCurrentOctave
        }
        return tuningOfCurrentOctave
    }
    
    // Tuning Equal
    fileprivate class func transposeTuningBase(_ tuningBase: [String: Float], transpositionNote: String) -> [String: Float] {
        return tuningBase
    }
    
    fileprivate class func equalByInfo(_ info: TuningInfo) -> [String: Float] {
        var tuning = [String: Float]()
        let tuningBase = equalBase(pitch: info.pitch, transpositionNote: info.transpositionNote)
        
        let octaveRange = info.octaveRange
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
    fileprivate class func centOffsetsForPureMajor() -> [Float] {
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
    fileprivate class func centOffsetsForPureMinor() -> [Float] {
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
    
    // Generate one-octave sounds based on specified root sound
    fileprivate class func arrangeSoundNamesForRootSound(_ rootSound: String) -> [String] {
        let soundNames: [String] = [
            SoundBaseA,  SoundBaseBb, SoundBaseB, SoundBaseC,  SoundBaseDb, SoundBaseD,
            SoundBaseEb, SoundBaseE,  SoundBaseF, SoundBaseGb, SoundBaseG,  SoundBaseAb
        ];
        var newSoundNames = [String]()
        let rootIndex: Int = soundNames.index(of: rootSound)!
        
        var currentRootIndex = rootIndex
        for _ in 0..<soundNames.count {
            currentRootIndex = currentRootIndex == soundNames.count ? 0 : currentRootIndex
            newSoundNames.append(soundNames[currentRootIndex])
            currentRootIndex += 1
        }
        return newSoundNames
    }
    
    fileprivate class func pureBase(info: TuningInfo, centOffsets: [Float]) -> [String: Float] {
        var tuning = [String: Float]()
        let soundNames = arrangeSoundNamesForRootSound(info.rootSound)
        
        // Calculatte based on equal-tuning
        let tuningEqualBase = equalBase(pitch: info.pitch, transpositionNote: info.transpositionNote)
        
        for i in 0..<soundNames.count {
            let sound = soundNames[i]
            let frequencyForEqual: Float = tuningEqualBase[sound] as Float!
            let frequency = frequencyForEqual * pow(2.0, centOffsets[i] as Float)
            
            tuning[sound] = frequency
        }
        return tuning
    }
    
    fileprivate class func pureMajorByInfo(info: TuningInfo) -> [String: Float] {
        let centOffsetsPureMajor: [Float] = centOffsetsForPureMajor()
        let tuningPureMajorBase = pureBase(info: info, centOffsets: centOffsetsPureMajor)
        let tuning = wholePure(info: info, tuningPureBase: tuningPureMajorBase)
        return tuning
    }
    
    fileprivate class func pureMinorByInfo(info: TuningInfo) -> [String: Float] {
        let centOffsetsPureMinor: [Float] = centOffsetsForPureMinor()
        let tuningPureMinorBase = pureBase(info: info, centOffsets: centOffsetsPureMinor)
        let tuning = wholePure(info: info, tuningPureBase: tuningPureMinorBase)
        return tuning
    }
    
    fileprivate class func wholePure(info: TuningInfo, tuningPureBase: [String: Float]) -> [String: Float] {
        var tuning = [String: Float]()
        info.octaveRange.forEach { octave in
            let tuningOfCurrentOctave = calculateTuning(ofOctave: octave, tuningBase: tuningPureBase)
            for (soundName, Frequency) in tuningOfCurrentOctave {
                tuning[soundName] = Frequency
            }
        }
        return tuning
    }
}

