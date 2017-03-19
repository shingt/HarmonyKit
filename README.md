# AudioTuning

[![CI Status](http://img.shields.io/travis/shingt/AudioTuning.svg?style=flat)](https://travis-ci.org/shingt/AudioTuning)
![Xcode 8.2+](https://img.shields.io/badge/Xcode-8.2%2B-blue.svg)
![iOS 9.0+](https://img.shields.io/badge/iOS-9.0%2B-blue.svg)
![Swift 3.0+](https://img.shields.io/badge/Swift-3.0%2B-orange.svg)

Tool to generate audio frequencies.

## Synopsis

First you need to define a tuning setting 

```swift
let setting = Tuning.Setting(
    pitch: 442,
    scaleType: .equal,
    rootTone: .C,
    transpositionTone: .C,
    octaveRange: 1..<2
)
```

and then

```swift
let harmonies = Tuning.tune(setting: setting)
let sortedHarmonies = harmonies.sorted()
sortedHarmonies.forEach { print($0) }
// =>
// tone: A, octave: 1, frequency: 55.25
// tone: Bb, octave: 1, frequency: 58.5353
// tone: B, octave: 1, frequency: 62.016
// tone: C, octave: 1, frequency: 32.8518
// tone: Db, octave: 1, frequency: 34.8053
// tone: D, octave: 1, frequency: 36.875
// tone: Eb, octave: 1, frequency: 39.0676
// tone: E, octave: 1, frequency: 41.3907
// tone: F, octave: 1, frequency: 43.852
// tone: Gb, octave: 1, frequency: 46.4595
// tone: G, octave: 1, frequency: 49.2222
// tone: Ab, octave: 1, frequency: 52.1491
```

If you specify `.pureMajor` for `scaleType`:

```swift
sortedHarmonies.forEach { print($0) }
// =>
// tone: A, octave: 1, frequency: 54.7544
// tone: Bb, octave: 1, frequency: 59.1335
// tone: B, octave: 1, frequency: 61.5983
// tone: C, octave: 1, frequency: 32.8518
// tone: Db, octave: 1, frequency: 34.2212
// tone: D, octave: 1, frequency: 36.9581
// tone: Eb, octave: 1, frequency: 39.4213
// tone: E, octave: 1, frequency: 41.0645
// tone: F, octave: 1, frequency: 43.8013
// tone: Gb, octave: 1, frequency: 45.6271
// tone: G, octave: 1, frequency: 49.2791
// tone: Ab, octave: 1, frequency: 51.3302
```

`.pureMinor`:

```swift
sortedHarmonies.forEach { print($0) }
// =>
// tone: A, octave: 1, frequency: 54.7544
// tone: Bb, octave: 1, frequency: 59.1335
// tone: B, octave: 1, frequency: 61.5983
// tone: C, octave: 1, frequency: 32.8518
// tone: Db, octave: 1, frequency: 35.4792
// tone: D, octave: 1, frequency: 36.9581
// tone: Eb, octave: 1, frequency: 39.4213
// tone: E, octave: 1, frequency: 41.0645
// tone: F, octave: 1, frequency: 43.8013
// tone: Gb, octave: 1, frequency: 47.3071
// tone: G, octave: 1, frequency: 49.2791
// tone: Ab, octave: 1, frequency: 52.5634
```

## Example

See `AudioTuning/AudioTuningTests/AudioTuningTests.swift`.

### Author

shingt

## License

AudioTuning is available under the MIT license. See the LICENSE file for more info.

