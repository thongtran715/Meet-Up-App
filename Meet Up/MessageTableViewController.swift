//
//  MessageTableViewController.swift
//  MapKitTutorial
//
//  Created by Thong Tran on 7/6/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import Parse
import MapKit

class MessageTableViewController: UITableViewController {
    
    
    var posts = [Post]()
    
    
    var postId = [String]()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func refresh() {
//        
        
        
      
        ParseHelper.getMessageFromCurrentUser { (result: [PFObject]?, error: NSError?) in

            self.posts = result as? [Post] ?? []
            
            ParseHelper.getMessageFromOthersUser { (results, error) in
                if let results = results as? [UserSharePost]
                {
                    for result in results {
                        let getPost = Post.query()
                        getPost?.whereKey("objectId", equalTo: (result.fromPost?.objectId!)!)
                        getPost?.includeKey("user")
                        
                        let postArray = try! getPost?.findObjects()
                        let post = postArray?.first as! Post
                        self.posts.append(post)
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  print("MessageTableViewController - numberOfRowsInSection: \(posts.count)")
        return posts.count
    }
    @IBAction func unwindToMessageTableViewController(segue: UIStoryboardSegue) {
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //  print("MessageTableViewController - cellForRowAtIndexPath: \(indexPath)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellofNote", forIndexPath: indexPath) as! MessageTableViewCell
        let row = indexPath.row
        let fetch = posts[row]
        if row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 0.1)
        }else {cell.backgroundColor = UIColor.whiteColor()}
        
        tableView.rowHeight = 140
        fetch.downloadFiles()
        cell.post = fetch
        
        return cell
    }
    
    @IBAction func unwindDoneMessageTableViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // Deleting the post
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Delete") { (action, index) in
            let alertView = SCLAlertView()
            alertView.showCloseButton = false
            
            let deleteFile = self.posts[index.row]
            
            if deleteFile.user == PFUser.currentUser(){
                alertView.addButton("Delete", action: {
                    ParseHelper.deleteImages(deleteFile)
                        deleteFile.deleteInBackgroundWithBlock({ (success, error) in
                        if success {
                            self.refresh()
                        }
                        else
                        {
                            _ = SCLAlertView().showError("Oops!", subTitle: (error?.localizedDescription)!)
                            
                        }
                    })
                })
                
                alertView.addButton("Cancel", action: {
                })
                alertView.showWarning("Warning", subTitle: "Deleting this post will unable your friends to access this post. Do you want to delete?")
            }
            else
            {
                // Posts are not posted by this user
                print(deleteFile.user!)
                print(PFUser.currentUser()!)
                ParseHelper.unRelatedToShare(PFUser.currentUser()!, post: deleteFile, fromUser: deleteFile.user!)
                self.refresh()
            }
            
            
        }
        delete.backgroundColor = UIColor.redColor()
        // Detail of the posts
        let navigate = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Go There") { (action, index) in
            let fectching = self.posts[index.row]
            let data = try! fectching.locationFile!.getData()
            let dataString = String(data: data, encoding: NSUTF8StringEncoding)
            var addressofString = dataString!.componentsSeparatedByString(", ")
            addressofString.removeAtIndex(0)
            let getaddress = addressofString.joinWithSeparator(", ")
            let address = getaddress.stringByReplacingOccurrencesOfString("\n ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            print(address)
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if let placemark = placemarks!.first {
                    
                    let location = CLLocation(latitude: (placemark.location?.coordinate.latitude)!, longitude: (placemark.location?.coordinate.longitude)!)
                    CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                        
                        if placemark?.count > 0
                        {
                            dispatch_async(dispatch_get_main_queue(), {
                                let pinForAppleMaps = placemark![0] as CLPlacemark
                                print(pinForAppleMaps.subThoroughfare)
                                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: pinForAppleMaps.location!.coordinate, addressDictionary: pinForAppleMaps.addressDictionary as! [String:AnyObject]?))
                                
                                let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                                mapItem.openInMapsWithLaunchOptions(launchOptions)
                            })
                        }
                    }
                    
                    
                    //self.presentViewController(vc, animated: true, completion: nil)
                    //self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                }
            })
            
            
        }
        navigate.backgroundColor = UIColor.greenColor()
        
        return [delete, navigate]
    }
    
}





