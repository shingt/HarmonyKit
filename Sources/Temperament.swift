extension HarmonyKit {
    public enum Temperament {
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
}
