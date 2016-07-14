//
//  webViewController.swift
//  Meet Up
//
//  Created by Thong Tran on 7/14/16.
//  Copyright © 2016 ThongApp. All rights reserved.
//

import UIKit

class webViewController: UIViewController {

    var url : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
        let getDestinationURL = NSURL(string: url)
        let requestUrl = NSURLRequest(URL: getDestinationURL!)
        webView.loadRequest(requestUrl)
        }
}

    @IBOutlet var webView: UIWebView!
}
