//
//  ViewController.swift
//  Trip-Planner
//
//  Created by Sunny Ouyang on 10/14/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginUser: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   
    //In here we'll handle the POST request for creating a new user. So we'll get the username and password from the textfield and then send the POST request to our server. The password gets hashed 
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        let basicToken = BasicAuth.generateBasicAuthHeader(username: email, password: password)
        
        Network.instance.fetch(route: Route.post_user(email: email, password: password), token: basicToken) { (data) in
            print(data)
//            
//            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//            print(json)
            
            print("Created User")
        }
        
    }
    
    //When the login button is tapped, we want to send a GET request. First we have to turn the email and password into a token, and pass them off in the authorization header of the request.
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toTrips" {
                let tripsVC = segue.destination as! TripsViewController
                tripsVC.User = loginUser as! User
                tripsVC.userPassword = passwordTextField.text
                
            }
        }
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        let basicToken = BasicAuth.generateBasicAuthHeader(username: email, password: password)
        
        //Now starting from here, we have to preform a GET request for the user object. If successful, we want to pass the user Object to our tripsViewController. Maybe by using delegate?
        
       
        //This request has to have the proper credentials to get back the correct data, we provide the request with credentials with our authorization and parameters.
        Network.instance.fetch(route: Route.get_user, token: basicToken) { (data) in
            
            
            //we decoded the data from the GET request
            let jsonUser = try? JSONDecoder().decode(User.self, from: data)
            
           
            
            if let user = jsonUser {
               
                self.loginUser = user
                print("Login Success")
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toTrips", sender: self)

                }
               
            }
            
        }
        
    }
    
}

