//
//  ViewController.swift
//  PRPCA
//
//  Created by Steve Lee on 8/1/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        testImageView.loadGif(name: "test")
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

