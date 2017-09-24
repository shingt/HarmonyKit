public struct Harmony {
    public var tone: Tone
    public var octave: Int
    public var frequency: Float
}

extension Harmony: Equatable {
    public static func == (lhs: Harmony, rhs: Harmony) -> Bool {
        return lhs.tone == rhs.tone
            && lhs.octave == rhs.octave
            && Int(lhs.frequency) == Int(rhs.frequency) // Not sure it's enough.
    }
}

extension Harmony: Comparable {
    public static func < (lhs: Harmony, rhs: Harmony) -> Bool {
        return lhs.octave <= rhs.octave
            && lhs.tone < rhs.tone
    }
}

extension Harmony: CustomStringConvertible {
    public var description: String {
        return "tone: \(tone), octave: \(octave), frequency: \(frequency)"
    }
}
