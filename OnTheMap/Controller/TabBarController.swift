//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Bruno W on 23/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import Foundation
import UIKit
class TabBarController : UITabBarController{
    
    //MARK: Instance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigatorBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshAction()
    }
    
    //MARK: Actions
    
    @objc func logout(){
        UdacityClient.sharedInstance().logout { (success, results, error) in
            performUIUpdatesOnMain {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc func refreshAction(){
        
        self.isWaitingProcess(true)
        
        ParseClient.sharedInstance().getStudentsLocation(limit: 100, order: "-\(ParseClient.JSONKeys.StudentLocation.updatedAt)") { (success, studentsLocation, error) in
            
            self.isWaitingProcess(false)
            
            performUIUpdatesOnMain {
                if success{
                    let mapViewController = self.viewControllers![0] as! MapViewController
                    let tableViewController = self.viewControllers![1] as! TableViewController
                    mapViewController.loadLocationData()
                    tableViewController.loadLocationData()
                }else{
                    print(error!)
                    Alerts.message(view: self, title: "Locations`s data can not be downloads!", message: "")
                }
            }
        }
    }
    
    @objc func addPinAction(){
        
        isWaitingProcess(true)

        // search by register on Parse
        ParseClient.sharedInstance().findPublish(uniqueKey: UdacityClient.sharedInstance().userDataUdacity.key) { (success, studentLocation, errString) in
            
            performUIUpdatesOnMain {
                
                self.isWaitingProcess(false)
                
            // if search return error
            guard success else{
                Alerts.message(view: self, title: "Publish unavailble!", message: "\nIs not possible access the service.")
                return
            }
            
            // if already have a publication
            guard studentLocation == nil else{

                // ask if want change
                self.isChangePublish(handler: { (change) in
                    if change {
                        self.performSegue(withIdentifier: "segueTabsToPublishView", sender: studentLocation)
                    }
                })
                return
            }
            
            //if no publish found
            self.performSegue(withIdentifier: "segueTabsToPublishView", sender: studentLocation)
        }
        }
    }
    
    //MARK: Auxiliar Methods
    
    //function to ask if user want change your actual location
    func isChangePublish( handler : @escaping (_ change : Bool)-> Void ){
        Alerts.yesNo(view: self, title: "You already have a publication!", message: "Do you want to change your publish?", completionHander: handler)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? StudentLocation else{
            return
        }
        if let navigationController = segue.destination as? UINavigationController{
            let publishViewController = navigationController.viewControllers[0] as! PublishViewController
            publishViewController.studentLocation = sender
            publishViewController.update = true
        }
    }
    
    //MARK: Methods of view`s state
    
    func configureNavigatorBar(){
        // add left button
        let leftButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        self.navigationItem.leftBarButtonItem = leftButton
        
        // add right buttons
        let btnRefresh = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refreshAction))
        let btnAddPin = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addPinAction))
        self.navigationItem.rightBarButtonItems = [btnAddPin , btnRefresh]
    }
    
    func isWaitingProcess(_ bool: Bool){
        performUIUpdatesOnMain {
            self.showLoadingIndicator(bool)
            self.enableView(!bool)
        }
    }
    
    func showLoadingIndicator (_ show : Bool ){
        if show{
            LoadingOverlay.shared.showOverlay(view: self.view)
        }else{
            LoadingOverlay.shared.hideOverlayView()
        }
    }
    
    func enableView(_ enable : Bool){
        self.navigationItem.leftBarButtonItem?.isEnabled = enable
        for b in (self.navigationItem.rightBarButtonItems)! {
            b.isEnabled = enable
        }
    }
}
