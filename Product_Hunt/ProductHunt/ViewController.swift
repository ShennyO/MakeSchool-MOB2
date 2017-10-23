//
//  ViewController.swift
//  ProductHunt
//
//  Created by Sunny Ouyang on 9/24/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit
import Kingfisher 


class ViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView!
    
    var productHuntList = [Product]() {
        didSet {
            DispatchQueue.main.async {
                self.productsTableView.reloadData()
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      
        Network.instance.fetch(route: Route.post) { (allPosts) in
            let productHunt = try? JSONDecoder().decode(ProductList.self, from: allPosts)
            guard let newPosts = productHunt?.posts else{return}
            self.productHuntList = newPosts
        }
        
//        DispatchQueue.main.async {
//
//            self.productsTableView.reloadData()
//
////            Networking.getPosts(completion: { (products) in
////
////                self.productHuntList = products
////                //print(self.productHuntList)
////
////            })
//        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (productHuntList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PHCell", for: indexPath) as! PHTableViewCell
        cell.NameLabel.text = productHuntList[indexPath.row].name
        cell.taglineLabel.text = productHuntList[indexPath.row].tagline
        cell.votesLabel.text = String(describing: productHuntList[indexPath.row].votes!)
        let imageURL = URL(string: productHuntList[indexPath.row].imageURL!)
        cell.productImage.kf.setImage(with: imageURL)
        
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let product = productHuntList[indexPath.row]
//        let postID = product.id
//        
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let detail = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsViewController
//        detail.id = postID
//        navigationController?.pushViewController(detail, animated: true)
//        
//    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toComments" {
                let cell = sender as! UITableViewCell
                let indexPath = productsTableView.indexPath(for: cell)
                let detailsVC = segue.destination as! DetailsViewController
                print(self.productHuntList[(indexPath?.row)!].id!)
                detailsVC.id = self.productHuntList[(indexPath?.row)!].id!
                print(self.productHuntList[(indexPath?.row)!].id!)
            }
        }
    }
    
    
}

