//
//  AudioTuning.swift
//
//  Created by Shinichi Goto on 20/05/15.
//  Copyright (c) 2015 Shinichi Goto. All rights reserved.
//

import Foundation

typealias TranspositionNote = String

struct TuningInfo: Printable {
    var pitch: Float
    var tuningType:TuningType
    var rootSound:SoundType
    var transpositionNote:TranspositionNote

    var description: String { return "pitch => \(pitch), tuningType => \(tuningType), rootSound => \(rootSound), transpositionNote => \(transpositionNote)" }
}

enum TuningType {
    case Equal
    case PureMajor
    case PureMinor
    case Pythagorean
    case UserDefined
}

typealias SoundType = String
let SoundBaseA:  SoundType = "A"
let SoundBaseBb: SoundType = "B♭"
let SoundBaseB:  SoundType = "B"
let SoundBaseC:  SoundType = "C"
let SoundBaseDb: SoundType = "D♭"
let SoundBaseD:  SoundType = "D"
let SoundBaseEb: SoundType = "E♭"
let SoundBaseE:  SoundType = "E"
let SoundBaseF:  SoundType = "F"
let SoundBaseGb: SoundType = "G♭"
let SoundBaseG:  SoundType = "G"
let SoundBaseAb: SoundType = "A♭"

class Tuning {

    // FIXME...It seems class variable cannot be defined on Swift?
    struct Static {
        static let kMaxOctaveSuffix: Int = 6
    }

    class func generateTuningByInfo(tuningInfo: TuningInfo) -> [SoundType: Float] {
        var tuning :[SoundType:Float] = [:]
        
        switch tuningInfo.tuningType {
        case TuningType.Equal:
            tuning = self.generateTuningEqualByInfo(tuningInfo)
        case TuningType.PureMajor:
            tuning = self.generateTuningPureMajorByInfo(tuningInfo)
        case TuningType.PureMinor:
            tuning = self.generateTuningPureMinorByInfo(tuningInfo)
//        case TuningType.Pythagorean:
//        case TuningType.UserDefined:
        default:
            println("Unexpected tuning type: \(tuningInfo.tuningType)")
        }
      
        println("Pitch: \(tuningInfo.pitch)")
      
//        // For debug
//        let sortedTuning = sorted(tuning) { $0.0 < $1.0 }
//        println(sortedTuning)
        
        return tuning
    }
  
    // - Private methods -
    private class func frequencyForPitch(pitch: Float, order: Float) -> Float {
        return pitch * pow(2.0,  order / 12.0)
    }
   
    // SoundBaseは http://ja.wikipedia.org/wiki/%E9%9F%B3%E5%90%8D%E3%83%BB%E9%9A%8E%E5%90%8D%E8%A1%A8%E8%A8%98 のC1, D1などに当たる
    private class func generateTuningEqualBase(pitch: Float, transpositionNote: TranspositionNote) -> [SoundType: Float] {
        
        // 移調 = C のときに必要な音
        var baseTuning: [Float] = [
            self.frequencyForPitch(pitch, order: 3.0)  / 16.0,  // Cのkey
            self.frequencyForPitch(pitch, order: 4.0)  / 16.0,  // Db
            self.frequencyForPitch(pitch, order: 5.0)  / 16.0,  // D
            self.frequencyForPitch(pitch, order: 6.0)  / 16.0,  // Eb
            self.frequencyForPitch(pitch, order: 7.0)  / 16.0,  // E
            self.frequencyForPitch(pitch, order: 8.0)  / 16.0,  // F
            self.frequencyForPitch(pitch, order: 9.0)  / 16.0,  // Gb
            self.frequencyForPitch(pitch, order: 10.0) / 16.0,  // G
            self.frequencyForPitch(pitch, order: 11.0) / 16.0,  // Ab
            self.frequencyForPitch(pitch, order: 0.0)  / 8.0,  // A
            self.frequencyForPitch(pitch, order: 1.0)  / 8.0,  // Bb
            self.frequencyForPitch(pitch, order: 2.0)  / 8.0,  // B
        ]
        
        let sounds: [SoundType] = [
            SoundBaseC, SoundBaseDb, SoundBaseD, SoundBaseEb, SoundBaseE, SoundBaseF,
            SoundBaseGb, SoundBaseG, SoundBaseAb, SoundBaseA, SoundBaseBb, SoundBaseB
        ]
      
        var rearrangedBaseTuning: [Float] = []
       
