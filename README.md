# HarmonyKit

[![CI Status](http://img.shields.io/travis/shingt/HarmonyKit.svg?style=flat)](https://travis-ci.com/github/shingt/HarmonyKit)
![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)

Tool to generate audio frequencies.

## Synopsis

```swift
let notes = HarmonyKit.tune(
    configuration: .init(
        temperament: .equal,
        pitch: 442,
        transpositionTone: .C,
        octaveRange: 1..<2
    )
)
notes.forEach { print($0) }

// =>
// tone: E, octave: 1, frequency: 41.390736
// tone: F, octave: 1, frequency: 43.851955
// tone: B♭, octave: 1, frequency: 58.53534
// tone: G♭, octave: 1, frequency: 46.459526
// tone: A♭, octave: 1, frequency: 52.149055
// tone: E♭, octave: 1, frequency: 39.06765
// tone: C, octave: 1, frequency: 32.851845
// tone: B, octave: 1, frequency: 62.016026
// tone: D, octave: 1, frequency: 36.87495
// tone: G, octave: 1, frequency: 49.222153
// tone: A, octave: 1, frequency: 55.25
// tone: D♭, octave: 1, frequency: 34.80532
```

You can also specify pure temperament:

```swift
let pureMajorNotes = HarmonyKit.tune(
    configuration: .init(
        temperament: .pure(.major, rootTone: .C),
        pitch: 442,
        transpositionTone: .C,
        octaveRange: 1..<2
    )
)

let pureMinorNotes = HarmonyKit.tune(
    configuration: .init(
        temperament: .pure(.minor, rootTone: .C),
        pitch: 442,
        transpositionTone: .C,
        octaveRange: 1..<2
    )
)
```

## Installation

HarmonyKit is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "HarmonyKit"
```

## Example

See `Tests/HarmonyKitTests/HarmonyKitTests.swift`.

### Author

shingt

## License

HarmonyKit is available under the MIT license. See the LICENSE file for more info.

