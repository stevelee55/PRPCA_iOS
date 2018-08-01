//
//  VideoClipsViewController.swift
//  PRPCA
//
//  Created by Steve Lee on 8/1/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVKit

class VideoClipsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Load Camera.
    @IBAction func loadCamera(_ sender: UIButton) {
        // Create Image Picker instance.
        let picker:UIImagePickerController = UIImagePickerController()
        // Checking to see if the camera is available.
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            //Setting camera settings.
            picker.videoQuality = .typeHigh
            let mediaTypesArray:[String] = [kUTTypeMovie as String]
            picker.mediaTypes = mediaTypesArray
            picker.delegate = self
            picker.modalPresentationStyle = .currentContext
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        } else {
            //This part may not be needed if the camera automatically puts up
            //the "Camera not available message"
            let alert = UIAlertController(title: "PRPCA",
                                          message: "Camera not available",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    var globalURL:URL = URL(fileURLWithPath: "")
    
    // Load Camera Roll.
    @IBAction func loadCameraRoll(_ sender: UIButton) {
        playVideo(videoLocalURL: globalURL)
    }
    
    // UIImage Picker Delegate Functions.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Checking to see if the video was taken and has a url.
        var videoURLToSave:URL? = nil
        if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            //Saving the video URL for storing and later playback.
            videoURLToSave = videoURL
        }
        //Doing something when the image picker view is dismissed.
        dismiss(animated: true, completion: {
            // Saving the video URL.
            self.globalURL = videoURLToSave!
            //Creating the alert for the user to tell them that the video has been
            //saved.
            let alert = UIAlertController(title: "PRPCA",
                                          message: "Video Saved!",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    // Helper Functions.
    // Video Playback with given URL.
    func playVideo(videoLocalURL: URL) {
        let player = AVPlayerViewController()
        player.player = AVPlayer(url: videoLocalURL as URL)
        self.present(player, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


