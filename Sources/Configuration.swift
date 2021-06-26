extension HarmonyKit {
    public struct Configuration {
        public var temperament: Temperament
        public var pitch: Float
        public var transpositionTone: Tone
        public var octaveRange: OctaveRange
    }
}

extension HarmonyKit.Configuration: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "type: \(temperament), pitch: \(pitch), temperament: \(temperament), transpositionTone: \(transpositionTone)"
    }
}
