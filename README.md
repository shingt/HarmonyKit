# AudioTuning
[![Build Status](https://travis-ci.org/shingt/AudioTuning.svg?branch=master)](https://travis-ci.org/shingt/AudioTuning)

Tool to generate audio frequencies. Work in progress.

## Synopsis

First you need to define tuning information like:

```swift
let info = TuningInfo(
    pitch:             442,
    tuningType:        TuningType.Equal,
    rootSound:         SoundBaseC,
    transpositionNote: SoundBaseC,
    octaveRange:       OctaveRange(start:1, end: 2)
  )
```

and then

```swift
let tuning = Tuning.tuningByInfo(info)
```

## Example

Currently just do:

```swift
swift AudioTuning.swift
```

and then you receive

```swift
Sound: D2 => Freq: 73.7499
Sound: C2 => Freq: 65.7037
Sound: B♭1 => Freq: 58.5353
Sound: G2 => Freq: 98.4443
Sound: A2 => Freq: 110.5
Sound: B2 => Freq: 124.032
Sound: G♭1 => Freq: 46.4595
Sound: D♭2 => Freq: 69.6106
Sound: G♭2 => Freq: 92.9191
Sound: F2 => Freq: 87.7039
Sound: E2 => Freq: 82.7815
Sound: G1 => Freq: 49.2222
Sound: F1 => Freq: 43.852
Sound: D♭1 => Freq: 34.8053
Sound: C1 => Freq: 32.8518
Sound: E♭1 => Freq: 39.0676
Sound: A♭2 => Freq: 104.298
Sound: B1 => Freq: 62.016
Sound: E♭2 => Freq: 78.1353
Sound: D1 => Freq: 36.875
Sound: E1 => Freq: 41.3907
Sound: B♭2 => Freq: 117.071
Sound: A♭1 => Freq: 52.1491
Sound: A1 => Freq: 55.25
```

### Author

shingt

