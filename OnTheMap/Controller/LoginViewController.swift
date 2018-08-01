//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Bruno W on 20/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    
    //MARK: IBOutlets
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    //MARK: Instance Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigateBar(true)
        self.enableView(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.hideNavigateBar(false)
    }
    
    //MARK: IBActions
    @IBAction func loginAction(_ sender: UIButton) {
        
        self.enableView(false)
        self.showLoadingIndicator(true)
        
        UdacityClient.sharedInstance().login(email: self.email.text!, password: self.password.text!) { (success, userKey, error) in
            

                self.showLoadingIndicator(false)
                if success {
                    //Store "userKey" to future searchs
                    UdacityClient.sharedInstance().userKey = userKey
                    
                    //search loged user data and store in a struct
                    self.findUserDataUdacityAndGotToMap(userKey: userKey!)
                    
                }else{
                    self.treatsLoginError(error: error)
                    self.enableView(true)
                }

        }
    }
    
    @IBAction func signupAction(_ sender: UIButton) {
        let app = UIApplication.shared
        let urlString = "https://auth.udacity.com/sign-up"
        app.open(URL(string: urlString)!, options: [:]) {(success) in
            if success {
                print ("Safari is open successful")
            }else{
                print ("Error: Safari is not open")
            }
        }
    }
    
    
    //MARK: Methods of view`s state
    func hideNavigateBar (_ choose : Bool ){
        self.navigationController?.navigationBar.isHidden = choose
    }
    
    func enableView(_ enable : Bool){
        performUIUpdatesOnMain(){
            self.email.isEnabled = enable
            self.password.isEnabled = enable
            self.askLabel.isEnabled = enable
            self.loginButton.isEnabled = enable
            self.signupButton.isEnabled = enable
        }
    }
    
    func showLoadingIndicator (_ show : Bool ){
        performUIUpdatesOnMain(){
            if show{
                LoadingOverlay.shared.showOverlay(view: self.view)
            }else{
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }
    
    //MARK: complementary Methods of login
    
    func findUserDataUdacityAndGotToMap(userKey : String?){
        
        UdacityClient.sharedInstance().findUser(Key: userKey!, completionHandlerForFind: { (success, results, error) in
            if success {
                UdacityClient.sharedInstance().userDataUdacity = UserDataUdacity(dictionary: results!)
                self.goToMap()
            }else{
                self.treatsLoginError(error: error)
            }
        })
    }
    
    func goToMap(){
        performUIUpdatesOnMain(){
            let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            self.navigationController?.pushViewController(mapViewController!, animated: true)
        }
    }
    
    func treatsLoginError(error : NSError?){
        guard error != nil else{
            return
        }
        let title : String
        let message: String
        
        switch error?.code{
        case ErrorTratament.ErrorCode.The_request_timed_out.rawValue:
            title = "Access to server not possible"
            message = "Not poosible connect servers!\nVerify your quality Network!"
            break
        case ErrorTratament.ErrorCode.The_Internet_connection_appears_to_be_offline.rawValue:
            title = "The Internet connection appears to be offline!"
            message = "\nVerify you connection."
            break
        case ErrorTratament.ErrorCode.Response_statusCode_403_Forbidden.rawValue:
            title = "Login Error!"
            message = "\nUser or password invalid."
            break
        default:
            title = "Error unknow!"
            message = "Impossible login!"
            print(error!)
            break
        }
        Alerts.message( view: self, title: title, message: message)
    }
}
