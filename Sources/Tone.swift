public enum Tone: String {
    case A
    case Bb = "B♭"
    case B
    case C
    case Db = "D♭"
    case D
    case Eb = "E♭"
    case E
    case F
    case Gb = "G♭"
    case G
    case Ab = "A♭"
}

public extension Tone {
    var order: Int {
        switch self {
        case .A:  return 0
        case .Bb: return 1
        case .B:  return 2
        case .C:  return 3
        case .Db: return 4
        case .D:  return 5
        case .Eb: return 6
        case .E:  return 7
        case .F:  return 8
        case .Gb: return 9
        case .G:  return 10
        case .Ab: return 11
        }
    }
}

extension Tone: Comparable {
    public static func < (lhs: Tone, rhs: Tone) -> Bool {
        return lhs.order < rhs.order
    }
}
