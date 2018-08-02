//
//  VideoClipCell.swift
//  PRPCA
//
//  Created by Steve Lee on 5/22/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import UIKit

class VideoClipCell: UITableViewCell {
    
    @IBOutlet weak var orientationIndicator: UIImageView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var recordedDate: UILabel!
    @IBOutlet weak var videoLengthTime: UILabel!
}
