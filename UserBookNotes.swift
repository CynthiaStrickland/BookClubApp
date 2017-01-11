//
//  UserBookNotes.swift
//  BookClub
//
//  Created by Cynthia Whitlatch on 6/5/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit

class UserBookNotes: UIViewController, UITextFieldDelegate {

    
    let buttonBorder = UIColor.white.cgColor
    let buttonColor = UIColor(red: 40/255, green: 141/255, blue: 255/255, alpha: 0.5).cgColor
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var userBookNotes: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    @IBAction func saveNote(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        userBookNotes.resignFirstResponder()
        return true
    }
    
    
    
    func customButtons() {
        cancelButton.layer.borderColor = buttonBorder
        cancelButton.layer.backgroundColor  = buttonColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 10
        
        saveButton.layer.borderColor = buttonBorder
        saveButton.layer.backgroundColor  = buttonColor
        saveButton.layer.borderWidth = 1
        saveButton.layer.cornerRadius = 10
    }

}
