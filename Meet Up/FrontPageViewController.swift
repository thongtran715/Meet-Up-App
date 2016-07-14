//
//  FrontPageViewController.swift
//  Meet Up
//
//  Created by Thong Tran on 7/9/16.
//  Copyright © 2016 ThongApp. All rights reserved.
//

import UIKit
import Spring
import VideoSplashKit
import TransitionAnimation
import TransitionTreasury
import Parse
class FrontPageViewController: VideoSplashViewController, ModalTransitionDelegate {
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVideo()
        
    }
    // making animation
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        signInLayer.animation = "slideDown"
        registerLayer.animation = "slideDown"
        signInLayer.animate()
        registerLayer.animate()
        
        if PFUser.currentUser() != nil {
                    let model = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("appAccess")
                   self.tr_presentViewController(model, method:  TRPresentTransitionMethod.Fade, statusBarStyle: TRStatusBarStyle.LightContent, completion: nil)
                }


    }
    // Outlet
    @IBOutlet var registerLayer: SpringButton!
    @IBOutlet var signInLayer: SpringButton!
    
    @IBAction func registerButton(sender: AnyObject) {
        registerLayer.animation = "pop"
        registerLayer.duration = 0.8
        registerLayer.animate()
        
        let model = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("register") as! RegisterViewController
        model.modalDelegate = self
       // tr_presentViewController(model, method: TRPresentTransitionMethod.TaaskyFlip(blurEffect: true))
        tr_presentViewController(model, method:  TRPresentTransitionMethod.TaaskyFlip(blurEffect: true), statusBarStyle: TRStatusBarStyle.LightContent, completion: nil)
    }
    var tr_presentTransition: TRViewControllerTransitionDelegate?
    
    @IBAction func signInButton(sender: AnyObject) {
        signInLayer.animation = "pop"
        signInLayer.duration = 0.8
        signInLayer.animate()
        
        let model = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("signIn") as! SiginInViewController
        model.modalDelegate = self
        //tr_presentViewController(model, method: TRPresentTransitionMethod.TaaskyFlip(blurEffect: true))
        tr_presentViewController(model, method:  TRPresentTransitionMethod.TaaskyFlip(blurEffect: true), statusBarStyle: TRStatusBarStyle.LightContent, completion: nil)
    }
    
    private func setUpVideo ()
    {
        let url =
            NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("splash", ofType: "mp4")!)
    
        videoFrame = view.frame
        fillMode = .ResizeAspectFill
        alwaysRepeat = true
        sound = false
        startTime = 45.0
        duration = 9.0
        alpha = 0.7
        backgroundColor = UIColor.blackColor()
        
        contentURL = url
    
    }
    
    func modalViewControllerDismiss(callbackData data: AnyObject?) {
        tr_dismissViewController()
    }
    
    
}
