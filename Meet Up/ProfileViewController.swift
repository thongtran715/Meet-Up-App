//
//  ProfileViewController.swift
//  Meet Up
//
//  Created by Thong Tran on 7/12/16.
//  Copyright © 2016 ThongApp. All rights reserved.
//

import UIKit
import Parse
import Photos
class ProfileViewController: UIViewController {
    

    var photoTaking = PhotoTakingHelper?()
    private func takePhoto () {
        photoTaking = PhotoTakingHelper(viewCol: self, callBack: { (image) in
            if let image = image {
                let imageData = UIImageJPEGRepresentation(image, 0.8)!
                let imageFile = PFFile(name: "image.jpg", data: imageData)!
                let user = PFUser.currentUser()
                user?.setObject(imageFile, forKey: "profileImage")
                user?.saveInBackground()
            }
        })
    }
    
    
   
    @IBOutlet var profileImage: UIImageView!
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
    }
    override func viewWillAppear(animated: Bool) {
        nameOfTheUser.text = PFUser.currentUser()?.username
        ParseHelper.getPictureProfile { (imageData, error) in
            if error == nil {
                if let finalimage = UIImage(data: imageData!) {
                    self.profileImage.image = finalimage
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
        self.profileImage.layer.borderWidth = 4.0
        self.profileImage.clipsToBounds = true
        
        self.profileImage.userInteractionEnabled = true
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapButtonClicked))
        self.profileImage.addGestureRecognizer(tap)
    }
    
    func tapButtonClicked (){
        let imageInfo: JTSImageInfo = JTSImageInfo()
        imageInfo.image = self.profileImage.image
        imageInfo.referenceRect = self.profileImage.frame
        imageInfo.referenceView = self.profileImage.superview
        imageInfo.referenceContentMode = self.profileImage.contentMode
        imageInfo.referenceCornerRadius = self.profileImage.layer.cornerRadius
        
        
        let imageViewer:JTSImageViewController = JTSImageViewController(imageInfo: imageInfo, mode: .Image, backgroundStyle: .Blurred)
       
        imageViewer.showFromViewController(self, transition: .FromOriginalPosition)
    }
    
    @IBOutlet var nameOfTheUser: UILabel!
    
    
    
    
    @IBAction func PhotoUpload(sender: UITapGestureRecognizer) {
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization == .NotDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.PhotoUpload(sender)
                })
            })
        }
        
        if authorization == .Authorized {
            let controller = ImagePickerSheetController()
            
            controller.addAction(ImageAction(title: NSLocalizedString("Take Photo From Camera", comment: "Action Title"), secondaryTitle: NSLocalizedString("Use this one", comment: "Action Title"), handler: { (_) -> () in
                
                self.takePhoto()
                
                }, secondaryHandler: { (action, numberOfPhotos) -> () in
                    controller.getSelectedImagesWithCompletion({ (images) -> Void in
                        if let image = images[0] {
                            let imageData = UIImageJPEGRepresentation(image, 0.8)!
                            let imageFile = PFFile(name: "image.jpg", data: imageData)!
                            let user = PFUser.currentUser()
                            user?.setObject(imageFile, forKey: "profileImage")
                            user?.saveInBackground()
                        }
                        self.profileImage.image = images[0]
                    })
            }))
            
            controller.addAction(ImageAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .Cancel, handler: nil, secondaryHandler: nil))
            
            presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func signOut(sender: AnyObject) {
        PFUser.logOutInBackground()
        let vc = storyboard?.instantiateViewControllerWithIdentifier("frontPage")
        self.presentViewController(vc!, animated: true, completion: nil)
    }
    @IBAction func changeNameButton(sender: AnyObject) {
        
    }
    @IBAction func resetPasswordButton(sender: AnyObject) {
        
    }
    
    
}
