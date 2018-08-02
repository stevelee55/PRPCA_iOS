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
        // Save thumbnail in the directory and get the url.
        let thumbnailURL:URL = writeUIImage(uiimage: thumbnail, title: title, type: "thumbnail")
        let clip = VideoClip(title: title, dateCreated: dateCreated,
                             duration: duration, videoClipURL: videoURL, thumbnailURL: thumbnailURL, orientation: orientation)
        videoClips.append(clip)
        // Permanantly saving and updating the data.
        saveCurrentVideoClipsData()
        loadSavedVideoClips()
    }
    
}

// Helper Functions.

private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

// Returns False when failed to save the uiimage or convert the uiimage to data.
private func writeUIImage(uiimage:UIImage, title:String, type:String) -> URL {
    let path = getDocumentsDirectory().appendingPathComponent("\(title)_\(type)")
    do {
        // uiimage can either be .gif or .jpg .
        let data = NSKeyedArchiver.archivedData(withRootObject: uiimage)
        try data.write(to: path)
        return path
    } catch {
        print("Error: Data cannot be saved.")
    }
    return URL(fileURLWithPath: "n/a")
}
