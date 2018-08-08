//
//  PgSignUpVC.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 25/06/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PgSignUpVC: UIViewController  , NVActivityIndicatorViewable {
    @IBOutlet weak var viewOfLogo: UIView!
  
    @IBOutlet weak var txtEmail     : UITextField!
    @IBOutlet weak var txtPass      : UITextField!
    @IBOutlet weak var txtFirstNme  : UITextField!
    @IBOutlet weak var txtLastNme       : UITextField!
    @IBOutlet weak var txtConfirmPAss: UITextField!

    let size = CGSize(width: 60, height: 60)

    override func viewDidLoad() {
        super.viewDidLoad()
           WAShareHelper.setBorderAndCornerRadius(layer: viewOfLogo.layer, width: 5.0, radius: 55.0, color: UIColor(red: 17/255.0, green: 60/255.0, blue: 115/255.0, alpha: 1.0))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSignIn_Pressed(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
    }

  
    @IBAction func btnVerify_Pressed(_ sender: UIButton) {
        
        
        let loginParam =  [ "email"                      : txtEmail.text!,
                            "password"                   : txtPass.text!,
                            "first_name"                 : txtFirstNme.text! ,
                            "last_name"                  : txtLastNme.text!
            
            ] as [String : Any]
        
        startAnimating(size, message: "Waiting", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: SIGNUP, isLoaderShow: true, serviceType: "Sign Up", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            self.stopAnimating()
            
            if responseObj.response_code == 200 {
                localUserData = responseObj.data
                self.navigationController?.popViewController(animated: true)
                
            }else {
                self.showAlert(title: KMessageValidation, message: responseObj.message! , controller: self)
                
                
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            self.showAlert(title: "PFG", message: error.description, controller: self)
        }, showHUD: true)
    }

}
