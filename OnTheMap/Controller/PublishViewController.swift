//
//  PublishViewController.swift
//  OnTheMap
//
//  Created by Bruno W on 23/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import Foundation
import UIKit
class PublishViewController: UIViewController {
    
    @IBOutlet weak var locationString : UITextField!
    @IBOutlet weak var link : UITextField!
    
    var studentLocation : StudentLocation!
    var update : Bool = false
    var countClicks : Int = 0
    
    override func viewDidLoad() {
        guard (studentLocation != nil) else {
            return
        }
        self.locationString.text = studentLocation.mapString
        self.link.text = studentLocation.mediaURL
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.countClicks = 0
    }
    
    @IBAction func cancelAction (_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationAction (_ sender: UIButton){
        let mvcal = self.storyboard?.instantiateViewController(withIdentifier: "MapLocationViewController") as! MapLocationViewController
        
        mvcal.address = self.locationString.text!
        mvcal.link = self.link.text!
        mvcal.update = self.update
        mvcal.studentLocation = self.studentLocation
        
        self.navigationController?.pushViewController(mvcal, animated: true)
    }
    
    @IBAction func hiddenfunctionAction(_ sender: UIButton) {
        self.countClicks += 1
        if self.countClicks == 10 {
            
            Alerts.yesNo(view: self, title: "Do you want delete atualy publish?", message: "") { (yes) in
                if yes{
                    ParseClient.sharedInstance().removeStudentLocation(objectId: self.studentLocation.objectId) { (success, results, error) in
                        if success {
                            Alerts.toast(view: self, message: "Publish Deleted!", speed: .short, completion: nil)
                        }else{
                            print(error!)
                            Alerts.toast(view: self, message: "Error to delete publish!", speed: .medium, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    
}
