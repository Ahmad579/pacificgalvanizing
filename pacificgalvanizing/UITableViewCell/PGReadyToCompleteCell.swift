//
//  PGReadyToCompleteCell.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 18/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

protocol ShowImageDelegate {
    func showImagesInComplete( checkCell : PGReadyToCompleteCell , indexPath : IndexPath)
    
}


class PGReadyToCompleteCell: UITableViewCell {
    
    @IBOutlet weak var lblOrderNum: UILabel!
    
    @IBOutlet weak var lblWorkDaysLeft: UILabel!
    
    @IBOutlet weak var lblArrivedDate: UILabel!
    
    @IBOutlet weak var lblShipDate: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    var delegate: ShowImageDelegate?
    var index: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnShowImage_Pressed(_ sender: UIButton) {
        self.delegate?.showImagesInComplete(checkCell: self, indexPath: index!)
    }
    
}

//extension PGReadyToCompleteCell : UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
//{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return (self.completeJob?.listOfCompleteImage!.count)!
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PGActiveOrderCollectionCell", for: indexPath) as! PGActiveOrderCollectionCell
//        let imageUrl = self.completeJob?.listOfCompleteImage![indexPath.row].file
//        WAShareHelper.loadImage(urlstring: (imageUrl!) , imageView: cell.imgOrOrder, placeHolder: "image_placeholder")
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let sizeOfCell = self.collectionViewCell.frame.size.width/4
//        //        let heightOfCell = self.collectionViewCell.frame.size.height/6
//
//        return CGSize(width: sizeOfCell, height: 40.0)
//    }
//
//
//
//}

