//
//  PRPCAResultsDetails.swift
//  PRPCA
//
//  Created by Steve Lee on 8/2/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import UIKit
import Foundation
import Photos
class PRPCAResultsDetailsViewController:UIViewController {
    
    var result:PRPCAResult = PRPCAResult()
    
    @IBOutlet weak var OG: UIImageView!
    @IBOutlet weak var RPCA_Image: UIImageView!
    @IBOutlet weak var L: UIImageView!
    @IBOutlet weak var S: UIImageView!
    @IBOutlet weak var L_RPCA: UIImageView!
    @IBOutlet weak var S_RPCA: UIImageView!
    @IBOutlet weak var L_Stylized: UIImageView!
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func saveToPhotoAlbum(image:UIImage) {
        //UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        let ac = UIAlertController(title: "Error", message: "Exporting not available yet.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func exportOG(_ sender: UIButton) {
        saveToPhotoAlbum(image: self.OG.image!)
    }
    
    @IBAction func exportRPCAImage(_ sender: UIButton) {
        saveToPhotoAlbum(image: self.RPCA_Image.image!)
    }
    @IBAction func exportL(_ sender: UIButton) {
        saveToPhotoAlbum(image: self.L.image!)
    }
    @IBAction func exportS(_ sender: UIButton) {
       saveToPhotoAlbum(image: self.S.image!)
    }
    @IBAction func exportL_RPCA(_ sender: UIButton) {
        saveToPhotoAlbum(image: self.L_RPCA.image!)
    }
    @IBAction func exportS_RPCA(_ sender: UIButton) {
        saveToPhotoAlbum(image: self.S_RPCA.image!)
    }
    @IBAction func exportL_Stylized(_ sender: UIButton) {
        saveToPhotoAlbum(image: self.L_Stylized.image!)
    }
    
    
    
    override func viewDidLoad() {
        self.OG.image = result.OG_gif
        self.RPCA_Image.image = result.RPCA_Image
        self.L.image = result.L_gif
        self.S.image = result.S_gif
        self.L_RPCA.image = result.L_RPCA_gif
        self.S_RPCA.image = result.S_RPCA_gif
        self.L_Stylized.image = result.L_Stylized
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
