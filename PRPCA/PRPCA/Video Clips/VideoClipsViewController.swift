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

class VideoClipsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    /* Button Actions */
    
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
    
    // Load Camera Roll.
    @IBAction func loadCameraRoll(_ sender: UIButton) {
    }
    
    /* Variables */
    
    // Model instance.
    public var videoClipsModel:VideoClipsModelController = VideoClipsModelController()
    
    // UIScrollView Outlet.
    @IBOutlet weak var videoClipsTableView: UITableView!
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        videoClipsTableView.dataSource = self
        videoClipsTableView.delegate = self
    }
    
    
    /* UIImage Picker Delegate Functions */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Video Title variable.
        var videoTitle:String = ""
        
        //Checking to see if the video was taken and has a url.
        var videoURLToSave:URL? = nil
        if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            //Saving the video URL for storing and later playback.
            videoURLToSave = videoURL
        }
        // Creating and storing the new video clip.
        
        // Getting the duration of video.
        let sourceAsset = AVURLAsset(url: videoURLToSave!)
        let duration:Double = sourceAsset.duration.seconds
        
        // Getting the orientation of the video.
        var orientation = "Portrait"
        
        // Getting the date of the video.
        let date = sourceAsset.creationDate?.dateValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let formattedDate = dateFormatter.string(from: date!)
        
        // Getting the thumbnail of the video.
        let thumbnailGenerator = AVAssetImageGenerator(asset: AVAsset(url: videoURLToSave!))
        let frameTimeStart = 3
        let frameLocaion = 1
        var thumbnail:UIImage = #imageLiteral(resourceName: "Default")
        do {
            // Checking to see if the frame is valid. If not, the thumbnail
            // stays on the default image.
            // For getting the correct orientation.
            thumbnailGenerator.appliesPreferredTrackTransform = true
            let frameRef = try thumbnailGenerator.copyCGImage(at: CMTimeMake(Int64(frameTimeStart),
                                                                             Int32(frameLocaion)), actualTime: nil)
            // Determining what the orientation of the video is based on the
            // orientation of the thumbnail that was taken.
            if !isPortrait(width: frameRef.width, height: frameRef.height) {
                orientation = "Landscape"
            }
            // Getting the initial uiimage.
            thumbnail = UIImage(cgImage: frameRef)
            thumbnail = imageWithImage(image: thumbnail, newSize: CGSize(width: 502, height: 334))
        } catch {
            print("Frame cannot be captured.")
        }
        
        // Creating the alert for the user to enter a unique video title for the
        // video clip.
        let alert = UIAlertController(title: "PRPCA",
                                      message: "Enter Video Title",
                                      preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.text = "Title"
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {[weak alert] (_) in
            // Getting the unique video title from the user and using it to
            // create the new video clip.
            
            //Somehow check if the title already exists and if it doesn't, keep prompting the user to enter a new unique video title.
            
            videoTitle = (alert?.textFields![0].text)!
            // Adding the new video clip.
            self.videoClipsModel.addNewVideoClip(title: videoTitle, dateCreated: formattedDate, duration: duration, videoURL: videoURLToSave!, thumbnail: thumbnail, orientation: orientation)
            // Refreshing the table view to load the data that has just been added.
            self.videoClipsTableView.reloadData()
        }))
        
        // Waiting until the image picker view controller is dismissed before
        // presenting the alert view.
        dismiss(animated: true, completion: {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    /* UITableView Delegate Functions */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoClipsModel.videoClips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = videoClipsTableView.dequeueReusableCell(withIdentifier: "cell") as! VideoClipCell
        // This sets the arrow thingy on the right edge of the tableviewcell.
        //cell.accessoryType = .disclosureIndicator
        let videoClip = videoClipsModel.videoClips[indexPath.row] as VideoClip
        cell.videoTitle.text = videoClip.videoClipMetaData.title
        cell.recordedDate.text = "Use Converter" //videoClip.videoClipMetaData.dateCreated
        cell.videoLengthTime.text = convertIntToStringHoursMinutesAndSeconds(seconds: videoClip.videoClipMetaData.duration)
        cell.thumbnail.image = videoClip.thumbnail
        return cell
    }
    
    var videoClipToPassIndex:Int = 0
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do something for the specific cell that was clicked.
        if let index = tableView.indexPathForSelectedRow {
            // Deselects the selected cell after it is clicked by the user.
            tableView.deselectRow(at: index, animated: true)
            // Storing the index of the video clip data to pass in the prepare(...).
            videoClipToPassIndex = indexPath.row
            // Starting the segue with given identifier.
            performSegue(withIdentifier: "videoClipDetailsSegue", sender: self)
        }
    }
    
    // Allows deleting cells by the user.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            videoClipsModel.deleteVideoClipAt(index: indexPath.row)
            videoClipsTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    // Sets the height value to the cell height.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = videoClipsTableView.dequeueReusableCell(withIdentifier: "cell") as! VideoClipCell
        return cell.frame.height
    }
    
    /* Segue */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoClipDetailsSegue" {
            let destinationVC:VideoClipDetails = (segue.destination as? VideoClipDetails)!
            // Passing over the data.
            destinationVC.videoClip = videoClipsModel.videoClips[videoClipToPassIndex]
        }
    }
    
    /* Helper Functions */
    
    // Video Playback with given URL.
    func playVideo(videoLocalURL: URL) {
        let player = AVPlayerViewController()
        player.player = AVPlayer(url: videoLocalURL as URL)
        self.present(player, animated: true, completion: nil)
    }
    
    // Determining if the image is portrait or landscape.
    private func isPortrait(width: Int, height: Int) -> Bool {
        //If the width is greater than height, then it's a landscape.
        if (width > height) {
            return false
        }
        return true
    }
    
    // Resizes the passed in image.
    private func imageWithImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


