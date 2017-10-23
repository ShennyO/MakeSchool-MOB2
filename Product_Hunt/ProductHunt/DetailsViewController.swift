//
//  DetailsViewController.swift
//  ProductHunt
//
//  Created by Sunny Ouyang on 9/26/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    var comments = [Comment]() {
        didSet {
            DispatchQueue.main.async {
                self.commentsTableView.reloadData()
            }
        }
    }
        
    
    var id: Int = 0

    
    //when we call the fetch request for the comments, we also need to pass the id of the cell we selected. We passed the id through the var id above. 
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("id: \(self.id!)")

        
        let stringID = String(describing: id)
        
        Network.instance.fetch(route: Route.comments(id: String(describing: id))) { (data) in
            //in here we want to populate our comments array above
            let jsonComments = try? JSONDecoder().decode(commentList.self, from: data)
            guard let commentList = jsonComments?.comments else {return}
            self.comments = commentList
            
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "commentsCell")
        
        cell?.textLabel?.text = comments[indexPath.row].body
        
        return cell!
    }

}
