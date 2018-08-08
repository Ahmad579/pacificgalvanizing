//
//  PGShipmentDetailVC.swift
//  pacificgalvanizing
//
//  Created by Ahmed Durrani on 26/06/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PGShipmentDetailVC: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblOrderNumber: UILabel!
    var job: CompletedJob?
    let photoPicker = PhotoPicker()
    var cover_image: UIImage?
    var shipmentComplete: UserResponse?
    let size = CGSize(width: 60, height: 60)
    var responseObj: UserResponse?
    @IBOutlet weak var imgOfOrder: UIImageView!
    var morePhotos: [UIImage]? = []
    @IBOutlet var collectionViewCell: UICollectionView!
    @IBOutlet weak var lblComplete: UILabel!
    
    @IBOutlet weak var imgOfCompleteBtn: UIImageView!
    @IBOutlet weak var btnCompleteImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOrderNumber.text = job?.order_no
        collectionViewCell.delegate = self
        collectionViewCell.dataSource = self
        collectionViewCell.reloadData()
        //        let tapGestureRecognizerforDp = UITapGestureRecognizer(target:self, action:#selector(PGShipmentDetailVC.imageTappedForDp(img:)))
        //        imgOfOrder.isUserInteractionEnabled = true
        //        imgOfOrder.addGestureRecognizer(tapGestureRecognizerforDp)
        
        self.lblComplete.isHidden = true
        self.imgOfCompleteBtn.isHidden = true
        self.btnCompleteImage.isHidden = true

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnBack_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTakePic_Pressed(_ sender: UIButton) {
        //        imageTappedForDp(img: AnyObject.self as AnyObject)
        
        if (morePhotos?.count)!  < 5 {
            photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self, successBlock: { (orignal, edited) in
                self.cover_image = orignal

                self.morePhotos?.append(orignal!)
                if self.collectionViewCell != nil {
                    self.collectionViewCell?.reloadData()
                }
                
                
             
                
            })
            
        }else {
            self.showAlert(title: "Pacific", message: "You have only 5 images to upload" , controller: self)
            
        }
    }
    
    @IBAction func btnGallery_Pressed(_ sender: UIButton) {
        //        imageTappedForDp(img: AnyObject.self as AnyObject)
        if (morePhotos?.count)!  < 5 {
            photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self, successBlock: { (orignal, edited) in
                self.cover_image = orignal

                self.morePhotos?.append(orignal!)
                if self.collectionViewCell != nil {
                    self.collectionViewCell?.reloadData()
                }
            })
            
        }else {
            self.showAlert(title: "Pacific", message: "You have only 5 images to upload" , controller: self)
            
        }
        
        
    }
    
    @IBAction func btnUpload_Pressed(_ sender: UIButton) {
        let idOfJob = self.job?.id
        let params =        ["id"                    :  "\(idOfJob!)"  ,
            ] as [String : Any]
        
        WebServiceManager.multiPartImageMorePhotos(params: params as Dictionary<String, AnyObject>, morePhotos: morePhotos , serviceName:IMAGEUPLOAD, imageParam: "file", serviceType: "", profileImage: cover_image, cover_image_param: "", cover_image: nil, modelType: UserResponse.self, success: { (response) in
            let parseResponse = response as! UserResponse
            if parseResponse.success == true {
                self.showAlert(title: "Error", message: parseResponse.message!, controller: self)
                
            }else {
                self.showAlert(title: "Error", message: parseResponse.message!, controller: self)
            }
        }, fail: { (error) in
            self.showAlert(title: "Error", message: "no internet", controller: self)
        })
        
        
    }
    @IBAction func btnAttachFile_Pressed(_ sender: UIButton) {
       
        let idOfJob = self.job?.id
        let params =        ["id"                    :  "\(idOfJob!)"  ,
            ] as [String : Any]
        
        WebServiceManager.multiPartImage(params: params as Dictionary<String, AnyObject>, serviceName: IMAGEUPLOAD, imageParam: "file", serviceType: "upload Image", profileImage: cover_image, cover_image_param: "", cover_image: nil , modelType: UserResponse.self, success: { (response) in
          
            self.shipmentComplete = (response as? UserResponse)!
            if self.shipmentComplete?.success == true {
                self.showAlertViewWithTitle(title: "Pacific", message: (self.shipmentComplete?.message!)!, dismissCompletion: {
                    self.lblComplete.isHidden = false
                    self.imgOfCompleteBtn.isHidden = false
                    self.btnCompleteImage.isHidden = false

                })
            }
            else
            {
                self.showAlert(title: "Pacific", message: (self.shipmentComplete?.message!)!, controller: self)
                
            }
        }) { (error) in
            self.showAlert(title: "Pacific", message: error.description , controller: self)
            
        }
        
    }
    
    @IBAction func btnSend_Pressed(_ sender: UIButton) {
        let idOfJob = self.job?.id
        
        let params =        ["id"                    :  "\(idOfJob!)"  ,
            ] as [String : Any]
        
        startAnimating(size, message: KMessageValidation, messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        
        WebServiceManager.post(params:params as Dictionary<String, AnyObject> , serviceName: SHIPMENTCOMPLETED, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
            self.responseObj = response as? UserResponse
            self.stopAnimating()
            
            if self.responseObj?.success == true {
                self.showAlertViewWithTitle(title: "Pacific", message: (self.responseObj?.message!)!, dismissCompletion: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
                
            }else {
                
                self.showAlert(title: "Pacific", message: (self.responseObj?.message!)!, controller: self)
                
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            self.showAlert(title: "Pacific", message: error.description, controller: self)
            
            
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

//
//extension PGShipmentDetailVC: PhotoTweaksViewControllerDelegate {
//
//    func photoTweaksController(_ controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
//        _ = controller.navigationController?.popViewController(animated: true)
//
//            self.morePhotos?.append(croppedImage)
//
//        }
//
//
//    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController!) {
//        _ = controller.navigationController?.popViewController(animated: true)
//    }
//
//}

extension PGShipmentDetailVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if isUpdateMode {
        //            return ((self.businessDetail?.data?.Gallery?.count)! + (morePhotos?.count)! + 1)
        //        }
        return ((morePhotos?.count)! + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! WAMorePhotoCell
        
        //        cell.removebutton.isHidden = (indexPath.row == morePhotos?.count)
        //        cell.removebutton.tag = indexPath.row
        if indexPath.row != morePhotos?.count {
            cell.imagePhoto.image = morePhotos?[indexPath.row]
        }else {
            cell.imagePhoto.image = UIImage(named: "choose_gallery.jpg")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (morePhotos?.count)!  < 5 {
            if indexPath.row == morePhotos?.count {
                photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self, successBlock: { (orignal, edited) in
                    
                    self.cover_image = orignal

                    self.morePhotos?.append(self.cover_image!)
                    if self.collectionViewCell != nil {
                        self.collectionViewCell?.reloadData()
                    }

                    //                let vc = PhotoTweaksViewController(image: orignal!)
                    //                vc?.delegate = self
                    //                vc?.autoSaveToLibray = false
                    //                self.navigationController?.pushViewController(vc!, animated: true)
                    
//                    let idOfJob = self.job?.id
//                    let params =        ["id"                    :  "\(idOfJob!)"  ,
//                        ] as [String : Any]
//
//                    WebServiceManager.multiPartImage(params: params as Dictionary<String, AnyObject>, serviceName: IMAGEUPLOAD, imageParam: "file", serviceType: "upload Image", profileImage: orignal, cover_image_param: "", cover_image: nil , modelType: UserResponse.self, success: { (response) in
//                        self.shipmentComplete = (response as? UserResponse)!
//                        if self.shipmentComplete?.success == true {
//
//                            self.showAlert(title: "Pacific", message: (self.shipmentComplete?.message!)!, controller: self)
//                        }
//                        else
//                        {
//                            self.showAlert(title: "Pacific", message: (self.shipmentComplete?.message!)!, controller: self)
//
//                        }
//                    }) { (error) in
//                        self.showAlert(title: "Pacific", message: error.description , controller: self)
//
//                    }
//
                })
            }
        }else {
            self.showAlert(title: "Pacific", message: "You have only 5 images to upload" , controller: self)
            
        }
        
    }
}

extension PGShipmentDetailVC: PhotoTweaksViewControllerDelegate  {
    
    func photoTweaksController(_ controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        _ = controller.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController!) {
        _ = controller.navigationController?.popViewController(animated: true)
    }
    
}
