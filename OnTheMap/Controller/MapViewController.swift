//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Neel Nishant on 17/01/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import UIKit
import MapKit

//var students = [StudentData]()
var annotations = [MKPointAnnotation]()

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
        performUIUpdatesOnMain {
            self.loadData()
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        loadMap()
    }
    
    func loadMap () {
        let locations = StudentInformation.sharedInstance.students
//        print(locations)
        
        for dictionary in locations {
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.url
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = "\(mediaURL)"
            
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
        activityView.stopAnimating()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    //open map
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func loadData () {
        
        ParseClient.sharedInstance().taskForGETMethod { (success, error) in
            if success {
                self.loadMap()
            }
            else {
                self.createAlert(title: "Error", message: error!)
            }
        }
    }
    
   
    func completeLogout() {
        performUIUpdatesOnMain {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
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
    
    @IBAction func logOutPressed(_ sender: Any) {
        UdacityClient.sharedInstance().taskForDeleteMethod { (success, error) in
            if success {
                self.completeLogout()
                print("logged out successfully")
            }
            else {
                self.createAlert(title: "Error", message: error!)
            }
        }
    }
    
    
}
