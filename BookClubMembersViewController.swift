//
//  BookClubMembersViewController.swift
//  BookClub
//
//  Created by Cynthia Whitlatch on 7/14/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit
import Firebase


class BookClubMembersViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black

        fetchUser()
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: String] {
                let user = User()
//              user.setValuesForKeysWithDictionary(dictionary)
                user.email = (dictionary["email"])!      //Safer way
                user.membername = (dictionary["membername"])!
                user.profileImageUrl = (dictionary["profileImageUrl"])!
    
                    //******** Your app with crash using setValuesForKeysWithDictionary if your class properties don't exactly exactly match up with the FIREBASE dictionary keys unless you do it using the above code  ********
                
                self.users.append(user)
                
                    //******** This will crash because of background thread, so lets use dispatch async ******
                
                DispatchQueue.main.async(execute: { 
                    self.tableView.reloadData()

                })
                print(snapshot)
                print(user.email as Any, user.membername as Any)
            }
        }, withCancel: nil)
    }

    func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberlist", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        cell.detailTextLabel?.text = user.membername
        cell.imageView!.image = UIImage(contentsOfFile: user.profileImageUrl!)
        
        return cell
        
        }
}
