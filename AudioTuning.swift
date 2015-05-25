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
    var rootSound:SoundName
    var transpositionNote:SoundName

    var description: String { return "pitch => \(pitch), tuningType => \(tuningType), rootSound => \(rootSound), transpositionNote => \(transpositionNote)" }
}

enum TuningType {
    case Equal
    case PureMajor
    case PureMinor
    case Pythagorean
    case UserDefined
}

typealias SoundName = String
let SoundBaseA  = "A"
let SoundBaseBb = "B♭"
let SoundBaseB  = "B"
let SoundBaseC  = "C"
let SoundBaseDb = "D♭"
let SoundBaseD  = "D"
let SoundBaseEb = "E♭"
let SoundBaseE  = "E"
let SoundBaseF  = "F"
let SoundBaseGb = "G♭"
let SoundBaseG  = "G"
let SoundBaseAb = "A♭"

class Tuning {

    // FIXME...It seems class variable cannot be defined on Swift?
    struct Static {
        static let kMaxOctaveSuffix: Int = 6
    }

    class func generateByInfo(info: TuningInfo) -> [SoundName: Float] {
        var tuning = [SoundName: Float]()
      
        switch info.tuningType {
        case TuningType.Equal:
            tuning = self.generateEqualByInfo(info)
        case TuningType.PureMajor:
            tuning = self.generatePureMajorByInfo(info)
        case TuningType.PureMinor:
            tuning = self.generatePureMinorByInfo(info)
//        case TuningType.Pythagorean:
//        case TuningType.UserDefined:
        default:
            println("Unexpected tuning type: \(info.tuningType)")
        }
      
        return tuning
    }
  
    // - Private methods -
    private class func frequencyForPitch(pitch: Float, order: Float) -> Float {
        return pitch * pow(2.0,  order / 12.0)
    }
   
    // SoundBaseは http://ja.wikipedia.org/wiki/%E9%9F%B3%E5%90%8D%E3%83%BB%E9%9A%8E%E5%90%8D%E8%A1%A8%E8%A8%98 のC1, D1などに当たる
    private class func generateEqualBase(pitch: Float, transpositionNote: SoundName) -> [SoundName: Float] {
        
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
        
        let sounds: [SoundName] = [
            SoundBaseC, SoundBaseDb, SoundBaseD, SoundBaseEb, SoundBaseE, SoundBaseF,
            SoundBaseGb, SoundBaseG, SoundBaseAb, SoundBaseA, SoundBaseBb, SoundBaseB
        ]
      
        var rearrangedBaseTuning: [Float] = []
       
        for i in 0..<sounds.count {
            if transpositionNote == sounds[i] as SoundName {
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
      
        var tuning = [SoundName: Float]()
        for i in 0..<sounds.count {
            tuning[sounds[i]] = rearrangedBaseTuning[i]
        }
        return tuning
    }
  
    /*
    * あるオクターブに対する12音をtuningBaseを整数倍することで生成
    */
    private class func generateForOctave(octave: Int, tuningBase: [SoundName: Float]) -> [SoundName: Float] {
        var tuningForCurrentOctave = [SoundName: Float]()
        for key in tuningBase.keys {
            let currentOctaveString = String(octave)
            let keyForCurrentOctave = key + currentOctaveString
            let frequencyForCurrentOctave: Float = Float(pow(2.0, Float(octave - 1))) * tuningBase[key]! as Float
            tuningForCurrentOctave[keyForCurrentOctave] = frequencyForCurrentOctave
        }
        return tuningForCurrentOctave
    }
    
    // - Tuning Equal -
    private class func transposeTuningBase(tuningBase: [SoundName: Float], transpositionNote: TranspositionNote) -> [SoundName: Float] {
        return tuningBase
    }
    
    private class func generateEqualByInfo(info: TuningInfo) -> [SoundName: Float] {
        var tuning = [SoundName: Float]()
        let tuningBase = self.generateEqualBase(info.pitch, transpositionNote: info.transpositionNote)

        for octave in 1...Static.kMaxOctaveSuffix {
            let tuningForThisOctave = self.generateForOctave(octave, tuningBase: tuningBase)
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
        return [offset1, offset2, offset3, offset4, offset5, offset6, 
               offset7, offset8, offset9, offset10, offset11, offset12]
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
        return [offset1, offset2, offset3, offset4, offset5, offset6, 
               offset7, offset8, offset9, offset10, offset11, offset12]
    }
    
    /*
    *  指定ルート音を最初の要素とした配列を生成
    */
    private class func arrangeSoundNamesForRootSound(rootSound: SoundName) -> [SoundName] {
        let soundNames: [SoundName] = [
            SoundBaseA, SoundBaseBb, SoundBaseB, SoundBaseC, SoundBaseDb, SoundBaseD,
            SoundBaseEb, SoundBaseE, SoundBaseF, SoundBaseGb, SoundBaseG, SoundBaseAb
        ];
        var newSoundNames = [SoundName]()
        let rootIndex: Int = find(soundNames, rootSound)!
    
        var currentRootIndex = rootIndex
        for i in 0..<soundNames.count {
            currentRootIndex = currentRootIndex == soundNames.count ? 0 : currentRootIndex
            newSoundNames.append(soundNames[currentRootIndex])
            ++currentRootIndex
        }
        return newSoundNames
    }
    
    private class func generatePureBase(info: TuningInfo, centOffsets: [Float]) ->[SoundName: Float] {
        var tuning = [SoundName: Float]()
        let soundNames = self.arrangeSoundNamesForRootSound(info.rootSound)
        // 平均律をベースに演算
        let tuningEqualBase = self.generateEqualBase(info.pitch, transpositionNote: info.transpositionNote)
       
        for i in 0..<soundNames.count {
            let sound = soundNames[i]
            let frequencyForEqual: Float = tuningEqualBase[sound] as Float!
            let frequency = frequencyForEqual * pow(2.0, centOffsets[i] as Float)

            tuning[sound] = frequency
        }
        return tuning
    }
   
    private class func generatePureMajorByInfo(info: TuningInfo) -> [SoundName: Float] {
        let centOffsetsPureMajor: [Float] = self.centOffsetsForPureMajor()
        let tuningPureMajorBase = self.generatePureBase(info, centOffsets: centOffsetsPureMajor)
        let tuning = self.generateWholePure(tuningPureMajorBase)
        return tuning
    }

    private class func generatePureMinorByInfo(info: TuningInfo) -> [SoundName: Float] {
        let centOffsetsPureMinor: [Float] = self.centOffsetsForPureMinor()
        let tuningPureMinorBase = self.generatePureBase(info, centOffsets: centOffsetsPureMinor)
        let tuning = self.generateWholePure(tuningPureMinorBase)
        return tuning
    }
    
    /*
    * 複数オクターブ分生成
    */
    private class func generateWholePure(tuningPureBase: [SoundName: Float]) -> [SoundName: Float] {
        var tuning = [SoundName: Float]()
        for octave in 1...Static.kMaxOctaveSuffix {
            let tuningForCurrentOctave = self.generateForOctave(octave, tuningBase: tuningPureBase)
            for (soundName, Frequency) in tuningForCurrentOctave {
                tuning[soundName] = Frequency
            }
        }
        return tuning
    }
}

// Test

let info = TuningInfo(
    pitch:             442,
    tuningType:        TuningType.Equal,
    rootSound:         SoundBaseC,
    transpositionNote: SoundBaseC
  )

let tuning: [SoundName:Float] = Tuning.generateByInfo(info)
for sound in tuning.keys {
  let freq = tuning[sound]!
  println("Sound: \(sound) => Freq: \(freq)")
}

