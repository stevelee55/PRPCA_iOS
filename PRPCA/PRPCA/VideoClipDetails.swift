//
//  VideoClipDetails.swift
//  
//
//  Created by Steve Lee on 8/2/18.
//

import Foundation
import UIKit
import AVKit

class VideoClipDetails: UIViewController {
    
    @IBOutlet weak var progressBarTemp: UIProgressView!
    @IBOutlet weak var thumbnail: UIImageView!
    public var videoClip:VideoClip = VideoClip()
    @IBOutlet weak var metaDataLabel: UILabel!
    let api:MobileBackendAPI = MobileBackendAPI()
    
    override func viewDidLoad() {
        thumbnail.image = videoClip.thumbnail
        presentMetaData(metaData: videoClip.videoClipMetaData)
    }
    @IBAction func uploadToAWSButton(_ sender: UIButton) {
        //Getting the frame as an image from the video url.
        var data: Data = Data()
        do {
            data = try Data(contentsOf: videoClip.videoClipURL)
            
        } catch {
            
        }
        if !api.uploadData(progressBar: progressBarTemp, dataToUpload: data) {
            // Upload failed ui alert for the user.
        }
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Helper Functions.
    private func presentMetaData(metaData:VideoClipMetaData) {
        let metaDataInFullText:String = "Title: \(metaData.title)\n Date Created: \(metaData.dateCreated)\n Duration: \(convertIntToStringHoursMinutesAndSeconds(seconds: metaData.duration))\n Video Orientation: \(metaData.orientation)"
        metaDataLabel.text = metaDataInFullText
    }
    
    // This is for converting seconds to hr:min:seconds format.
    private func convertIntToStringHoursMinutesAndSeconds (seconds : Double) -> String {
        let duration: TimeInterval = seconds
        //Calculating hours, minutes, and seconds from the passed in seconds.
        let s: Int = Int(duration) % 60
        let m: Int = Int(duration) / 60
        let h: Int = Int(duration) / 3600
        //Formatting it. Still not sure how this works; string's function probs?
        let formattedDuration = String(format: "%02d:%02d:%02d", h, m, s)
        return formattedDuration
    }
}

/* Helper Function */
// Video Playback with given URL.
func playVideo(videoLocalURL: URL) {
    let player = AVPlayerViewController()
    player.player = AVPlayer(url: videoLocalURL as URL)
    self.present(player, animated: true, completion: nil)
}

