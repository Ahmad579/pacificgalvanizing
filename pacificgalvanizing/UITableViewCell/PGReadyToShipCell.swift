//
//  PGReadyToShipCell.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 18/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

protocol ReadyToShipNoteDelegate {
    func editShipmentNotesProduction( checkCell : PGReadyToShipCell , indexPath : IndexPath)
    func completeOrder( checkCell : PGReadyToShipCell , indexPath : IndexPath)
    func showTheImageDetail( checkCell : PGReadyToShipCell , indexPath : IndexPath)

}
class PGReadyToShipCell: UITableViewCell {

    @IBOutlet weak var lblOrderNum: UILabel!
    
//    @IBOutlet weak var lblWorkDaysLeft: UILabel!
    
    @IBOutlet weak var lblArrivedDate: UILabel!
    
    @IBOutlet weak var lblShipDate: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    var delegate: ReadyToShipNoteDelegate?
    var index: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
  
    @IBAction func btnEditProduction_Pressed(_ sender: UIButton) {
        self.delegate?.editShipmentNotesProduction(checkCell: self, indexPath: index!)
    }
    
    @IBAction func btnReadyToShipment(_ sender: UIButton) {
        self.delegate?.completeOrder(checkCell: self, indexPath: index!)
    }
    
    @IBAction func btnShowImage_Pressed(_ sender: UIButton) {
        self.delegate?.showTheImageDetail(checkCell: self, indexPath: index!)
    }
}
