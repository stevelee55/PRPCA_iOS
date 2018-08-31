//
//  PRPCAResult.swift
//  PRPCA
//
//  Created by Steve Lee on 8/2/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import UIKit

// PRPCA Result Struct.
class PRPCAResult: NSObject, NSCoding {
    // Constructor.
    init(title:String, createdDate:String, OG:UIImage, L_RPCA:UIImage,
         S_RPCA:UIImage, L:UIImage, S:UIImage, RPCA_Image:UIImage, L_Stylized:UIImage) {
        // Title of this PRPCA result.
        self.metaData = PRPCAResultMetaData(title: title, createdDate: createdDate)
        // Saving the uiimages in the file system and saving the resulting urls.
        self.OG_gif = OG
        self.L_RPCA_gif = L_RPCA
        self.S_RPCA_gif = S_RPCA
        self.L_gif = L
        self.S_gif = S
        self.RPCA_Image = RPCA_Image
        self.L_Stylized = L_Stylized
    }
    
    // Member Variables.
    var OG_gif:UIImage = #imageLiteral(resourceName: "Default")
    var L_RPCA_gif:UIImage = #imageLiteral(resourceName: "Default")
    var S_RPCA_gif:UIImage = #imageLiteral(resourceName: "Default")
    var L_gif:UIImage = #imageLiteral(resourceName: "Default")
    var S_gif:UIImage = #imageLiteral(resourceName: "Default")
    var RPCA_Image:UIImage = #imageLiteral(resourceName: "Default")
    var L_Stylized:UIImage = #imageLiteral(resourceName: "Default")
    var metaData:PRPCAResultMetaData = PRPCAResultMetaData(title: "", createdDate: "")
    

    // Encoder.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.OG_gif, forKey: "OG_gif")
        aCoder.encode(self.L_RPCA_gif, forKey: "L_RPCA_gif")
        aCoder.encode(self.S_RPCA_gif, forKey: "S_RPCA_gif")
        aCoder.encode(self.L_gif, forKey: "L_gif")
        aCoder.encode(self.S_gif, forKey: "S_gif")
        aCoder.encode(self.RPCA_Image, forKey: "RPCA_Image")
        aCoder.encode(self.metaData, forKey: "metaData")
        aCoder.encode(self.L_Stylized, forKey: "L_Stylized")
    }
    // Decoder.
    required init?(coder aDecoder: NSCoder) {
        self.OG_gif = (aDecoder.decodeObject(forKey: "OG_gif") as? UIImage)!
        self.L_RPCA_gif = (aDecoder.decodeObject(forKey: "L_RPCA_gif") as? UIImage)!
        self.S_RPCA_gif = (aDecoder.decodeObject(forKey: "S_RPCA_gif") as? UIImage)!
        self.L_gif = (aDecoder.decodeObject(forKey: "L_gif") as? UIImage)!
        self.S_gif = (aDecoder.decodeObject(forKey: "S_gif") as? UIImage)!
        self.RPCA_Image = (aDecoder.decodeObject(forKey: "RPCA_Image") as? UIImage)!
        self.metaData = (aDecoder.decodeObject(forKey: "metaData") as? PRPCAResultMetaData)!
        self.L_Stylized = (aDecoder.decodeObject(forKey: "L_Stylized") as? UIImage)!
    }
    override init() {
    }
}
