//
//  AudioTuning.swift
//
//  Created by Shinichi Goto on 20/05/15.
//  Copyright (c) 2015 Shinichi Goto. All rights reserved.
//

import Foundation

public struct TuningInfo: CustomStringConvertible {
  let pitch:             Float
  let tuningType:        TuningType
  let rootSound:         SoundName
  let transpositionNote: SoundName
  let octaveRange:       OctaveRange

  public init(pitch: Float, tuningType: TuningType, rootSound: SoundName, transpositionNote: SoundName, octaveRange: OctaveRange) {
    self.pitch             = pitch
    self.tuningType        = tuningType
    self.rootSound         = rootSound
    self.transpositionNote = transpositionNote
    self.octaveRange       = octaveRange
  }
  public var description: String { return "pitch => \(pitch), tuningType => \(tuningType), rootSound => \(rootSound), transpositionNote => \(transpositionNote)" }
}

public enum TuningType {
  case Equal
  case PureMajor
  case PureMinor
  case Pythagorean
  case UserDefined
}

// FIXME: enum doesn't work as we need "A1", "B2" as well.
public typealias SoundName = String
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

public class Tuning {

  public class func tuningByInfo(info: TuningInfo) -> [SoundName: Float] {
    var tuning = [SoundName: Float]()

    switch info.tuningType {
    case TuningType.Equal:
      tuning = equalByInfo(info)
    case TuningType.PureMajor:
      tuning = pureMajorByInfo(info)
    case TuningType.PureMinor:
      tuning = pureMinorByInfo(info)
    //        case TuningType.Pythagorean:
    //        case TuningType.UserDefined:
    default:
      print("Unexpected tuning type: \(info.tuningType)")
    }

    return tuning
  }

  private class func frequencyForPitch(pitch: Float, order: Float) -> Float {
    return pitch * pow(2.0,  order / 12.0)
  }

    // Base refers C1, D1, ... in:
  // => http://ja.wikipedia.org/wiki/%E9%9F%B3%E5%90%8D%E3%83%BB%E9%9A%8E%E5%90%8D%E8%A1%A8%E8%A8%98
  private class func equalBase(pitch: Float, transpositionNote: SoundName) -> [SoundName: Float] {

    // Frequencies when transpositionNote = C
    var baseTuning: [Float] = [
      frequencyForPitch(pitch, order: 3.0)  / 16.0,  // C
      frequencyForPitch(pitch, order: 4.0)  / 16.0,  // Db
      frequencyForPitch(pitch, order: 5.0)  / 16.0,  // D
      frequencyForPitch(pitch, order: 6.0)  / 16.0,  // Eb
      frequencyForPitch(pitch, order: 7.0)  / 16.0,  // E
      frequencyForPitch(pitch, order: 8.0)  / 16.0,  // F
      frequencyForPitch(pitch, order: 9.0)  / 16.0,  // Gb
      frequencyForPitch(pitch, order: 10.0) / 16.0,  // G
      frequencyForPitch(pitch, order: 11.0) / 16.0,  // Ab
      frequencyForPitch(pitch, order: 0.0)  / 8.0,   // A
      frequencyForPitch(pitch, order: 1.0)  / 8.0,   // Bb
      frequencyForPitch(pitch, order: 2.0)  / 8.0,   // B
    ]

