//
//  PRPCAResultsViewController.swift
//  PRPCA
//
//  Created by Steve Lee on 8/1/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import UIKit

class PRPCAResultsViewController: UIViewController {
    
    // Model instance.
    public var prpcaResultsModel:PRPCAResultsModelController = PRPCAResultsModelController()
    
    @IBOutlet weak var test: UIImageView!
    
    
    // Used to check if there is any results present in the S3 bucket.
    @IBAction func reloadButton(_ sender: UIButton) {
        prpcaResultsModel.downloadFromS3(vc: self)
    }
}
