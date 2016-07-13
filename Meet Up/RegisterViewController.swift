//
//  RegisterViewController.swift
//  Meet Up
//
//  Created by Thong Tran on 7/10/16.
//  Copyright © 2016 ThongApp. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation
class RegisterViewController: UIViewController, ModalTransitionDelegate {
var tr_presentTransition: TRViewControllerTransitionDelegate?
    weak var modalDelegate: ModalViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelButton(sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(callbackData: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
