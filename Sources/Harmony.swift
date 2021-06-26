public struct Note {
    public var tone: Tone
    public var octave: Int
    public var frequency: Float
}

extension Note: Comparable {
    public static func < (lhs: Note, rhs: Note) -> Bool {
        return lhs.octave <= rhs.octave && lhs.tone < rhs.tone
    }
}

extension Note: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "tone: \(tone.name), octave: \(octave), frequency: \(frequency)"
    }
}
