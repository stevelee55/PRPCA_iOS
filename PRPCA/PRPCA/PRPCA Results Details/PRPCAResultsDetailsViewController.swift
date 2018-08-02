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
    
    @IBAction func exportOG(_ sender: UIButton) {
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetCreationRequest.forAsset().addResource(with: .photo, data: Data(result.OG_gif, options: nil)
//        })
    }
    @IBAction func exportRPCAImage(_ sender: UIButton) {
    }
    @IBAction func exportL(_ sender: UIButton) {
    }
    @IBAction func exportS(_ sender: UIButton) {
    }
    @IBAction func exportL_RPCA(_ sender: UIButton) {
    }
    @IBAction func exportS_RPCA(_ sender: UIButton) {
    }
    
    
    
    override func viewDidLoad() {
        OG.image = result.OG_gif
        RPCA_Image.image = result.RPCA_Image
        L.image = result.L_gif
        S.image = result.S_gif
        L_RPCA.image = result.L_RPCA_gif
        S_RPCA.image = result.S_RPCA_gif
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
