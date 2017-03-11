open class OctaveRange {
  var start: Int// = 1
  var end:   Int// = 6

  public init(start: Int, end: Int) {
    if (start < 0 || end < 0) {
      print("error")
    } else if (start > end) {
      print("error")
    }
    self.start = start
    self.end   = end
  }
}

