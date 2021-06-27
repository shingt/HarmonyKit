extension HarmonyKit {
    public struct Note {
        public var tone: Tone
        public var octave: Int
        public var frequency: Float

        public init(
            tone: Tone,
            octave: Int,
            frequency: Float
        ) {
            self.tone = tone
            self.octave = octave
            self.frequency = frequency
        }
    }
}
extension HarmonyKit.Note: Hashable {}

extension HarmonyKit.Note: Comparable {
    public static func < (lhs: HarmonyKit.Note, rhs: HarmonyKit.Note) -> Bool {
        return lhs.octave <= rhs.octave && lhs.tone < rhs.tone
    }
}

extension HarmonyKit.Note: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "tone: \(tone.rawValue), octave: \(octave), frequency: \(frequency)"
    }
}
