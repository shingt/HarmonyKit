public struct Harmony {
    public var tone: Tone
    public var octave: Int
    public var frequency: Float

    init(tone: Tone, octave: Int, frequency: Float) {
        self.tone = tone
        self.octave = octave
        self.frequency = frequency
    }
}

extension Harmony: Equatable {}

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
