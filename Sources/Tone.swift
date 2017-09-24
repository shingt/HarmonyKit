public enum Tone: String {
    case A
    case Bb
    case B
    case C
    case Db
    case D
    case Eb
    case E
    case F
    case Gb
    case G
    case Ab
}

extension Tone: Comparable {
    public static func < (lhs: Tone, rhs: Tone) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
