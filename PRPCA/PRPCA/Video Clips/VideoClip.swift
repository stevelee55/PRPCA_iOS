//
//  VideoClip.swift
//  PRPCA
//
//  Created by Steve Lee on 8/1/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import UIKit

// Video Clip Class.
class VideoClip: NSObject, NSCoding {
    
    // Constructor.
    init(title:String, dateCreated:String, duration:Double, videoClipURL:URL,
         thumbnail:UIImage, orientation:String) {
        self.videoClipURL = videoClipURL
        self.thumbnail = thumbnail
        self.videoClipMetaData = VideoClipMetaData(title: title,
                                                   dateCreated: dateCreated,
                                                   duration: duration, orientation: orientation)
    }
    // Member Variables.
    var videoClipURL:URL = URL(fileURLWithPath: "")
    var thumbnail:UIImage = #imageLiteral(resourceName: "Default")
    var videoClipMetaData:VideoClipMetaData = VideoClipMetaData()
    
    // Encoder.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.videoClipURL, forKey: "videoClipURL")
        aCoder.encode(self.thumbnail, forKey: "thumbnail")
        aCoder.encode(self.videoClipMetaData, forKey: "videoClipMetaData")
    }
    // Decoder.
    required init?(coder aDecoder: NSCoder) {
        self.videoClipURL = (aDecoder.decodeObject(forKey: "videoClipURL") as? URL)!
        self.thumbnail = (aDecoder.decodeObject(forKey: "thumbnail") as? UIImage)!
        self.videoClipMetaData = (aDecoder.decodeObject(forKey: "videoClipMetaData") as? VideoClipMetaData)!
    }
    
    override init() {
    }
}
