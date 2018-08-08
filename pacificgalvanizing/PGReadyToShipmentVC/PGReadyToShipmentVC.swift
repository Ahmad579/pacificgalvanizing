//
//  PGReadyToShipmentVC.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 18/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PGReadyToShipmentVC: UIViewController , NVActivityIndicatorViewable , UISearchBarDelegate {
    
    var responseObj: UserResponse?
    @IBOutlet var searchBar: UISearchBar!
    var searchActive : Bool = false
    var filters: [CompletedJob]?
    @IBOutlet var tblView: UITableView!
    let size = CGSize(width: 60, height: 60)
    @IBOutlet var editTextView: UITextView!
    @IBOutlet var viewOfPop: UIView!
    var notesProdiction : String?
    var indexSelect : Int?
    var updateProduction: UserResponse?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib(nibName: "PGReadyToShipCell", bundle: nil), forCellReuseIdentifier: "PGReadyToShipCell")
        self.editTextView.text = notesProdiction
        WAShareHelper.setBorderAndCornerRadius(layer: searchBar.layer, width: 1.0, radius: 5.0, color: UIColor(red: 21/255.0, green: 52/255.0, blue: 101/255.0, alpha: 1.0))

        getCompletedJob()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func getCompletedJob(){
        //        let userId  = localUserData.id
        let idOfUser = UserDefaults.standard.string(forKey: "id")
        
        let loginParam =       [ "userid"         : idOfUser!,
                               ] as [String : Any]
        
        startAnimating(size, message: KMessageValidation, messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: READYTOSHIP, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
            self.responseObj = response as? UserResponse
            self.stopAnimating()
            
            if self.responseObj?.success == true {
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
                
            }else {
                self.showAlert(title: "Pacific", message: (self.responseObj?.message!)!, controller: self)
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
                
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            
        }, showHUD: true)
    }
    
    @IBAction func btnBack_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDone_Pressed(_ sender: UIButton) {
        //        self.viewOfPop.isHidden = true
        
        let orderId  = self.responseObj?.completedJobList![indexSelect!].id
        let loginParam =    [ "id"         : orderId!,
                              "shipment_note" : self.editTextView.text!
            ] as [String : Any]
        
        startAnimating(size, message: KMessageValidation, messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: UPDATEPRODUCTION, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
            self.updateProduction = response as? UserResponse
            self.stopAnimating()
            
            if self.responseObj?.success == true {
                self.showAlertViewWithTitle(title: "Pacific", message: (self.updateProduction?.message!)!, dismissCompletion: {
                    self.getCompletedJob()
                    self.viewOfPop.isHidden = true
                })
                
                
            }else {
                self.showAlert(title: "Pacific", message: (self.updateProduction?.message!)!, controller: self)
                
                
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            
        }, showHUD: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.tblView.reloadData()
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar.showsCancelButton = true
        searchActive = true
        filters = self.responseObj?.completedJobList?.filter { ($0.order_no?.lowercased().contains(searchText.lowercased()))! }
        //        filterSchedule = filters
        self.tblView.reloadData()
        
    }

}

