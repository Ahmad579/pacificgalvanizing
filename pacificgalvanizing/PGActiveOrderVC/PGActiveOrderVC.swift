//
//  PGActiveOrderVC.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 26/06/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PGActiveOrderVC: UIViewController , NVActivityIndicatorViewable , UISearchBarDelegate  {
    

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
//        tblView.register(UINib(nibName: "PgCompletedCell", bundle: nil), forCellReuseIdentifier: "PgCompletedCell")
        WAShareHelper.setBorderAndCornerRadius(layer: searchBar.layer, width: 1.0, radius: 5.0, color: UIColor(red: 21/255.0, green: 52/255.0, blue: 101/255.0, alpha: 1.0))

//        self.searchBar.searchBarStyle = UISearchBarStyle.prominent
//        self.searchBar.isTranslucent = false
//        searchBar.backgroundImage = UIImage()
//        let textField = self.searchBar.value(forKey: "searchField") as? UITextField
//        textField?.backgroundColor = UIColor.white
//        self.searchBar.barTintColor = UIColor.white

        // Do any additional setup after loading the view.

            self.editTextView.text = notesProdiction
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getCompletedJob()

    }
    
    func getCompletedJob(){
//        let userId  = localUserData.id
        let idOfUser = UserDefaults.standard.string(forKey: "id")
   
        let loginParam =     [ "userid"         : idOfUser!,
                            ] as [String : Any]
        
        startAnimating(size, message: KMessageValidation, messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: USERACTIVEJOB, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
            self.responseObj = response as? UserResponse
            self.stopAnimating()
            
            if self.responseObj?.success == true {
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
                
            }else {
//                self.showAlert(title: "Pacific", message: (self.responseObj?.message!)!, controller: self)
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

extension PGActiveOrderVC: UITableViewDelegate, UITableViewDataSource {
    
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
                noDataLabel.text = "There are currently no Active Order."
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true  {
            return (filters?.count)!
        } else {
                return (responseObj?.completedJobList?.count)!
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PgCompletedCell? = tableView.dequeueReusableCell(withIdentifier: "PgCompletedCell") as! PgCompletedCell?
        if cell == nil {
            cell = PgCompletedCell(style: .default, reuseIdentifier: "PgCompletedCell")
        }
        
        if searchActive == true  {
            cell?.lblOrderNum.text = self.filters![indexPath.row].order_no
            let workingDay = self.filters![indexPath.row].work_days
//            cell?.collectionViewCell.reloadData()
          

            if workingDay == 1 {
                cell?.lblWorkDaysLeft.textColor = UIColor.red
                
                cell?.lblWorkDaysLeft.text = "\(workingDay!) days"

            } else {
                cell?.lblWorkDaysLeft.textColor = UIColor.black
                
                cell?.lblWorkDaysLeft.text = "\(workingDay!) days"
            }
            cell?.lblOrderNum.text = self.filters![indexPath.row].order_no

            cell?.lblArrivedDate.text = self.filters![indexPath.row].arrived_date
            cell?.lblShipDate.text = self.filters![indexPath.row].shipment_date
            cell?.lblCustomerName.text = self.filters![indexPath.row].customer
            cell?.lblNotes.text = self.filters![indexPath.row].notes_production
            cell?.delegate = self
            cell?.index = indexPath

        } else {
            cell?.lblOrderNum.text = self.responseObj?.completedJobList![indexPath.row].order_no
            let workingDay = self.responseObj?.completedJobList![indexPath.row].work_days
            
            if workingDay == 1 {
                cell?.lblWorkDaysLeft.textColor = UIColor.red
                
                cell?.lblWorkDaysLeft.text = "\(workingDay!) days"
            } else if (workingDay)! > 1 && workingDay! < 6 {
                cell?.lblWorkDaysLeft.textColor = UIColor.yellow
                cell?.lblWorkDaysLeft.text = "\(workingDay!) days"
            }
            else if (workingDay)! > 6 {
                cell?.lblWorkDaysLeft.textColor = UIColor.green
                cell?.lblWorkDaysLeft.text = "\(workingDay!) days"

            }
            
            cell?.lblOrderNum.text = self.responseObj?.completedJobList![indexPath.row].order_no
            
            let shipMentDate = self.responseObj?.completedJobList![indexPath.row].shipment_date
            let arrivedDate = self.responseObj?.completedJobList![indexPath.row].arrived_date
            let dateFmt = DateFormatter()
            dateFmt.dateFormat =  "dd/MM/yyyy"
            let date = dateFmt.date(from: shipMentDate!)
            let date1 = dateFmt.date(from: arrivedDate!)

            print(date!)

            
            let datesssForm = DateFormatter()
            datesssForm.dateFormat = "MM/dd/yyyy"
            let shipmentDateResult = datesssForm.string(from: date!)
            let arrivedDateResult = datesssForm.string(from: date1!)

//            datesssForm.timeZone =
            
            
            
            cell?.lblArrivedDate.text = arrivedDateResult
            cell?.lblShipDate.text = shipmentDateResult
            cell?.lblNotes.text = self.responseObj?.completedJobList![indexPath.row].notes_production
            cell?.lblCustomerName.text = self.responseObj?.completedJobList![indexPath.row].customer
            cell?.delegate = self
            cell?.index = indexPath

        }
        
       
        
        return cell!
        
        
        
        
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PGShipmentDetailVC") as? PGShipmentDetailVC
            if searchActive == true {
                vc?.job = self.filters![indexPath.row]

            }else {
                vc?.job = self.responseObj?.completedJobList![indexPath.row]

            }
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 367.0
    }
    
}

extension PGActiveOrderVC : EditNoteDelegate {
    
    func editNotesProduction( checkCell : PgCompletedCell , indexPath : IndexPath) {
        
        self.indexSelect = indexPath.row
        self.notesProdiction = self.responseObj?.completedJobList![indexPath.row].notes_production
        viewOfPop.isHidden = false
        
        if self.notesProdiction == "" {
            self.editTextView.placeholderText = "Enter Note"
        } else {
             self.editTextView.text = self.notesProdiction
        }
        
    }
    
    func readyToShip(checkCell: PgCompletedCell, indexPath: IndexPath) {
        
        let idOfShipment = self.responseObj?.completedJobList![indexPath.row].id
        
        let loginParam =       [ "shipmentid"         : "\(idOfShipment!)",
                                 ] as [String : Any]
        
        startAnimating(size, message: KMessageValidation, messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: READYTOSHIPINACTIVEORDER, isLoaderShow: true, serviceType: "Ready to Ship", modelType: UserResponse.self, success: { (response) in
            let responsess = (response as? UserResponse)
            
            self.stopAnimating()
            
            if responsess?.success == true {
                self.showAlertViewWithTitle(title: "Pacific", message: (responsess!.message!), dismissCompletion: {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PGReadyToShipmentVC") as? PGReadyToShipmentVC
                    self.navigationController?.pushViewController(vc!, animated: true)

                })

            }else {
                self.showAlert(title: "Pacific", message: (responsess!.message!), controller: self)
                
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            
        }, showHUD: true)
    
    }
    
    func showImages(checkCell: PgCompletedCell, indexPath: IndexPath) {
        
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
         vc?.isCompleteOrActive = false
        vc?.providesPresentationContextTransitionStyle = true
        present(vc!, animated: true, completion: {() -> Void in
        })
    }
    
    func showPop(checkCell: PgCompletedCell, indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PGOrderPopVC") as? PGOrderPopVC
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
        vc?.providesPresentationContextTransitionStyle = true
        present(vc!, animated: true, completion: {() -> Void in
        })
    }

}


extension UITextView{
    
    func setPlaceholder() {
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Enter Notes...."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
    }
    
    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
}
