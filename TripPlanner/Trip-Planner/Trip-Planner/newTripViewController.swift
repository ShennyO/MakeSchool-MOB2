//
//  newTripViewController.swift
//  Trip-Planner
//
//  Created by Sunny Ouyang on 10/18/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit

class newTripViewController: UIViewController {
    
    var loggedUser: User?
    
    var password: String?

    @IBOutlet weak var destinationTextField: UITextField!
    
    @IBOutlet weak var startDateTextField: UITextField!
    
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBOutlet weak var completedSwitch: UISwitch!
    
    //In here, we make a post request for a new trip and we pass in the required fields in the body of the request. 
    @IBAction func addButton(_ sender: Any) {
        
        let token = BasicAuth.generateBasicAuthHeader(username: ((self.loggedUser?.email))!, password: self.password!)
        
        Network.instance.fetch(route: Route.post_trip(email: (self.loggedUser?.email)!, destination: destinationTextField.text!, startDate: startDateTextField.text!, endDate: endDateTextField.text!, waypoints: [], completed: completedSwitch.isOn), token: token) { (data) in
            print("Created New Trip")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
