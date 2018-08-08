//
//  PGShowImageVC.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 24/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class PGShowImageVC: UIViewController {
    var completeJob: CompletedJob?
    @IBOutlet var tblView: UITableView!
    var isCompleteOrActive : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        tblView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCross_Pressed(_ sender: UIButton) {
        dismiss(animated: true) {
            
        }
    }


}

extension PGShowImageVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if  completeJob?.listOfOrderImage?.isEmpty == false {
            numOfSections = 1
            tblView.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblView.bounds.size.width, height: tblView.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = "There are currently no Attachment."
            noDataLabel.textColor = UIColor(red: 119.0 / 255.0, green: 119.0 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)
            noDataLabel.textAlignment = .center
            tblView.backgroundView = noDataLabel
            tblView.separatorStyle = .none
        }
        return numOfSections
//        if  isCompleteOrActive == false {
//
//        } else {
//            if  completeJob?.listOfOrderImage?.isEmpty == false {
//                numOfSections = 1
//                tblView.backgroundView = nil
//            }
//            else {
//                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblView.bounds.size.width, height: tblView.bounds.size.height))
//                noDataLabel.numberOfLines = 10
//                if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
//                    noDataLabel.font = aSize
//                }
//                noDataLabel.text = "There are currently no Attachment."
//                noDataLabel.textColor = UIColor(red: 119.0 / 255.0, green: 119.0 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)
//                noDataLabel.textAlignment = .center
//                tblView.backgroundView = noDataLabel
//                tblView.separatorStyle = .none
//            }
//            return numOfSections
//        }
        
       
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (completeJob?.listOfOrderImage?.count)!
//         if  isCompleteOrActive == false {
//            return (completeJob?.listOfOrderImage?.count)!
//
//         } else {
//            return (completeJob?.listOfOrderImage?.count)!
//
//        }
    }
        
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ImageCell? = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell?
        if cell == nil {
            cell = ImageCell(style: .default, reuseIdentifier: "ImageCell")
        }
        
          let imageUrl = self.completeJob?.listOfOrderImage![indexPath.row].file
          WAShareHelper.loadImage(urlstring: (imageUrl!) , imageView: (cell?.imgOfAttachImage)!, placeHolder: "image_placeholder")

//        if  isCompleteOrActive == false {
//            let imageUrl = self.completeJob?.listOfOrderImage![indexPath.row].file
//            WAShareHelper.loadImage(urlstring: (imageUrl!) , imageView: (cell?.imgOfAttachImage)!, placeHolder: "image_placeholder")
//
//        }else {
//
//            let imgeUrl = self.completeJob?.listOfCompleteImage![indexPath.row].file
//
//
//            WAShareHelper.loadImage(urlstring: (imgeUrl)! , imageView: (cell?.imgOfAttachImage)!, placeHolder: "image_placeholder")
//
//        }
        

        return cell!
        
        
        
        
    }
    
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 217.0
    }
    
}
