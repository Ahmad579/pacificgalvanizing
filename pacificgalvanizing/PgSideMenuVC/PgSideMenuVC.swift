//
//  PgSideMenuVC.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 25/06/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class PgSideMenuVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFirstNameOfLetter: UILabel!

    @IBOutlet weak var imgOfUser: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let firstName = UserDefaults.standard.string(forKey: "firstName")
        let lastName = UserDefaults.standard.string(forKey: "lastName")


        
        let cgFloat: CGFloat = self.imgOfUser.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(self.imgOfUser, radius: CGFloat(someFloat))
        
        let firstCharacter = firstName?.substring(to:(firstName?.index((firstName?.startIndex)!, offsetBy: 1))!)
        lblName.text = "\(firstName!) \(lastName!)"
        lblFirstNameOfLetter.text = firstCharacter
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func btnSetting_Pressed(_ sender: UIButton) {
        WAShareHelper.goToHomeController(vcIdentifier: "PGChangePasswordVC", storyboardName: "Home", navController: nil, leftMenuIdentifier: "PgSideMenuVC")

    }
    
    
    @IBAction func btnHome_Pressed(_ sender: UIButton) {
        WAShareHelper.goToHomeController(vcIdentifier: "PgOrderVC", storyboardName: "Home", navController: nil, leftMenuIdentifier: "PgSideMenuVC")
    }
    
    @IBAction func btnLogout_Pressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        UserDefaults.standard.set(nil  , forKey : "id")
        UserDefaults.standard.set(nil  , forKey : "firstName")
        UserDefaults.standard.set(nil  , forKey : "lastName")
        UserDefaults.standard.set(nil  , forKey : "email")
        localUserData = nil
        UIApplication.shared.keyWindow?.rootViewController = vc
        

    }
    
    @IBAction func btnHelp_Pressed(_ sender: UIButton) {
        
        
    }

}
