//
//  OctaveRange.swift
//  AudioTuning
//
//  Created by Shinichi Goto on 6/7/15.
//  Copyright (c) 2015 Shinichi Goto. All rights reserved.
//

public class OctaveRange {
    var start: Int// = 1
    var end:   Int// = 6
    
    public init(start: Int, end: Int) {
        if (start < 0 || end < 0) {
            println("error")
        } else if (start > end) {
            println("error")
        }
        self.start = start
        self.end   = end
    }
}

