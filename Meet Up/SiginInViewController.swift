//
//  SiginInViewController.swift
//  Meet Up
//
//  Created by Thong Tran on 7/10/16.
//  Copyright © 2016 ThongApp. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation
import Parse
import Spring
import SwiftSpinner
class SiginInViewController: UIViewController, UITextFieldDelegate, ModalTransitionDelegate {
    var tr_presentTransition: TRViewControllerTransitionDelegate?

    @IBOutlet var passWordTextField: SpringTextField!
    @IBOutlet var emailTextField: SpringTextField!
    weak var modalDelegate: ModalViewControllerDelegate?
    //@IBOutlet var passWordTextField: UITextField!
    //@IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passworldButton: NSLayoutConstraint!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passWordTextField.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardNotification(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 17.0
                self.passworldButton.constant = 8.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant  += passworldButton.constant
                self.passworldButton.constant = endFrame?.size.height ?? 8.0
            }
            UIView.animateWithDuration(duration,
                                       delay: NSTimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    @IBOutlet var logInButtonOutlet: UIButton!
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        //SwiftSpinner.show("Authenticating account")
        SwiftSpinner.show("Authenticating account").addTapHandler({
            SwiftSpinner.hide()
            }, subtitle: "Your internet connection may affect to the process of authenticating")

        //SwiftSpinner.showWithDelay(1.0, title: "Authenticating account")

        PFUser.logInWithUsernameInBackground(emailTextField.text!, password: passWordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            SwiftSpinner.hide({
            if user != nil {
                let model = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("appAccess")
                self.tr_presentViewController(model, method: TRPresentTransitionMethod.TaaskyFlip(blurEffect: true))

            } else {
                // The login failed. Check error to see why.
                let errorString = error!.userInfo["error"] as? String
                _ = SCLAlertView().showError("Oops!", subTitle: errorString!)
                
            }
            })
        }

    }
    @IBAction func cancelAction(sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(callbackData: nil)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailTextField {
        passWordTextField.becomeFirstResponder()
        }
        else
        {
            passWordTextField.resignFirstResponder()
        }
        return true
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        emailTextField.animation = "shake"
        passWordTextField.animation = "shake"
        emailTextField.animate()
        passWordTextField.animate()
    }
}
