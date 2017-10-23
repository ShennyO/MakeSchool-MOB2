//
//  TripsViewController.swift
//  Trip-Planner
//
//  Created by Sunny Ouyang on 10/14/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var User: User?
    var trips: [UserTrip] = []
    var userPassword: String?
    
    @IBOutlet weak var tripsTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let confirmedUser = User else {return}
        
        let basicAuthToken = BasicAuth.generateBasicAuthHeader(username: confirmedUser.email, password: userPassword!)
        
        //In here we should load up our array of trips
        
        Network.instance.fetch(route: Route.get_trip, token: basicAuthToken) { (data) in
            print(data)
            let jsonTrips = try? JSONDecoder().decode([UserTrip].self, from: data)
            
            print(String(describing: jsonTrips) + " dam")
            if let trip = jsonTrips {
                print("Fk two")
                
                
                self.trips = trip
                DispatchQueue.main.async {
                    self.tripsTableView.reloadData()
                }
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tripsTableView.dequeueReusableCell(withIdentifier: "tripCell") as! tripsTableViewCell
        cell.tripNameLabel.text = trips[indexPath.row].destination
        if trips[indexPath.row].completed == true {
            cell.completedLabel.text = "Completed"
        } else {
            cell.completedLabel.text = "In progress"
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "createNewTrip" {
                let newTripVC = segue.destination as? newTripViewController
                newTripVC?.loggedUser = self.User
                newTripVC?.password = self.userPassword
            }
        }
    }

   

}
