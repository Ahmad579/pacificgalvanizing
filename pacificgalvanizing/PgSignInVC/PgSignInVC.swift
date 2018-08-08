//
//  PgSignInVC.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 25/06/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PgSignInVC: UIViewController  , NVActivityIndicatorViewable{
    @IBOutlet weak var viewOfLogo: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    let size = CGSize(width: 60, height: 60)

    override func viewDidLoad() {
        super.viewDidLoad()
        WAShareHelper.setBorderAndCornerRadius(layer: viewOfLogo.layer, width: 5.0, radius: 55.0, color: UIColor(red: 17/255.0, green: 60/255.0, blue: 115/255.0, alpha: 1.0))
//        txtEmail.text = "ahmad@yahoo.com"
//        txtPass.text = "123456789"
        let idOfUser = UserDefaults.standard.string(forKey: "id")

        if idOfUser == nil  {
            
        } else {
            WAShareHelper.goToHomeController(vcIdentifier: "PgOrderVC", storyboardName: "Home", navController: self.navigationController!, leftMenuIdentifier: "PgSideMenuVC")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnLogin_Pressed(_ sender: UIButton) {
//
        let loginParam =  [ "email"         : txtEmail.text!,
                            "password"      : txtPass.text! ,
            ] as [String : Any]
        
        startAnimating(size, message: KMessageValidation, messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: LOGIN, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
            let responseObj = response as! UserResponse
            self.stopAnimating()
            
            if responseObj.response_code == 200 {
                localUserData = responseObj.data
                UserDefaults.standard.set(responseObj.data?.firstname , forKey: "firstName")
                UserDefaults.standard.set(responseObj.data?.lastname , forKey: "lastName")
                UserDefaults.standard.set(responseObj.data?.email, forKey: "email")
                UserDefaults.standard.set(responseObj.data?.id , forKey: "id")
                
                
               WAShareHelper.goToHomeController(vcIdentifier: "PgOrderVC", storyboardName: "Home", navController: self.navigationController!, leftMenuIdentifier: "PgSideMenuVC")
                
            }else {
                
                self.showAlert(title: "Pacific", message: responseObj.message!, controller: self)
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            
        }, showHUD: true)
        
    }
    
    
    @IBAction func btnSignUp_Pressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PgSignUpVC") as? PgSignUpVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }

}
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}
