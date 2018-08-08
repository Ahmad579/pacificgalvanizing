//
//  PGCompleteOrderVC.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 25/06/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PGCompleteOrderVC: UIViewController, NVActivityIndicatorViewable , UISearchBarDelegate {
    var responseObj: UserResponse?
    @IBOutlet var searchBar: UISearchBar!
    var searchActive : Bool = false
    var filters: [CompletedJob]?

    @IBOutlet var tblView: UITableView!
    let size = CGSize(width: 60, height: 60)

    override func viewDidLoad() {
        super.viewDidLoad()
//        tblView.register(UINib(nibName: "PGReadyToCompleteCell", bundle: nil), forCellReuseIdentifier: "PGReadyToCompleteCell")
        WAShareHelper.setBorderAndCornerRadius(layer: searchBar.layer, width: 1.0, radius: 5.0, color: UIColor(red: 21/255.0, green: 52/255.0, blue: 101/255.0, alpha: 1.0))
        getCompletedJob()
        // Do any additional setup after loading the view.
    }
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getCompletedJob(){
        
        let idOfUser = UserDefaults.standard.string(forKey: "id")

        let loginParam =  [ "userid"         : idOfUser!,
                          ] as [String : Any]
        
        startAnimating(size, message: KMessageValidation, messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: USERCOMPLETEDJOB, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
            self.responseObj = response as? UserResponse
            self.stopAnimating()
            
            if self.responseObj?.success == true {
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
                
            }else {
                
                
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
        self.tblView.reloadData()
    }
}
extension PGCompleteOrderVC: UITableViewDelegate, UITableViewDataSource {
    
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
                    noDataLabel.text = "There are currently no Completed Order."
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
        var cell: PGReadyToCompleteCell? = tableView.dequeueReusableCell(withIdentifier: "PGReadyToCompleteCell") as! PGReadyToCompleteCell?
        if cell == nil {
            cell = PGReadyToCompleteCell(style: .default, reuseIdentifier: "PGReadyToCompleteCell")
        }
        
        if searchActive == true  {
            cell?.lblOrderNum.text = self.filters![indexPath.row].order_no
            cell?.lblArrivedDate.text = self.filters![indexPath.row].arrived_date
            cell?.lblShipDate.text = self.filters![indexPath.row].shipment_date
            cell?.lblCustomerName.text = self.filters![indexPath.row].customer
            cell?.delegate = self
            cell?.index = indexPath

        } else {
            cell?.lblOrderNum.text = self.responseObj?.completedJobList![indexPath.row].order_no

            cell?.lblArrivedDate.text = self.responseObj?.completedJobList![indexPath.row].arrived_date
            cell?.lblShipDate.text = self.responseObj?.completedJobList![indexPath.row].shipment_date
            cell?.lblCustomerName.text = self.responseObj?.completedJobList![indexPath.row].customer
            cell?.delegate = self
            cell?.index = indexPath

        }
        return cell!

    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 260.0
    }
    
}

extension PGCompleteOrderVC : ShowImageDelegate {
    func showImagesInComplete( checkCell : PGReadyToCompleteCell , indexPath : IndexPath) {
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

}
