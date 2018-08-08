//
//  PGChangePasswordVC.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 27/06/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PGChangePasswordVC: UIViewController , NVActivityIndicatorViewable {

    @IBOutlet weak var txtCurrentPAss: UITextField!
    @IBOutlet weak var txtNewPAss: UITextField!
    
    @IBOutlet weak var txtConfirmPAss: UITextField!
    let size = CGSize(width: 60, height: 60)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtCurrentPAss.setLeftPaddingPoints(10)
        txtNewPAss.setLeftPaddingPoints(10)
        txtConfirmPAss.setLeftPaddingPoints(10)

        WAShareHelper.setBorderAndCornerRadius(layer: txtCurrentPAss.layer, width: 1.0, radius: 0.0, color: UIColor(red: 17/255.0, green: 60/255.0, blue: 115/255.0, alpha: 1.0))
        WAShareHelper.setBorderAndCornerRadius(layer: txtNewPAss.layer, width: 1.0, radius: 0.0, color: UIColor(red: 17/255.0, green: 60/255.0, blue: 115/255.0, alpha: 1.0))
        WAShareHelper.setBorderAndCornerRadius(layer: txtConfirmPAss.layer, width: 1.0, radius: 0.0, color: UIColor(red: 17/255.0, green: 60/255.0, blue: 115/255.0, alpha: 1.0))


        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSideMenu_Pressed(_ sender: UIButton) {
        self.revealController.show(self.revealController.leftViewController)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnUpdate_Pressed(_ sender: UIButton) {
//        let userID = localUserData.id
        let idOfUser = UserDefaults.standard.string(forKey: "id")

        let loginParam = [ "userid"                        :  "\(idOfUser!)",
                           "current_password"              :  txtCurrentPAss.text! ,
                           "new_password"                  :  txtNewPAss.text!
            ] as [String : Any]
        startAnimating(size, message: "Wait for Update Password", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)

        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: CHANGEPASSWORD, isLoaderShow: true, serviceType: "Code Send", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            self.stopAnimating()

            if responseObj.success == true {
               
                self.showAlert(title: "Pacific", message: responseObj.message! , controller: self)
                
            }else {
                
                self.showAlert(title: "Pacific", message: responseObj.message! , controller: self)

                //                self .showAlert(title: "Mobinp", message: responseObj.message! , controller: self)
            }
            
            
        }, fail: { (error) in
            
            self.showAlert(title: "Mobinp", message: error.description , controller: self)
            self.stopAnimating()

        }, showHUD: true)
        
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
