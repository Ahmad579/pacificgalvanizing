//
//  PgOrderVC.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 25/06/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class PgOrderVC: UIViewController {
    let photoPicker = PhotoPicker()
    var morePhotos: [UIImage]? = []
    var cover_image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func btnSideMenu_Pressed(_ sender: UIButton) {
        self.revealController.show(self.revealController.leftViewController)
    }
    
    @IBAction func btnActiveOrder_Pressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PGActiveOrderVC") as? PGActiveOrderVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
//        photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self) { (orignal, edited) in
//            self.cover_image = orignal
////            self.imgOfOrder.image = orignal
//            let vc = PhotoTweaksViewController(image: orignal!)
//            vc?.delegate = self
//            vc?.autoSaveToLibray = false
//            self.navigationController?.pushViewController(vc!, animated: true)
//
//
//    }
    }
    @IBAction func btnReadytoShipment_Pressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PGReadyToShipmentVC") as? PGReadyToShipmentVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
        //        photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self) { (orignal, edited) in
        //            self.cover_image = orignal
        ////            self.imgOfOrder.image = orignal
        //            let vc = PhotoTweaksViewController(image: orignal!)
        //            vc?.delegate = self
        //            vc?.autoSaveToLibray = false
        //            self.navigationController?.pushViewController(vc!, animated: true)
        //
        //
        //    }
    }
    
    @IBAction func btnCompletedOrder_Pressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PGCompleteOrderVC") as? PGCompleteOrderVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }

  

}

//extension PgOrderVC: PhotoTweaksViewControllerDelegate {
//
//        func photoTweaksController(_ controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
//            _ = controller.navigationController?.popViewController(animated: true)
//
//            self.morePhotos?.append(croppedImage)
//
//        }
//
//
//        func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController!) {
//            _ = controller.navigationController?.popViewController(animated: true)
//        }
//
//}

