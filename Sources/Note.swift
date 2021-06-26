extension HarmonyKit {
    public struct Note {
        public var tone: Tone
        public var octave: Int
        public var frequency: Float
    }
}

extension HarmonyKit.Note: Comparable {
    public static func < (lhs: HarmonyKit.Note, rhs: HarmonyKit.Note) -> Bool {
        return lhs.octave <= rhs.octave && lhs.tone < rhs.tone
    }
}

extension HarmonyKit.Note: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "tone: \(tone.name), octave: \(octave), frequency: \(frequency)"
    }
}
