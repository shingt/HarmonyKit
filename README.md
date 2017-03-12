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
let tunings = Tuning.tune(setting: setting)
print(tunings)
// => ["F1": 43.8519554, "Db1": 34.8053207, "A1": 55.25, "Gb1": 46.4595261, "C1": 32.8518448, "B1": 62.0160255, "Ab1": 52.1490555, "Bb1": 58.5353394, "D1": 36.8749504, "Eb1": 39.0676498, "E1": 41.3907356, "G1": 49.2221527]
```

## Example

See `AudioTuning/AudioTuningTests/AudioTuningTests.swift`.

### Author

shingt

## License

DraggableModalTransition is available under the MIT license. See the LICENSE file for more info.

