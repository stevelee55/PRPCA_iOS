//
//  PRPCAResultsMetaData.swift
//  PRPCA
//
//  Created by Steve Lee on 8/2/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import UIKit

// PRPCA Result MetaData Struct.
class PRPCAResultMetaData: NSObject, NSCoding {
    init(title:String, createdDate:String) {
        self.title = title
        //self.createdDate = createdDate
    }
    var title:String = ""
    //var createdDate:String
    
    // Encoder.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
    }
    // Decoder.
    required init?(coder aDecoder: NSCoder) {
        self.title = (aDecoder.decodeObject(forKey: "title") as? String)!
    }
    override init() {
    }
}
