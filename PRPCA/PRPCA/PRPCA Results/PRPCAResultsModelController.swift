//
//  PRPCAResultsModelController.swift
//  PRPCA
//
//  Created by Steve Lee on 8/1/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import UIKit

class PRPCAResultsModelController: NSObject {
    
    public var PRPCAResults:[PRPCAResult]
    private let api:MobileBackendAPI = MobileBackendAPI()
    
    // Constructor.
    override init() {
        PRPCAResults = [PRPCAResult]()
        super.init()
        loadSavedPRPCAResults()
    }
    
    // Returns true if there is any saved data that can be retrieved.
    // By default returns false.
    private func loadSavedPRPCAResults() {
        // Checking to see if any data is present in the system.
        if let data = UserDefaults().object(forKey: "SavedPRPCAResults") as? Data {
            // Unarchieving it.
            let retrievedPRPCAResultsData = NSKeyedUnarchiver.unarchiveObject(with: data) as! [PRPCAResult]
            PRPCAResults = retrievedPRPCAResultsData
        } else {
            print("Error: PRPCAResults data cannot be retrieved. Could be because data doesn't exist.")
        }
    }
    
    private func saveCurrentPRPCAResultsData() {
        // Store the current data that is present in the object and save them to
        // the app directory.
        
        // Archieving into a Data type.
        let data = NSKeyedArchiver.archivedData(withRootObject: PRPCAResults);
        // Storing archieved data at the given key.
        let defaults = UserDefaults()
        defaults.set(data, forKey: "SavedPRPCAResults")
        defaults.synchronize()
    }
    
    public func deleteVideoClipAt(index:Int) {
        PRPCAResults.remove(at: index)
        // Permanantly saving and updating the data.
        saveCurrentPRPCAResultsData()
        loadSavedPRPCAResults()
    }
    
    public func addNewPRPCAResult(title:String, createdDate:String, OG:UIImage,
                                  L_RPCA:UIImage, S_RPCA:UIImage, L:UIImage,
                                  S:UIImage, RPCA_Image:UIImage) {
        
        let prpcaResult = PRPCAResult(title: title, createdDate: createdDate,
                                      OG: OG, L_RPCA: L_RPCA, S_RPCA: S_RPCA,
                                      L: L, S: S, RPCA_Image: RPCA_Image)
        PRPCAResults.append(prpcaResult)
        // Permanantly saving and updating the data.
        saveCurrentPRPCAResultsData()
        loadSavedPRPCAResults()
    }
    
    var resultComponents:[String: UIImage] = [:]
    public func downloadFromS3(vc:PRPCAResultsViewController){
        let dummyProgBar:UIProgressView = UIProgressView()
        api.downloadData(progressBar: dummyProgBar, vc:vc, mc: self, key: "OG.gif")
        api.downloadData(progressBar: dummyProgBar, vc:vc, mc: self, key: "L_RPCA.gif")
        api.downloadData(progressBar: dummyProgBar, vc:vc, mc: self, key: "S_RPCA.gif")
        api.downloadData(progressBar: dummyProgBar, vc:vc, mc: self, key: "L.gif")
        api.downloadData(progressBar: dummyProgBar, vc:vc, mc: self, key: "S.gif")
        api.downloadData(progressBar: dummyProgBar, vc:vc, mc: self, key: "RPCA_Image.jpg")
    }
}


//// Helper Functions.
//private func getDocumentsDirectory() -> URL {
//    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//    return paths[0]
//}
//
//// Returns False when failed to save the uiimage or convert the uiimage to data.
//private func writeUIImage(uiimage:UIImage, title:String, resultType:String) -> URL {
//    let path = getDocumentsDirectory().appendingPathComponent("\(title)_\(resultType)")
//    do {
//        // uiimage can either be .gif or .jpg .
//        let data = NSKeyedArchiver.archivedData(withRootObject: uiimage)
//        try data.write(to: path)
//        return path
//    } catch {
//        print("Error: Data cannot be saved.")
//    }
//    return URL(fileURLWithPath: "n/a")
//}
