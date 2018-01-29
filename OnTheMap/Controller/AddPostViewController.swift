//
//  AddPostViewController.swift
//  OnTheMap
//
//  Created by Neel Nishant on 22/01/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import UIKit
import MapKit

var lat = CLLocationDegrees()
var long = CLLocationDegrees()
let ButtonTitleToFind = "Find on Map"
let ButtonTitleToSubmit = "Submit"
var annotationString = ""

//var firstName = ""
//var lastName = ""
class AddPostViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    @IBOutlet weak var locationLabel: UITextField!
    
    @IBOutlet weak var findLocationBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var websiteLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tabBarController?.tabBar.isHidden = true
        locationLabel.delegate = self
        websiteLabel.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        findLocationBtn.setTitle(ButtonTitleToFind, for: .normal)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //TextFieldFunctions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // Processing request
    func zoomToLocation() {
        var region = MKCoordinateRegion()
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        region.center = center
        region.span = span
        mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude:long)
        annotation.coordinate = center
        annotation.title = annotationString
        mapView.addAnnotation(annotation)
        
    }
    func getUserdata() {
        UdacityClient.sharedInstance().taskForGETMethod { (success, error) in
            if success {
                self.submitPost()
            }
            else {
                self.createAlert(title: "Error", message: error!)
            }
        }
    }
    func submitPost() {
        ParseClient.sharedInstance().taskForPOSTMethod(annotationString: annotationString, websiteText: websiteLabel.text!) { (success, error) in
            if success {
                self.updatePostList()
            }
            else  {
                self.createAlert(title: "Error", message: error!)
            }
        }

    }
    
    func updatePostList () {
        StudentInformation.sharedInstance.students = [StudentData]()
//        appdelegate?.students = [StudentData]()
        ParseClient.sharedInstance().taskForGETMethod { (success, error) in
            if success {
                self.completePost()
            }
            else {
                self.createAlert(title: "Error", message: error!)
            }
        }
    }
    func completePost(){
        performUIUpdatesOnMain {
            self.activityView.stopAnimating()
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
    //Alert
    func createAlert(title: String, message: String){
        performUIUpdatesOnMain {
            if self.activityView.isAnimating {
                self.activityView.stopAnimating()
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //IBActions
    @IBAction func findLocationSubmit(_ sender: Any) {
        
            if findLocationBtn.currentTitle == ButtonTitleToFind {
                if !(locationLabel.text?.isEmpty)! && !(websiteLabel.text?.isEmpty)! {
                    
                    if (websiteLabel.text?.contains("https://"))! || (websiteLabel.text?.contains("http://"))!{
                        let geoCoder = CLGeocoder()
                        geoCoder.geocodeAddressString(locationLabel.text!, completionHandler: { (placemarks, error) in
                            guard let placemark = placemarks?.first else {
                                self.createAlert(title: "Error", message: "Could not geocode String")
                                return
                            }
                            lat = (placemark.location?.coordinate.latitude)!
                            long = (placemark.location?.coordinate.longitude)!
                            
                            annotationString = "\(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")"
                            print("\(lat) \(long)")
                            self.zoomToLocation()
                            self.findLocationBtn.setTitle(ButtonTitleToSubmit, for: .normal)
                            
                        })
                    }
                    else {
                        createAlert(title: "Error", message: "please include http(s):\\")
                    }
                    
                }
                else {
                    createAlert(title: "Error", message: "location or website field is empty")
                }
                
            }
            else {
                activityView.center = self.view.center
                activityView.startAnimating()
                self.view.addSubview(activityView)
                getUserdata()
            }
    }
   
}
