//
//  VideoClipsModelController.swift
//  PRPCA
//
//  Created by Steve Lee on 8/1/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import UIKit

class VideoClipsModel: NSObject {
    
    // Video Clip Metadata Struct.
    public struct VideoClipMetaData {
        // Constructor.
        init(title:String, dateCreated:NSDate, duration:Double) {
            self.title = title
            self.dateCreated = dateCreated
            self.duration = duration
        }
        // Member Variables.
        var title:String
        var dateCreated:NSDate
        var duration:Double
    }
    
    // Video Clip Struct.
    public struct VideoClip {
        // Constructor.
        init(title:String,
             dateCreated:NSDate,
             duration:Double,
             videoClipURL:URL,
             thumbnailURL:URL) {
            self.videoClipURL = videoClipURL
            self.thumbnailURL = thumbnailURL
            self.videoClipMetaData = VideoClipMetaData(title: title,
                                                       dateCreated: dateCreated,
                                                       duration: duration)
        }
        // Member Variables.
        var videoClipURL:URL
        var thumbnailURL:URL
        var videoClipMetaData:VideoClipMetaData
    }
    
    // Array of Video Clips.
    public var videoClips:[VideoClip]
    
    // Constructor.
    override init() {
        videoClips = [VideoClip]()
    }
    
    // Methods.
    
    // Returns true if there is any saved data that can be retrieved.
    // By default returns false.
    public func loadSavedVideoClips() -> Bool {
        // Checking to see if any data is present in the system.
        if let data = UserDefaults().object(forKey: "VSP_Data_VideosMetaData") as? Data {
            // Unarchieving it.
            let retrievedVideoClipsData = NSKeyedUnarchiver.unarchiveObject(with: data) as! [VideoClip]
            videoClips = retrievedVideoClipsData
            return true
        }
        return false
    }
    
    public func saveCurrentVideoClipsData() {
        // Store the current data that is present in the object and save them to
        // the app directory.
        
        // Archieving into a Data type.
        let data = NSKeyedArchiver.archivedData(withRootObject: videoClips);
        // Storing archieved data at the given key.
        let defaults = UserDefaults()
        defaults.set(data, forKey: "SavedVideoClips")
        defaults.synchronize()
    }
    
    public func deleteVideoClipAt(index:Int) {
        videoClips.remove(at: index)
        // Permanantly saving the data.
        saveCurrentVideoClipsData()
    }
    
    public func addNewVideoClip(title:String,
                                dateCreated:NSDate,
                                duration:Double,
                                videoURL:URL,
                                thumbnail:UIImage) {
        // Save thumbnail in the directory and get the url.
        let thumbnailURL:URL = URL(fileURLWithPath: "blah")
        let clip = VideoClip(title: title,
                         dateCreated: dateCreated,
                         duration: duration,
                         videoClipURL: videoURL,
                         thumbnailURL: thumbnailURL)
        videoClips.append(clip)
        // Permanantly saving the data.
        saveCurrentVideoClipsData()
    }
    
}
