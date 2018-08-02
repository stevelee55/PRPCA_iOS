//
//  VideoClipsModelController.swift
//  PRPCA
//
//  Created by Steve Lee on 8/1/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import UIKit

class VideoClipsModelController: NSObject {
    
    // Array of Video Clips.
    public var videoClips:[VideoClip]
    
    // Constructor.
    override init() {
        videoClips = []
        super.init()
        loadSavedVideoClips()
    }
    
    // Methods.
    
    // Returns true if there is any saved data that can be retrieved.
    // By default returns false.
    private func loadSavedVideoClips() {
        // Checking to see if any data is present in the system.
        if let data = UserDefaults().object(forKey: "SavedVideoClips") as? Data {
            // Unarchieving it.
            let retrievedVideoClipsData = NSKeyedUnarchiver.unarchiveObject(with: data) as! [VideoClip]
            videoClips = retrievedVideoClipsData
        } else {
            print("Error: VideoClips data cannot be retrieved. Could be because data doesn't exist.")
        }
    }
    
    private func saveCurrentVideoClipsData() {
        // Store the current data that is present in the object and save them to
        // the app directory.
        
        // Archieving into a Data type.
        let data = NSKeyedArchiver.archivedData(withRootObject: videoClips)
        // Storing archieved data at the given key.
        let defaults = UserDefaults()
        defaults.set(data, forKey: "SavedVideoClips")
        defaults.synchronize()
    }
    
    public func deleteVideoClipAt(index:Int) {
        videoClips.remove(at: index)
        // Permanantly saving and updating the data.
        saveCurrentVideoClipsData()
        loadSavedVideoClips()
    }
    
    public func addNewVideoClip(title:String, dateCreated:String, duration:Double,
                                videoURL:URL, thumbnail:UIImage, orientation:String) {
        let clip = VideoClip(title: title, dateCreated: dateCreated,
                             duration: duration, videoClipURL: videoURL, thumbnail: thumbnail, orientation: orientation)
        videoClips.append(clip)
        // Permanantly saving and updating the data.
        saveCurrentVideoClipsData()
        loadSavedVideoClips()
    }
    
}
