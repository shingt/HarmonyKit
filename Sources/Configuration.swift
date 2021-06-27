extension HarmonyKit {
    public struct Configuration {
        public var temperament: Temperament
        public var pitch: Float
        public var transpositionTone: Tone
        public var octaveRange: OctaveRange

        public init(
            temperament: Temperament,
            pitch: Float,
            transpositionTone: Tone,
            octaveRange: OctaveRange
        ) {
            self.temperament = temperament
            self.pitch = pitch
            self.transpositionTone = transpositionTone
            self.octaveRange = octaveRange
        }
    }
}

extension HarmonyKit.Configuration: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "type: \(temperament), pitch: \(pitch), temperament: \(temperament), transpositionTone: \(transpositionTone)"
    }
}
