//
//  LoginViewController.swift
//  Book Club
//
//  Created by Cynthia Whitlatch on 12/31/15.
//  Copyright © 2015 Cynthia Whitlatch. All rights reserved.
//


import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth



class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let buttonBorder = UIColor.white.cgColor
    let buttonColor = UIColor(red: 40/255, green: 141/255, blue: 255/255, alpha: 0.5).cgColor

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customButtons()
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            print("User needs to Register")
            let userEmail = self.userEmailTextField.text!
            let alertView = UIAlertController(title: "No record of \(userEmail)",
                                              message: "You must register first" as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Try Again!", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
            
        } else {
            
            checkIfUserIsLoggedIn()            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        customButtons()
        
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
                print(snapshot)
                
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController")
                self.present(homeViewController, animated: true, completion: nil)


            })
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        let userEmail = self.userEmailTextField.text!
        let userPassword = self.userPasswordTextField.text!
        
        if userEmail != "" || userPassword != "" {
            validateEmail()
            userLoggedIn()

        } else {
            
            let alertView = UIAlertController(title: "Login Problem",
                                              message: "You must enter an email and password" as String,preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Try Again!", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    @IBAction func RegisterButtonPressed(_ sender: AnyObject) {
        let userEmail = self.userEmailTextField.text!
        let userPassword = self.userPasswordTextField.text!
        
        if userEmail != "" || userPassword != "" {
            validateEmail()
            userRegistered()

        } else {
            
            let alertView = UIAlertController(title: "Registration Problem",
                                              message: "You must enter an email and password" as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Try Again!", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)

        }
        
    }
    
    func userLoggedIn() {
        let userEmail = self.userEmailTextField.text!
        let userPassword = self.userPasswordTextField.text!
        
        FIRAuth.auth()?.signIn(withEmail: userEmail, password: userPassword, completion: { (user, error) in
            if error != nil {
                print("You must register first")
                
                let alertView = UIAlertController(title: "No record of \(userEmail)",
                    message: "You must register first" as String, preferredStyle:.alert)
                let okAction = UIAlertAction(title: "Please try Again!", style: .default, handler: nil)
                alertView.addAction(okAction)
                self.present(alertView, animated: true, completion: nil)

                
            } else {
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController")
                self.present(homeViewController, animated: true, completion: nil)
            }
        })
        
    }
    
    func userRegistered() {
        let userEmail = self.userEmailTextField.text!
        let userPassword = self.userPasswordTextField.text!

        FIRAuth.auth()?.createUser(withEmail: userEmail, password: userPassword, completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController")
            self.present(homeViewController, animated: true, completion: nil)
            
            print("User Successfully Registered")
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = FIRDatabase.database().reference(fromURL: "https://bookclub-7c48c.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["email" : userEmail, "password": userPassword]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print("You have an ERROR")
                    
                }
                
                print("SUCCESS, you have added a user, email and password to database")
            })
        })
    }
    
    func validateEmail() -> Bool {
        let userEmail = self.userEmailTextField.text!
        
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: [])
            if regex.firstMatch(in: userEmail, options: [], range: NSMakeRange(0, userEmail.characters.count)) != nil {
                print("valid")
            } else {
                print("not valid")
                
                let alertView = UIAlertController(title: "Invalid Email",
                                                  message: "You must enter a valid Email Address" as String, preferredStyle:.alert)
                let okAction = UIAlertAction(title: "Try Again!", style: .default, handler: nil)
                alertView.addAction(okAction)
                self.present(alertView, animated: true, completion: nil) }
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
    }
        return true
}

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func customButtons() {
        userEmailTextField.layer.borderColor = buttonBorder
        userEmailTextField.layer.backgroundColor  = buttonColor
        userEmailTextField.layer.borderWidth = 1
        userEmailTextField.layer.cornerRadius = 10
        
        userPasswordTextField.layer.borderColor = buttonBorder
        userPasswordTextField.layer.backgroundColor  = buttonColor
        userPasswordTextField.layer.borderWidth = 1
        userPasswordTextField.layer.cornerRadius = 10
        
        loginButton.layer.borderColor = buttonBorder
        loginButton.layer.backgroundColor  = buttonColor
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 10
        
        registerButton.layer.borderColor = buttonBorder
        registerButton.layer.backgroundColor  = buttonColor
        registerButton.layer.borderWidth = 1
        registerButton.layer.cornerRadius = 10
    }
}

