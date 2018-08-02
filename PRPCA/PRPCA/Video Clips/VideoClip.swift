//
//  VideoClip.swift
//  PRPCA
//
//  Created by Steve Lee on 8/1/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation

// Video Clip Class.
class VideoClip: NSObject, NSCoding {
    
    // Constructor.
    init(title:String, dateCreated:String, duration:Double, videoClipURL:URL,
         thumbnailURL:URL, orientation:String) {
        self.videoClipURL = videoClipURL
        self.thumbnailURL = thumbnailURL
        self.videoClipMetaData = VideoClipMetaData(title: title,
                                                   dateCreated: dateCreated,
                                                   duration: duration, orientation: orientation)
    }
    // Member Variables.
    var videoClipURL:URL = URL(fileURLWithPath: "")
    var thumbnailURL:URL = URL(fileURLWithPath: "")
    var videoClipMetaData:VideoClipMetaData = VideoClipMetaData()
    
    // Encoder.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.videoClipURL, forKey: "videoClipURL")
        aCoder.encode(self.thumbnailURL, forKey: "thumbnailURL")
        aCoder.encode(self.videoClipMetaData, forKey: "videoClipMetaData")
    }
    // Decoder.
    required init?(coder aDecoder: NSCoder) {
        self.videoClipURL = (aDecoder.decodeObject(forKey: "videoClipURL") as? URL)!
        self.thumbnailURL = (aDecoder.decodeObject(forKey: "thumbnailURL") as? URL)!
        self.videoClipMetaData = (aDecoder.decodeObject(forKey: "videoClipMetaData") as? VideoClipMetaData)!
    }
}
