//
//  ProfileViewController.swift
//  Meet Up
//
//  Created by Thong Tran on 7/12/16.
//  Copyright © 2016 ThongApp. All rights reserved.
//

import UIKit
import Parse
class ProfileViewController: UIViewController {

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    var photoTaking = PhotoTakingHelper?()
    private func takePhoto () {
        photoTaking = PhotoTakingHelper(viewCol: self, callback2: { (image) in
            
        })
    }
    
    
    @IBOutlet var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
        self.profileImage.layer.borderWidth = 4.0
        self.profileImage.clipsToBounds = true
      
    }
    @IBOutlet var nameOfTheUser: UILabel!

    @IBAction func upLoadPhoto(sender: AnyObject) {
        takePhoto()
    }
    @IBAction func signOut(sender: AnyObject) {
    }
    @IBAction func changeNameButton(sender: AnyObject) {
    }
    @IBAction func resetPasswordButton(sender: AnyObject) {
    }


}
