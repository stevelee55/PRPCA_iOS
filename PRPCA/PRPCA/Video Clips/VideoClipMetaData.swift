//
//  VideoClipMetaData.swift
//  PRPCA
//
//  Created by Steve Lee on 8/1/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation

// Video Clip Metadata Class.
class VideoClipMetaData: NSObject, NSCoding {
    
    // Member Variables.
    var title:String = ""
    var dateCreated:String = ""
    var duration:Double = 0.0
    var orientation:String = ""
    
    // Encoder.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.dateCreated, forKey: "dateCreated")
        aCoder.encode(self.duration, forKey: "duration")
        aCoder.encode(self.orientation, forKey: "orientation")
    }
    // Decoder.
    required init?(coder aDecoder: NSCoder) {
        self.title = (aDecoder.decodeObject(forKey: "title") as? String)!
        self.dateCreated = (aDecoder.decodeObject(forKey: "dateCreated") as? String)!
        self.duration = aDecoder.decodeDouble(forKey: "duration")
        self.orientation = (aDecoder.decodeObject(forKey: "orientation") as? String)!
    }
    
    // Constructor.
    init(title:String, dateCreated:String, duration:Double, orientation:String) {
        self.title = title
        self.dateCreated = dateCreated
        self.duration = duration
        self.orientation = orientation
    }
    
    override init() {
    }
}