extension PGReadyToShipmentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if searchActive == true {
            if  self.filters?.isEmpty == false {
                numOfSections = 1
                tblView.backgroundView = nil
            }
            else {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblView.bounds.size.width, height: tblView.bounds.size.height))
                noDataLabel.numberOfLines = 10
                if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                    noDataLabel.font = aSize
                }
                noDataLabel.text = "There are currently no  Order."
                noDataLabel.textColor = UIColor(red: 119.0 / 255.0, green: 119.0 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)
                noDataLabel.textAlignment = .center
                tblView.backgroundView = noDataLabel
                tblView.separatorStyle = .none
            }
            return numOfSections
        } else {
            
            
            if  self.responseObj?.completedJobList?.isEmpty == false {
                numOfSections = 1
                tblView.backgroundView = nil
            }
            else {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblView.bounds.size.width, height: tblView.bounds.size.height))
                noDataLabel.numberOfLines = 10
                if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                    noDataLabel.font = aSize
                }
                noDataLabel.text = "There are currently no Active Order."
                noDataLabel.textColor = UIColor(red: 119.0 / 255.0, green: 119.0 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)
                noDataLabel.textAlignment = .center
                tblView.backgroundView = noDataLabel
                tblView.separatorStyle = .none
            }
            return numOfSections
        }
    }
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true  {
            return (filters?.count)!
        } else {
            return (responseObj?.completedJobList?.count)!
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PGReadyToShipCell? = tableView.dequeueReusableCell(withIdentifier: "PGReadyToShipCell") as! PGReadyToShipCell
        if cell == nil {
            cell = PGReadyToShipCell(style: .default, reuseIdentifier: "PGReadyToShipCell")
        }
        
        if searchActive == true  {
            cell?.lblOrderNum.text = self.filters![indexPath.row].order_no
//            let workingDay = self.filters![indexPath.row].work_days
            
//            cell?.lblWorkDaysLeft.text = "\(workingDay!)"
            cell?.lblArrivedDate.text = self.filters![indexPath.row].arrived_date
            cell?.lblShipDate.text = self.filters![indexPath.row].shipment_date
            cell?.lblCustomerName.text = self.filters![indexPath.row].customer
            cell?.lblNotes.text = self.filters![indexPath.row].notes_production
            cell?.delegate = self
            cell?.index = indexPath
            
        } else {
            cell?.lblOrderNum.text = self.responseObj?.completedJobList![indexPath.row].order_no
//            let workingDay = self.responseObj?.completedJobList![indexPath.row].work_days
            
//            cell?.lblWorkDaysLeft.text = "\(workingDay!)"
            cell?.lblArrivedDate.text = self.responseObj?.completedJobList![indexPath.row].arrived_date
            cell?.lblShipDate.text = self.responseObj?.completedJobList![indexPath.row].shipment_date
            cell?.lblNotes.text = self.responseObj?.completedJobList![indexPath.row].notes_production
            cell?.lblCustomerName.text = self.responseObj?.completedJobList![indexPath.row].customer
            cell?.delegate = self
            cell?.index = indexPath
            
        }
        
        
        
        return cell!
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PGShipmentDetailVC") as? PGShipmentDetailVC
//        if searchActive == true {
//            vc?.job = self.filters![indexPath.row]
//
//        }else {
//            vc?.job = self.responseObj?.completedJobList![indexPath.row]
//
//        }
//        self.navigationController?.pushViewController(vc!, animated: true)
//
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 339.0
    }
    
}

extension PGReadyToShipmentVC : ReadyToShipNoteDelegate {
    
    func editShipmentNotesProduction( checkCell : PGReadyToShipCell , indexPath : IndexPath) {

        self.indexSelect = indexPath.row
        self.notesProdiction = self.responseObj?.completedJobList![indexPath.row].notes_production
        viewOfPop.isHidden = false
        
        if self.notesProdiction == "" {
            self.editTextView.placeholderText = "Enter Note"
        } else {
            self.editTextView.text = self.notesProdiction
        }
    }
    
    func showTheImageDetail(checkCell: PGReadyToShipCell, indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PGShowImageVC") as? PGShowImageVC
        if #available(iOS 10.0, *) {
            vc?.modalPresentationStyle = .overCurrentContext
        } else {
            vc?.modalPresentationStyle = .currentContext
        }
        if searchActive == true {
            vc?.completeJob = filters![indexPath.row]
            
        }else {
            vc?.completeJob = self.responseObj?.completedJobList![indexPath.row]
            
        }
        vc?.isCompleteOrActive = true
        vc?.providesPresentationContextTransitionStyle = true
        present(vc!, animated: true, completion: {() -> Void in
        })
    }
    
    
    func completeOrder(checkCell : PGReadyToShipCell , indexPath : IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PGCompleteOrderVC") as? PGCompleteOrderVC
//        vc?.job = self.responseObj?.completedJobList![indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)

        
        
        //        let idOfUser = UserDefaults.standard.string(forKey: "id")
        
//        let orderId  = self.responseObj?.completedJobList![indexPath.row].id
//        let loginParam =    [ "id"         : orderId!
//            ] as [String : Any]
//
//        startAnimating(size, message: KMessageValidation, messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
//
//        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: READYTOSHIP, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
//            self.updateProduction = response as? UserResponse
//            self.stopAnimating()
//            if self.responseObj?.success == true {
//                self.showAlertViewWithTitle(title: "Pacific", message: (self.updateProduction?.message!)!, dismissCompletion: {
//                })
//            }else {
//                self.showAlert(title: "Pacific", message: (self.updateProduction?.message!)!, controller: self)
//            }
//
//        }, fail: { (error) in
//            self.stopAnimating()
//
//        }, showHUD: true)
    }
    
}
