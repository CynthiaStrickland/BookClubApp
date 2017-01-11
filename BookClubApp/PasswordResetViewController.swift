//  PasswordResetViewController.swift
//  Book Club
//
//  Created by Cynthia Whitlatch on 12/31/15.
//  Copyright © 2015 Cynthia Whitlatch. All rights reserved.
//

import UIKit

class PasswordResetViewController: UIViewController {
    
    
    let buttonBorder = UIColor.white.cgColor
    let buttonColor = UIColor(red: 40/255, green: 141/255, blue: 255/255, alpha: 0.5).cgColor
    
    let ref = FIRDatabase.database().reference()

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func changePasswordPressed(_ sender: AnyObject) {
        let userInput = emailAddress.text
        
        if userInput == "" {
            let alertView = UIAlertController(title: "Error", message: "A valid email is required" as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Try Again!", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
        
        } else {
    
                FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        
                        return
                    }
                    
                    print("success")
            }
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        }
    
    func customButtons() {
        emailAddress.layer.borderColor = buttonBorder
        emailAddress.layer.backgroundColor  = buttonColor
        emailAddress.layer.borderWidth = 1
        emailAddress.layer.cornerRadius = 10
        
        sendButton.layer.borderColor = buttonBorder
        sendButton.layer.backgroundColor  = buttonColor
        sendButton.layer.borderWidth = 1
        sendButton.layer.cornerRadius = 10
    }
    }


