//
//  PGOrderPopVC.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 27/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class PGOrderPopVC: UIViewController {

    @IBOutlet weak var lblShipmentDate: UILabel!
    @IBOutlet weak var lblArrivedDate: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblWorkDayLeft: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblNoteProduction: UILabel!
    @IBOutlet weak var lblNoteShipping: UILabel!
    var completeJob: CompletedJob?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblShipmentDate.text = completeJob?.shipment_date
        lblArrivedDate.text = completeJob?.arrived_date
        lblCustomerName.text = completeJob?.customer
        lblOrderNo.text = completeJob?.order_no
        lblDescription.text = completeJob?.descriptionOfOrder
        lblNoteProduction.text = completeJob?.notes_production
        lblNoteShipping.text = completeJob?.notes_shipping
        
        
        let workingDay = completeJob?.work_days
        
        if workingDay == 1 {
            lblWorkDayLeft.textColor = UIColor.red
            
            lblWorkDayLeft.text = "\(workingDay!) days"
        } else if (workingDay)! > 1 && workingDay! < 6 {
            lblWorkDayLeft.textColor = UIColor.yellow
            lblWorkDayLeft.text = "\(workingDay!) days"
        }
        else if (workingDay)! >= 6 {
           lblWorkDayLeft.textColor = UIColor.green
            lblWorkDayLeft.text = "\(workingDay!) days"
            
        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
