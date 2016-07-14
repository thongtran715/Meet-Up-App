//
//  TimeLineViewController.swift
//  Meet Up
//
//  Created by Thong Tran on 7/13/16.
//  Copyright © 2016 ThongApp. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MapKit
import AlamofireImage
import AlamofireNetworkActivityIndicator

class TimeLineViewController: UIViewController {
    var totalNumberOfEvents : [event] = []
    var menuView: BTNavigationDropdownMenu!
    let locationManager = CLLocationManager()
    @IBOutlet var tableView: UITableView!
    var indicator:ProgressIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getJsonOriginalData()
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        ////////////////////////////////////////////////////////////////////////////////////////////
        let items = ["General", "Sports", "Food and Drink", "Technology", "Arts", "Health", "Sports and Fitness", "Music", "Business", "Charity and Causes", "Family and Education", "Travel and Outdoor", "Home and Lifestyle", "Film and Media", "Fashion", "Holiday", "Government"]
        // self.selectedCellLabel.text = items.first
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items[0], items: items)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.keepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .Left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            self.totalNumberOfEvents.removeAll()
            self.getJsonUpdateData(items[indexPath])
            // self.tableView.reloadData()
        }
        self.navigationItem.titleView = menuView
    }
    
    
    
    func getJsonOriginalData() {
        let apiToContact = "https://www.eventbriteapi.com/v3/events/search/?token=UXY7CC7P3UR2DVUOMWLZ&expand=venue"
        
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.grayColor(), indicatorColor: UIColor.blackColor(), msg: "Loading events data from the server")
        self.view.addSubview(indicator!)
        indicator?.start()
        
        
        // Create and add the view to the screen.
        
        // All done!
        
        self.view.backgroundColor = UIColor.blackColor()
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
                
            case .Success:
                //self.activityIndicator.stopAnimating()
                self.indicator?.stop()
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let allEvents = json["events"].arrayValue
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        for events in allEvents {
                            
                            self.totalNumberOfEvents.append(event(json: events))
                            
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                        })
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
        
        
    }
    
    func getJsonUpdateData(string: String) {
//        
//        let apiToContact = " https://www.eventbriteapi.com/v3/events/search/?q=\(string.stringByReplacingOccurrencesOfString(" ", withString: "+"))&token=UXY7CC7P3UR2DVUOMWLZ&expand=venue"
//        
       let apiToContact = "https://www.eventbriteapi.com/v3/events/search/?q=\(string.stringByReplacingOccurrencesOfString(" ", withString: "+"))&token=UXY7CC7P3UR2DVUOMWLZ&expand=venue"
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.grayColor(), indicatorColor: UIColor.blackColor(), msg: "Loading events data from the server")
        self.view.addSubview(indicator!)
        indicator?.start()
        
        
        // Create and add the view to the screen.
        
        // All done!
        
        self.view.backgroundColor = UIColor.blackColor()
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
                
            case .Success:
                //self.activityIndicator.stopAnimating()
                self.indicator?.stop()
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let allEvents = json["events"].arrayValue
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        for events in allEvents {
                            
                            self.totalNumberOfEvents.append(event(json: events))
                            
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                        })
                    }
                    
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    
    
    
    
}

extension TimeLineViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
extension TimeLineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalNumberOfEvents.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("timeLineEventCell") as! TimeLinetableviewCell
        cell.topicName.text = totalNumberOfEvents[indexPath.row].topicOfEvent
        let dateString = totalNumberOfEvents[indexPath.row].timeOfEvent
        cell.timeEvent.text = DateFormatter.convertDate(dateString)
        cell.whereTheEvent.text = totalNumberOfEvents[indexPath.row].locationOfEvent
        cell.imageOfEvent.af_setImageWithURL(NSURL(string: totalNumberOfEvents[indexPath.row].image)!)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
            if identifier == "showWebView" {
                if let webCol = segue.destinationViewController as? webViewController {
                    let index = tableView.indexPathForSelectedRow!
                    webCol.url = totalNumberOfEvents[index.row].url
                    
                }
                
            }
            
        }
    }
    
    
}