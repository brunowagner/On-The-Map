//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Bruno W on 21/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    //MARK: Properties
    var studentsLocation : [StudentLocation]!
    
    //MARK: Instance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadLocationData()
    }
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsLocation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        let name = "\(studentsLocation[indexPath.row].firstName!) \(studentsLocation[indexPath.row].lastName!)"
        let link = "\(studentsLocation[indexPath.row].mediaURL!)"
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = link
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let link = studentsLocation[indexPath.row].mediaURL, link != "" else{
            return
        }
        let app = UIApplication.shared
        let urlString = HTTPTools.putHTTPOnUrlString(urlString: link)
        app.open(URL(string: urlString)!, options: [:]) {(success) in
            if success {
                print ("Safari is open successful")
            }else{
                print ("Error: Safari is not open")
            }
        }
    }
    
    func loadLocationData(){
        self.studentsLocation = ParseClient.sharedInstance().StudentsLocation
        if self.studentsLocation==nil {
            self.studentsLocation = [StudentLocation]()
            return
        }
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
}
