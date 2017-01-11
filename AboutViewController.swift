//
//  AboutViewController.swift
//  BookClub
//
//  Created by Cynthia Whitlatch on 6/23/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase


class AboutViewController: UIViewController {

    var clubInfo = [User]()

    let buttonBorder = UIColor.white.cgColor
    let buttonColor = UIColor(red: 40/255, green: 141/255, blue: 255/255, alpha: 0.5).cgColor
    
    @IBOutlet weak var clubMeetingDateTimeLocation: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        customButtons()
        fetchAboutClubText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchAboutClubText()
    }

    func fetchAboutClubText() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.aboutLabel.text = dictionary["aboutclub"] as? String
                    self.clubMeetingDateTimeLocation.text = dictionary["clubdatetimelocatin"] as? String

                }
                print(snapshot)
                
                }, withCancel: nil)
        }
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    func customButtons() {
        doneButton.layer.borderColor = buttonBorder
        doneButton.layer.backgroundColor  = buttonColor
        doneButton.layer.borderWidth = 1
        doneButton.layer.cornerRadius = 10
        }
    }
