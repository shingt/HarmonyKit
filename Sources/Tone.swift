extension HarmonyKit {
    public enum Tone: Int, CaseIterable {
        case A, Bb, B, C, Db, D, Eb, E, F, Gb, G, Ab

        var name: String {
            switch self {
            case .A: return "A"
            case .Bb: return "B♭"
            case .B: return "B"
            case .C: return "C"
            case .Db: return "D♭"
            case .D: return "D"
            case .Eb: return "E♭"
            case .E: return "E"
            case .F: return "F"
            case .Gb: return "G♭"
            case .G: return "G"
            case .Ab: return "A♭"
            }
        }
    }
}

extension HarmonyKit.Tone: Comparable {
    // FIXME: Comparison logic should live only with octave parameters.
    // i.e. It doesn't make sense to have A2 < Bb1.
    public static func < (lhs: HarmonyKit.Tone, rhs: HarmonyKit.Tone) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
