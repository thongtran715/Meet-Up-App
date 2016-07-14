//
//  AddViewController.swift
//  MapKitTutorial
//
//  Created by Thong Tran on 7/6/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import MapKit
import Parse
import KCFloatingActionButton
class AddViewController: UIViewController {
   
    @IBOutlet var nameOfUsers: UILabel!
    var photoTaking : PhotoTakingHelper?
    var arrayOfUsers = [PFUser]()
    func takePhoto () {
        photoTaking = PhotoTakingHelper(viewCol: self, callBack: { (image) in
            
            if let image = image {
                self.arrayOfImages.append(image)
                
            }
            
        })
    }
    func takeLibrary(){
       photoTaking = PhotoTakingHelper(viewCol: self, callBack1: { (image) in
        if let image = image {
            self.arrayOfImages.append(image)
        }
       })
    }
    var arrayOfString = [String]()
    var arrayOfImages = [UIImage]() {
        didSet {
           
           collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var topicTextField:UITextField!

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.topicTextField.becomeFirstResponder()
    }
    // Button Action
    @IBOutlet weak var doneOutlet: UIBarButtonItem!
    @IBAction func DoneButton(sender: AnyObject) {
        let post = Post()
        post.name.value = topicTextField.text
        post.location.value = addressTextField.text
        post.date.value = dateLabel.text
        post.uploadFile { (success) in
            
            if success {
                for image in self.arrayOfImages {
                    let imageHolderforPost = imageHolder()
                    imageHolderforPost.getImage = image
                    // adding image pointer to post
                    imageHolderforPost.fromPost = post
                    imageHolderforPost.uploadingPhoto()
                }
                for name in self.arrayOfUsers {
                    let getPostandUsersLinked = UserSharePost()
                    getPostandUsersLinked.toUser = name
                    getPostandUsersLinked.fromPost = post
                    getPostandUsersLinked.fromUser = post.user
                    getPostandUsersLinked.ACL?.setWriteAccess(true, forUser: name)
                    getPostandUsersLinked.saveInBackgroundWithBlock(nil)
                }
            }
        }
    }
  
    @IBAction func pinAddress(sender: AnyObject) {
        if selectedPin == nil
        {
            alert(extendMessage: "Error", extendTitle: "Address has not been chosen")
        }
        else
        {
            
            let name = (selectedPin?.name)! ?? ""
            let streetNumber = (selectedPin?.subThoroughfare) ?? ""
            let streetName = (selectedPin?.thoroughfare) ?? ""
            let city = (selectedPin?.locality) ?? ""
            let state = (selectedPin?.administrativeArea) ?? ""
            let country = (selectedPin?.country) ?? ""
            self.addressTextField.text = "\(name), \(streetNumber) \(streetName), \n \(city), \(state), \(country)"
        }
        
        
    }
    @IBAction func addPeople(sender: AnyObject) {
        
    }
    

    // Unwind the controller
    @IBAction func unwindBackAddViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }

    
    // Outlet
    @IBOutlet var scrollView: UIScrollView!
    var handleMapSearchDelegate:HandleMapSearch? = nil
    var  locationManager = CLLocationManager()
   
    @IBOutlet weak var addressTextField: UILabel!
    @IBOutlet weak var searchBarView: UIView!
 
    
    @IBOutlet var dateLabel: UILabel!
    var selectedPin:MKPlacemark? = nil
    @IBOutlet weak var mapView: MKMapView!
    
    var resultSearchController:UISearchController? = nil
    
    @IBAction func datePickerTapped(sender: AnyObject) {
        DatePickerDialog().show("Schedule the Meeting", doneButtonTitle: "Save", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            (date) -> Void in
            self.dateLabel.text = "\(date.convertToString())"
        }
    }
    
    var floatingButton = KCFloatingActionButton()
    
    override func viewDidLoad() {
        
        createFloatingButton()
        
        super.viewDidLoad()
        arrayOfImages.append(UIImage(named: "noImageAvailable")!)
        
        scrollView.contentSize.height = 10000
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search Place for the Meeting"
        searchBarView.addSubview((resultSearchController?.searchBar)!)
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
       
        
        
        // Do any additional setup after loading the view.
    }
   
    
    private func createFloatingButton()  {
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 16, width: 56, height: 56)
                floatingButton = KCFloatingActionButton(frame: floatingFrame)
        floatingButton.addItem("Take a Photo", icon: UIImage(named: "camera")!) { (action) in
            if self.arrayOfImages.contains(UIImage(named: "noImageAvailable")!)
            {
                self.arrayOfImages.removeAtIndex(0)
            }
            self.takePhoto()
        }
        floatingButton.addItem("Photo Library", icon: UIImage(named: "library")!) { (action) in
            if self.arrayOfImages.contains(UIImage(named: "noImageAvailable")!)
            {
                self.arrayOfImages.removeAtIndex(0)
            }
            self.takeLibrary()
        }
        floatingButton.addItem("Share with", icon: UIImage(named: "addUser-1")!) { (action) in
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("searchUser");            self.presentViewController(vc!, animated: true, completion: nil)
        }
        floatingButton.close()
        floatingButton.plusColor = UIColor.whiteColor()
        floatingButton.buttonColor = (UIColor(red: 0, green: 0.5, blue: 1, alpha: 1))
        self.view.addSubview(floatingButton)
    
    }
    
    
    
}

extension AddViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let UserLocation = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: UserLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        alert(extendMessage: "Error", extendTitle: "Can't load location. Please Check Your Location Settings")
    }
    func alert(extendMessage dataMessage: String, extendTitle dataTitle: String){
        
        let alertController = UIAlertController(title: dataMessage, message: dataTitle, preferredStyle: .Alert)
        let Cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(Cancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
}



extension AddViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea,
            let addressNumber = placemark.subThoroughfare,
            let street = placemark.thoroughfare
        {
            annotation.subtitle = "\(addressNumber) \(street), \(city), \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}


extension AddViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.redColor()  
        pinView?.canShowCallout = true
        return pinView
    }
}

extension AddViewController: UITextFieldDelegate {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.topicTextField.resignFirstResponder()
        return true
    }
}





extension AddViewController: UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImages.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionView", forIndexPath: indexPath) as! CollectionViewCell
        cell.imageView.image = arrayOfImages[indexPath.row]
        return cell
        
    }
}
extension AddViewController: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let gesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddViewController.tapClicked))
        cell?.userInteractionEnabled = true
        
        cell?.addGestureRecognizer(gesture)
    }
    
    
    func tapClicked() {
        print("OK")
        
    }
    
    
}

