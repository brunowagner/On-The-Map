//
//  MapLocationViewController.swift
//  OnTheMap
//
//  Created by Bruno W on 23/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import UIKit
import MapKit
class MapLocationViewController: UIViewController, MKMapViewDelegate {
    
    //Mark: Properties
    
    var annotations : [MKPointAnnotation]!
    var update : Bool = false
    var address : String = ""
    var link : String = ""
    var latitude : NSNumber = 0
    var longitude : NSNumber = 0
    var studentLocation : StudentLocation!
    
    //Mark: IBOutlets
    
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var finishButton : UIButton!
    
    //Mark: Instance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findAdress(address: self.address)
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
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:]) { (success) in
                    if success {
                        print ("Safari is open soccessful")
                    }else{
                        print ("Error: Safari is not open")
                    }
                }
            }
        }
    }
    
    //Mark: IBAction
    
    @IBAction func finishAction (_ sender: UIButton){
        if self.update{
            self.updateLocation()
        }else{
            self.publishLocation()
        }
    }
    
    //Mark: Location Methods
    
    func findAdress(address : String){
        
        self.isWaitingProcess(true)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            
            self.isWaitingProcess(false)
            
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    
                    self.enableView(false)
                    
                    let error = error! as NSError
                    switch error.code{
                    case 2:
                        Alerts.message(view: self, title: nil, message: "Unrealized search!\nCheck your connection.")
                        break
                    case 8:
                        Alerts.message(view: self, title: nil, message:"Location not found!")
                        break
                    default:
                        Alerts.message(view: self, title: nil, message:"The search can not be done!")
                    }
                    return
            }
            performUIUpdatesOnMain {
                self.loadLocation(location:location)
            }
        }
    }
    
    private func loadLocation(location: CLLocation){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        
        annotation.title = address
        
        self.annotations = [MKPointAnnotation]()
        self.annotations.append(annotation)
        
        //center centerCoordinate on view
        self.mapView.centerCoordinate = annotation.coordinate
        
        //set zoom in
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(annotation.coordinate, span)
        self.mapView.setRegion(region, animated: true)
        
        //Add location on map
        self.mapView.addAnnotations(self.annotations)
        
        //Set properties with coordenates
        self.latitude = NSNumber(floatLiteral: Double(annotation.coordinate.latitude))
        self.longitude = NSNumber(floatLiteral: Double(annotation.coordinate.longitude))
    }
    
    private func publishLocation(){
        let uniqueKey = UdacityClient.sharedInstance().userDataUdacity.key
        let firstName = UdacityClient.sharedInstance().userDataUdacity.firstName
        let lastName = UdacityClient.sharedInstance().userDataUdacity.lastName
        
        self.isWaitingProcess(true)
        
        ParseClient.sharedInstance().publishLocation(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: self.address, mediaURL: self.link, latitude: self.latitude, longitude: self.longitude) { (success, results, error) in
            
            self.isWaitingProcess(false)
            
            if success{
                Alerts.toast(view: self, message: "Location Published!", speed: .long){
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }else{
                Alerts.message(view: self, title: "Publish Error!", message: "Did not possible publish location")
            }
        }
    }
    
    private func updateLocation(){
        self.studentLocation.latitude = self.latitude
        self.studentLocation.longitude = self.longitude
        self.studentLocation.mediaURL = self.link
        self.studentLocation.mapString = self.address
        
        self.isWaitingProcess(true)
        
        ParseClient.sharedInstance().updateLocation(objectId: self.studentLocation.objectId, studentLocation: self.studentLocation) { (success, updatedAt, errorString) in
            
            self.isWaitingProcess(false)
            
            performUIUpdatesOnMain {
                if success {
                    Alerts.toast(view: self, message: "Location Published!", speed: .long){
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                }else{
                    Alerts.message(view: self, title: "Publish Error!", message: "Did not possible publish location")
                }
            }
        }
    }
    
    //MARK: Methods of view`s state
    
    func isWaitingProcess(_ bool: Bool){
        self.showLoadingIndicator(bool)
        self.enableView(!bool)
    }
    
    func showLoadingIndicator (_ show : Bool ){
        performUIUpdatesOnMain {
            if show{
                LoadingOverlay.shared.showOverlay(view: self.view)
            }else{
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }
    
    func enableView(_ enable : Bool){
        performUIUpdatesOnMain {
            self.navigationItem.backBarButtonItem?.isEnabled = enable
            self.finishButton.isEnabled = enable
        }
    }
}
