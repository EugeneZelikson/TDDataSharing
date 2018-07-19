//
//  ViewController.swift
//  TDDataSharingReceiver
//
//  Created by TopDevs on 6/7/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var content: [Any?]? {
        didSet {
            if let tableView = tableView {
                tableView.reloadData()
            }
        }
    }
    
    let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.timeStyle = .short
        formatter.dateStyle = .medium

        return formatter
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let object = content![indexPath.row] else {
            return cellConfig(tableView: tableView, indexPath: indexPath, object: "the object has lost.")
        }
        return cellConfig(tableView: tableView, indexPath: indexPath, object: object)
    }
 
    func cellConfig(tableView: UITableView, indexPath: IndexPath, object: Any) -> UITableViewCell {
        var anycell: UITableViewCell? = nil

        if object is UIImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCell
            
            cell.anyImageView.image = (object as! UIImage)
            
            anycell = cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TextCell
            
            var text = ""
            
            if object is Date {
                text = dateFormater.string(from: object as! Date)
            } else if object is String {
                text = object as! String
            }
            cell.anyTextLabel.text = text
            anycell = cell
        }
        
        return anycell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

class TextCell: UITableViewCell {
    
    @IBOutlet weak var anyTextLabel: UILabel!
    
}

class ImageCell: UITableViewCell {
    
    @IBOutlet weak var anyImageView: UIImageView!
    
}
