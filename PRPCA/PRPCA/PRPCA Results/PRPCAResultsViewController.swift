//
//  PRPCAResultsViewController.swift
//  PRPCA
//
//  Created by Steve Lee on 8/1/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import UIKit

class PRPCAResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Model instance.
    public var prpcaResultsModel:PRPCAResultsModelController = PRPCAResultsModelController()
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }
    
    // Used to check if there is any results present in the S3 bucket.
    @IBAction func reloadButton(_ sender: UIButton) {
        prpcaResultsModel.downloadFromS3(vc: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do something for the specific cell that was clicked.
        if let index = tableView.indexPathForSelectedRow {
            // Deselects the selected cell after it is clicked by the user.
            tableView.deselectRow(at: index, animated: true)
            // Storing the index of the video clip data to pass in the prepare(...).
            resultsToPassIndex = indexPath.row
            // Starting the segue with given identifier.
            performSegue(withIdentifier: "resultsDetailsSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ResultsCell = resultsTableView.dequeueReusableCell(withIdentifier: "resultsCell") as! ResultsCell
        cell.ogVideoClipGif.image = prpcaResultsModel.PRPCAResults[indexPath.row].L_gif
        cell.resultsTitle.text = prpcaResultsModel.PRPCAResults[indexPath.row].metaData.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prpcaResultsModel.PRPCAResults.count
    }
    
    var resultsToPassIndex:Int = 0
    
    // Allows deleting cells by the user.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            prpcaResultsModel.deleteVideoClipAt(index: indexPath.row)
            resultsTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultsDetailsSegue" {
            let destinationVC:PRPCAResultsDetailsViewController = (segue.destination as? PRPCAResultsDetailsViewController)!
            // Passing over the data.
            destinationVC.result = prpcaResultsModel.PRPCAResults[resultsToPassIndex]
        }
    }
}
