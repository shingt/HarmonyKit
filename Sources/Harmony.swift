public struct Harmony {
    public var tone: Tone
    public var octave: Int
    public var frequency: Float
}

extension Harmony: Comparable {
    public static func < (lhs: Harmony, rhs: Harmony) -> Bool {
        return lhs.octave <= rhs.octave && lhs.tone < rhs.tone
    }
}

extension Harmony: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "tone: \(tone.name), octave: \(octave), frequency: \(frequency)"
    }
}