        for i in 0..<sounds.count {
            if transpositionNote as String == sounds[i] as String {
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

        // Gbまでは上がってGからは下がる
        let indexBoundary = 6  // index of Gb
        let indexOfTranspositionNote = find(sounds, transpositionNote)
        if (indexBoundary < indexOfTranspositionNote) {
            for i in 0..<rearrangedBaseTuning.count {
                rearrangedBaseTuning[i] /= 2.0
            }
        }
      
        var tuning: [SoundType: Float] = [:]
        for i in 0..<sounds.count {
            tuning[sounds[i]] = rearrangedBaseTuning[i]
        }
        return tuning
    }
  
    /*
    * あるオクターブに対する12音をtuningBaseを整数倍することで生成
    */
    private class func generateTuningForOctave(octave: Int, tuningBase: [SoundType: Float]) -> [SoundType: Float] {
        var tuningForCurrentOctave = [SoundType: Float]()
        for key in tuningBase.keys {
            let currentOctaveString = String(octave)
            let keyForCurrentOctave = key as String + currentOctaveString
            let frequencyForCurrentOctave: Float = Float(pow(2.0, Float(octave - 1))) * tuningBase[key]! as Float
            tuningForCurrentOctave[keyForCurrentOctave] = frequencyForCurrentOctave
        }
        return tuningForCurrentOctave
    }
    
    // - Tuning Equal -
    private class func transposeTuningBase(tuningBase: [SoundType: Float], transpositionNote: TranspositionNote) -> [SoundType: Float] {
        return tuningBase
    }
    
    private class func generateTuningEqualByInfo(tuningInfo: TuningInfo) -> [SoundType: Float] {
        var tuning = [SoundType: Float]()
        let tuningBase = self.generateTuningEqualBase(tuningInfo.pitch, transpositionNote: tuningInfo.transpositionNote)
        
        for octave in 1...Static.kMaxOctaveSuffix {
            let tuningForThisOctave = self.generateTuningForOctave(octave, tuningBase: tuningBase)
            for (soundName, Frequency) in tuningForThisOctave {
                tuning[soundName] = Frequency
            }
        }
        return tuning
    }
    
    // - Tuning Pure -
   
    // 純正律（長調）centによる計算
    // 基準ピッチとの周波数比r = 2^(n/12 + m/1200)
    // n:音程差（半音であれば1） m:平均律とのズレ(cent)
    private class func centOffsetsForPureMajor() -> Array<Float> {
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
        return [offset1, offset2, offset3, offset4, offset5, offset6, offset7, offset8, offset9, offset10, offset11, offset12]
    }
    
    // 純正律（短調）centによる計算
    // 基準ピッチとの周波数比r = 2^(n/12 + m/1200)
    // n:音程差（半音であれば1） m:平均律とのズレ(cent)
    private class func centOffsetsForPureMinor() -> Array<Float> {
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
        return [offset1, offset2, offset3, offset4, offset5, offset6, offset7, offset8, offset9, offset10, offset11, offset12]
    }
    
    /*
    *  指定ルート音を最初の要素とした配列を生成
    */
    private class func arrangeSoundNamesForRootSound(rootSound: SoundType) -> [SoundType] {
        let soundNames = [
            SoundBaseA, SoundBaseBb, SoundBaseB, SoundBaseC, SoundBaseDb, SoundBaseD,
            SoundBaseEb, SoundBaseE, SoundBaseF, SoundBaseGb, SoundBaseG, SoundBaseAb
        ];
        var newSoundNames = [SoundType]()
        let rootIndex: Int = find(soundNames, rootSound)!
    
        var currentRootIndex = rootIndex
        for i in 0..<soundNames.count {
            currentRootIndex = currentRootIndex == soundNames.count ? 0 : currentRootIndex
            newSoundNames.append(soundNames[currentRootIndex])
            ++currentRootIndex
        }
        return newSoundNames
    }
    
    private class func generateTuningPureBase(tuningInfo: TuningInfo, centOffsets: [Float]) ->[SoundType: Float] {
        var tuning = [SoundType: Float]()
        let soundNames = self.arrangeSoundNamesForRootSound(tuningInfo.rootSound)
        // 平均律をベースに演算
        let tuningEqualBase = self.generateTuningEqualBase(tuningInfo.pitch, transpositionNote: tuningInfo.transpositionNote)
       
        for i in 0..<soundNames.count {
            let sound = soundNames[i]
            let frequencyForEqual: Float = tuningEqualBase[sound] as Float!
            let frequency = frequencyForEqual * pow(2.0, centOffsets[i] as Float)

            tuning[sound] = frequency
        }
        return tuning
    }
   
    private class func generateTuningPureMajorByInfo(tuningInfo: TuningInfo) -> [SoundType: Float] {
        let centOffsetsPureMajor: [Float] = self.centOffsetsForPureMajor()
        let tuningPureMajorBase = self.generateTuningPureBase(tuningInfo, centOffsets: centOffsetsPureMajor)
        let tuning = self.generateWholeTuningPure(tuningPureMajorBase)
        return tuning
    }

    private class func generateTuningPureMinorByInfo(tuningInfo: TuningInfo) -> [SoundType: Float] {
        let centOffsetsPureMinor: [Float] = self.centOffsetsForPureMinor()
        let tuningPureMinorBase = self.generateTuningPureBase(tuningInfo, centOffsets: centOffsetsPureMinor)
        let tuning = self.generateWholeTuningPure(tuningPureMinorBase)
        return tuning
    }
    
    /*
    * 複数オクターブ分生成
    */
    private class func generateWholeTuningPure(tuningPureBase: [SoundType: Float]) -> [SoundType: Float] {
        var tuning = [SoundType: Float]()
        for octave in 1...Static.kMaxOctaveSuffix {
            let tuningForCurrentOctave = self.generateTuningForOctave(octave, tuningBase: tuningPureBase)
            for (soundName, Frequency) in tuningForCurrentOctave {
                tuning[soundName] = Frequency
            }
        }
        return tuning
    }
}

// Test

let tuningInfo = TuningInfo(
    pitch:             442,
    tuningType:        TuningType.Equal,
    rootSound:         SoundBaseC,
    transpositionNote: SoundBaseC
  )

let tuning: [SoundType:Float] = Tuning.generateTuningByInfo(tuningInfo)
for sound in tuning.keys {
  let freq = tuning[sound]
  println("Sound: \(sound) => Freq: \(freq)")
}

