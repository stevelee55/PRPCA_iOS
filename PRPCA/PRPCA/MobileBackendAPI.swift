//
//  MobileBackendAPI.swift
//  VSP_0
//
//  Created by Steve Lee on 5/30/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import AWSAuthCore
import AWSCore
import AWSAPIGateway
import AWSMobileClient
import Photos

//For checking internect connection.
import SystemConfiguration

//AWS S3
import AWSS3

class MobileBackendAPI {
    
/*Init/reset Functions*/
    func initUploadToAWSProgressBar(uploadToAWSProgressBar: UIProgressView) {
        uploadToAWSProgressBar.isHidden = true
        uploadToAWSProgressBar.progress = Float(0.0)
        uploadToAWSProgressBar.isUserInteractionEnabled = false
    }
    
/*AWSS3*/
    
    //S3 Bucket name.
    let bucketName = "prpca-userfiles-mobilehub-71528230"
    //If success, return true, if fail, return false.
    func uploadData(progressBar: UIProgressView, dataToUpload: Data) -> Bool {
        
        //Running the code if and only if the device is connected to the network.
        if isConnectedToNetwork() {
            //If the connection is available, don't show any alert to the user.
            print("Connected!")
            
            // Making the progressbar visible.
            progressBar.isHidden = false
            progressBar.isUserInteractionEnabled = true
            //Used for the progress bar/loading bar.
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.progressBlock = {(task, progress) in
                DispatchQueue.main.async(execute: {
                    // Do something e.g. Update a progress bar.
                    progressBar.progress = Float(progress.fractionCompleted)
                })
            }
            //Runs whenever the upload is finished.
            var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
            completionHandler = { (task, error) -> Void in
                DispatchQueue.main.async(execute: {
                    // Do something e.g. Alert a user for transfer completion.
                    // On failed uploads, `error` contains the error object.
                    print("Upload Successful")
                    
//Somehow show alert saying that the upload was successful.
//The problem is that I canoot refer to the parent view controller from here.
                    
                    //Resetting the Progressbar
                    self.initUploadToAWSProgressBar(uploadToAWSProgressBar: progressBar)
                })
            }
            //Used for uploading the files.
            let transferUtility = AWSS3TransferUtility.default()
            //Content Type lists: http://www.iana.org/assignments/media-types/media-types.xhtml
            transferUtility.uploadData(dataToUpload,
                                       bucket: bucketName,
                                       key: "uploads/PRPCA_RAW.mov",
                                       contentType: "text/plain",
                                       expression: expression,
                                       completionHandler: completionHandler).continueWith {
                                        (task) -> AnyObject? in
                                        return nil;
            }
            return true
            
        //Device not connected to the network.
        } else {
            //If the device isn't conncted to the network, show an alert saying
            //the device isn't connected.
            print("Not connected!")
            //Resetting the Progressbar
            self.initUploadToAWSProgressBar(uploadToAWSProgressBar: progressBar)
            return false
        }
    }
        
        //Downloading data from s3 bucket.
    func downloadData(progressBar: UIProgressView, vc: PRPCAResultsViewController, mc: PRPCAResultsModelController, key: String) {
            let expression = AWSS3TransferUtilityDownloadExpression()
            expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
                DispatchQueue.main.async(execute: {
                    // Do something e.g. Update a progress bar.
                    progressBar.progress = Float(progress.fractionCompleted)
                })
                print("Downloaded: \(progress)")
            })
            }

            //Use this later.
            var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
            //This runs whenever the downloaddata function is finish getting the data.
            completionHandler = { (task, URL, data, error) -> Void in
                
                if error != nil {
                    //                    print("RIPPPP")
                    //                    print("Error: \(error.localizedDescription)")
                    
                    // Do something with downloadTask.
                    let alert = UIAlertController(title: "PRPCA",
                                                  message: "\(key) not available :(",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    vc.present(alert, animated: true, completion: nil)
                } else {
                    
                }
                
                
                
                DispatchQueue.main.async(execute: {
                    // Do something e.g. Alert a user for transfer completion.
                    // On failed downloads, `error` contains the error object.
    //                let responseString =  String(data:data!, encoding: .utf8)
    //                recievedDataLabel.text = responseString
                    
//                    PHPhotoLibrary.shared().performChanges({
//                        PHAssetCreationRequest.forAsset().addResource(with: .photo, data: downloadedDataToSave, options: nil)
//                    })
                    //vc.test.image = UIImage.gif(data: Data(data!))
                    mc.resultComponents[key] = UIImage.gif(data: Data(data!))
                    if mc.resultComponents.count == 7 {
                        // Do something with downloadTask.
                        let alert = UIAlertController(title: "PRPCA",
                                                      message: "Downloaded all components",
                            preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        vc.present(alert, animated: true, completion: nil)
                        mc.addNewPRPCAResult(title: "meh", createdDate: "datee", OG: mc.resultComponents["OG.gif"]!, L_RPCA: mc.resultComponents["L_RPCA.gif"]!, S_RPCA: mc.resultComponents["S_RPCA.gif"]!, L: mc.resultComponents["L.gif"]!, S: mc.resultComponents["S.gif"]!, RPCA_Image: mc.resultComponents["RPCA_Image.jpg"]!, L_Stylized: mc.resultComponents["L_Stylized.gif"]!)
                        vc.resultsTableView.reloadData()
                        mc.resultComponents.removeAll()
                        // Allowing the user to interact with the view controller
                        // again and get rid of the spinning circle.
                        vc.view.isUserInteractionEnabled = true
                        vc.loadingView.isHidden = true
                        vc.loadingIndicator.isHidden = true
                        vc.loadingIndicator.stopAnimating()
                    }
                    print("Download Successful")
                })
            }
            
            //Later change the permission for the s3 buckets.
            let transferUtility = AWSS3TransferUtility.default()
            //This is for getting the notification when the download is complete.
            transferUtility.downloadData(fromBucket: bucketName, key: "uploads/\(key)", expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
                if task.error != nil {
//                    print("RIPPPP")
//                    print("Error: \(error.localizedDescription)")
                }
                if let _ = task.result {
                }
                return nil
            }
        }

    
    //Checking if the device is connected to the internet.
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