    let sounds: [SoundName] = [
      SoundBaseC,  SoundBaseDb, SoundBaseD,  SoundBaseEb, SoundBaseE,  SoundBaseF,
      SoundBaseGb, SoundBaseG,  SoundBaseAb, SoundBaseA,  SoundBaseBb, SoundBaseB
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

    // Go up till Gb and go down after G
    let indexBoundary = 6  // index of Gb
    let indexOfTranspositionNote = sounds.indexOf(transpositionNote)
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

  // Generate 12 frequencies for spacified octave by integral multiplication
  private class func tuningForOctave(octave: Int, tuningBase: [SoundName: Float]) -> [SoundName: Float] {
    var tuningForCurrentOctave = [SoundName: Float]()
    for key in tuningBase.keys {
      let currentOctaveString = String(octave)
      let keyForCurrentOctave = key + currentOctaveString
      let frequencyForCurrentOctave = Float(pow(2.0, Float(octave - 1))) * tuningBase[key]! as Float
      tuningForCurrentOctave[keyForCurrentOctave] = frequencyForCurrentOctave
    }
    return tuningForCurrentOctave
  }

  // Tuning Equal
  private class func transposeTuningBase(tuningBase: [SoundName: Float], transpositionNote: String) -> [SoundName: Float] {
    return tuningBase
  }

  private class func equalByInfo(info: TuningInfo) -> [SoundName: Float] {
    var tuning = [SoundName: Float]()
    let tuningBase = equalBase(info.pitch, transpositionNote: info.transpositionNote)

    let octaveRange = info.octaveRange
    for octave in octaveRange.start...octaveRange.end {
      let tuningForThisOctave = tuningForOctave(octave, tuningBase: tuningBase)
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
  private class func centOffsetsForPureMajor() -> [Float] {
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
  private class func centOffsetsForPureMinor() -> [Float] {
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
  private class func arrangeSoundNamesForRootSound(rootSound: SoundName) -> [SoundName] {
    let soundNames: [SoundName] = [
      SoundBaseA,  SoundBaseBb, SoundBaseB, SoundBaseC,  SoundBaseDb, SoundBaseD,
      SoundBaseEb, SoundBaseE,  SoundBaseF, SoundBaseGb, SoundBaseG,  SoundBaseAb
    ];
    var newSoundNames = [SoundName]()
    let rootIndex: Int = soundNames.indexOf(rootSound)!

    var currentRootIndex = rootIndex
    for _ in 0..<soundNames.count {
      currentRootIndex = currentRootIndex == soundNames.count ? 0 : currentRootIndex
      newSoundNames.append(soundNames[currentRootIndex])
      ++currentRootIndex
    }
    return newSoundNames
  }

  private class func pureBase(info: TuningInfo, centOffsets: [Float]) ->[SoundName: Float] {
    var tuning = [SoundName: Float]()
    let soundNames = arrangeSoundNamesForRootSound(info.rootSound)

    // Calculatte based on equal-tuning
    let tuningEqualBase = equalBase(info.pitch, transpositionNote: info.transpositionNote)

    for i in 0..<soundNames.count {
      let sound = soundNames[i]
      let frequencyForEqual: Float = tuningEqualBase[sound] as Float!
      let frequency = frequencyForEqual * pow(2.0, centOffsets[i] as Float)

      tuning[sound] = frequency
    }
    return tuning
  }

  private class func pureMajorByInfo(info: TuningInfo) -> [SoundName: Float] {
    let centOffsetsPureMajor: [Float] = centOffsetsForPureMajor()
    let tuningPureMajorBase = pureBase(info, centOffsets: centOffsetsPureMajor)
    let tuning = wholePure(info, tuningPureBase: tuningPureMajorBase)
    return tuning
  }

  private class func pureMinorByInfo(info: TuningInfo) -> [SoundName: Float] {
    let centOffsetsPureMinor: [Float] = centOffsetsForPureMinor()
    let tuningPureMinorBase = pureBase(info, centOffsets: centOffsetsPureMinor)
    let tuning = wholePure(info, tuningPureBase: tuningPureMinorBase)
    return tuning
  }

  private class func wholePure(info: TuningInfo, tuningPureBase: [SoundName: Float]) -> [SoundName: Float] {
    var tuning = [SoundName: Float]()
    let octaveRange = info.octaveRange
    for octave in octaveRange.start...octaveRange.end {
      let tuningForCurrentOctave = tuningForOctave(octave, tuningBase: tuningPureBase)
      for (soundName, Frequency) in tuningForCurrentOctave {
        tuning[soundName] = Frequency
      }
    }
    return tuning
  }
}

