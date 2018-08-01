//
//  ViewController.swift
//  OnTheMap
//
//  Created by Bruno W on 19/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    //MARK: properties
    var annotations : [MKPointAnnotation]!
    var studentsLocation : [StudentLocation]!
    
    
    //MARK: Instance Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadLocationData()
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!, toOpen != ""{
                let urlString = HTTPTools.putHTTPOnUrlString(urlString: toOpen)
                app.open(URL(string: urlString)!, options: [:]) { (success) in
                    if success {
                        print ("Safari is open soccessful")
                    }else{
                        print ("Error: Safari is not open")
                    }
                }
            }
        }
    }
    
    // MARK: Load Data on the Map
    func loadLocationData(){
        self.studentsLocation = ParseClient.sharedInstance().StudentsLocation
        
        guard (self.studentsLocation != nil) else {
            return
        }
        
        self.annotations = [MKPointAnnotation]()
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        for student in self.studentsLocation{
            let lat = CLLocationDegrees(truncating: student.latitude)
            let long = CLLocationDegrees(truncating: student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName!) \(student.lastName!)"
            annotation.subtitle = student.mediaURL
            self.annotations.append(annotation)
        }
        self.mapView.addAnnotations(self.annotations)
    }
}

