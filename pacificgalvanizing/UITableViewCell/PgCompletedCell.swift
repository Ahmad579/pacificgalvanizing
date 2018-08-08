//
//  PgCompletedCell.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 25/06/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

protocol EditNoteDelegate {
    func editNotesProduction( checkCell : PgCompletedCell , indexPath : IndexPath)
    func readyToShip( checkCell : PgCompletedCell , indexPath : IndexPath)
    func showImages( checkCell : PgCompletedCell , indexPath : IndexPath)
    func showPop( checkCell : PgCompletedCell , indexPath : IndexPath)

}

class PgCompletedCell: UITableViewCell {

    @IBOutlet weak var lblOrderNum: UILabel!
    
    @IBOutlet weak var lblWorkDaysLeft: UILabel!
    
    @IBOutlet weak var lblArrivedDate: UILabel!
    
    @IBOutlet weak var lblShipDate: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    var delegate: EditNoteDelegate?
    var index: IndexPath?
//    @IBOutlet weak var collectionViewCell: UICollectionView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnEditProduction_Pressed(_ sender: UIButton) {
        self.delegate?.editNotesProduction(checkCell: self, indexPath: index!)
    }
    
    @IBAction func btnReadyToShipment(_ sender: UIButton) {
        self.delegate?.readyToShip(checkCell: self, indexPath: index!)
    }
    
    @IBAction func btnShowImage_Pressed(_ sender: UIButton) {
        self.delegate?.showImages(checkCell: self, indexPath: index!)
    }
    
    @IBAction func btnShowPop_Pressed(_ sender: UIButton) {
        self.delegate?.showPop(checkCell: self, indexPath: index!)
    }
    
}
/*
extension PgCompletedCell : UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.completeJob?.listOfOrderImage!.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PGActiveOrderCollectionCell", for: indexPath) as! PGActiveOrderCollectionCell
        let imageUrl = self.completeJob?.listOfOrderImage![indexPath.row].file
        WAShareHelper.loadImage(urlstring: (imageUrl!) , imageView: cell.imgOrOrder, placeHolder: "image_placeholder")
//        let cgFloat: CGFloat = cell.imgOrOrder.frame.size.width/2.0
//        let someFloat = Float(cgFloat)
//        WAShareHelper.setViewCornerRadius(cell.imgOrOrder, radius: CGFloat(someFloat))

        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOfCell = self.collectionViewCell.frame.size.width/4
        //        let heightOfCell = self.collectionViewCell.frame.size.height/6
        
        return CGSize(width: sizeOfCell, height: 40.0)
    }
    
  
    
}
*/
