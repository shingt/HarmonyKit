import Foundation

public enum ScaleType {
    case equal

    public enum Pure {
        case major
        case minor
    }
    case pure(Pure, rootTone: Tone)

    // TODO
    // case pythagorean
    // case userDefined
}
