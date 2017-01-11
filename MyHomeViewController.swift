//
//  MyHomeViewController.swift
//  BookClub
//
//  Created by Cynthia Whitlatch on 5/27/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//
import CoreFoundation
import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth



class MyHomeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var bookTitle : String?
    var author : String?
    var image : UIImage?
    var base64String : NSString = ""
    var memberSince : String?
    var memberAboutMe: String?
    
    var booksRead = [Books]()
    var users = [User]()


    let buttonBorder = UIColor.white.cgColor
    let buttonColor = UIColor(red: 40/255, green: 141/255, blue: 255/255, alpha: 0.5).cgColor

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var logout: UIButton!
    
    @IBOutlet weak var saveMemberName: UIButton!
    @IBOutlet weak var memberName: UITextField!
    @IBOutlet weak var bookReadTV: UITableView!
    @IBOutlet weak var booksReadLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        customButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func saveMemberName(_ sender: AnyObject) {

        let nameOfMember = self.memberName.text
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("users").child(uid!)
        let values = ["membername" : "\(nameOfMember)"]
        ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
        })
    }

    @IBAction func logout(_ sender: UIButton) {
        logOut()

    }
    
    func logOut() {
        do {
            try FIRAuth.auth()!.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(homeViewController, animated: true, completion: nil)
        
        print("Logged Out")
        
    }
    
    func deleteAUser() {
        let user = FIRAuth.auth()?.currentUser
        
        user?.delete { error in
            if error != nil {
                print("An Error Occurred")
            } else {
                print("Account Deleted")
            }
        }
        
    }

    
            //MARK :   PROFILE PICTURE SELECTION
    @IBAction func selectProfilePhoto(_ sender: AnyObject) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profilePhotoImageView.image = selectedImage
        
        //  ******* Circular Image *******
        self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.frame.width / 2.0
        self.profilePhotoImageView.clipsToBounds = true
        
        //  ******* BORDER COLOR ********
        self.profilePhotoImageView.layer.borderWidth = 2.0
        self.profilePhotoImageView.layer.borderColor = UIColor.white.cgColor

        self.dismiss(animated: true, completion: nil)
            
            let imageName = UUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(self.profilePhotoImageView.image!) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let uid = FIRAuth.auth()?.currentUser?.uid
                        let values = ["membername" : self.memberName, "profileImageUrl": profileImageUrl] as [String : Any]
                        self.registerUserIntoDatabaseWithUID(uid!, values: values as [String : AnyObject])
                    }
                })
            }
        }
    }
    
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference(fromURL: "https://bookclub-7c48c.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err as Any)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }

    func fetchBooksRead() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: String] {
                let myBooksRead = Books()
                myBooksRead.titleOfBook = dictionary["titleOfBook"]
                myBooksRead.authorOfBook = dictionary["authorOfBook"]
                self.booksRead.append(myBooksRead)
                print(myBooksRead)
                
                DispatchQueue.main.async(execute: {
                self.tableView.reloadData()

                })
            }
            }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksRead.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "booksread", for: indexPath)
        
        let myBooksRead = booksRead[indexPath.row]
        
        cell.textLabel?.text =  myBooksRead.titleOfBook
        cell.detailTextLabel?.text =  myBooksRead.authorOfBook
        
        print(booksRead)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "MyHomeViewController", bundle: nil)
        let homeViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "UserBookNotes")
        self.present(homeViewController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func customButtons() {
        
    logout.layer.borderColor = buttonBorder
    logout.layer.backgroundColor  = buttonColor
    logout.layer.borderWidth = 1
    logout.layer.cornerRadius = 10
    
    share.layer.borderColor = buttonBorder
    share.layer.backgroundColor  = buttonColor
    share.layer.borderWidth = 1
    share.layer.cornerRadius = 10
        
    addButton.layer.borderColor = buttonBorder
    addButton.layer.backgroundColor  = buttonColor
    addButton.layer.borderWidth = 1
    addButton.layer.cornerRadius = 10

    saveMemberName.layer.borderColor = buttonBorder
    saveMemberName.layer.backgroundColor  = buttonColor
    saveMemberName.layer.borderWidth = 1
    saveMemberName.layer.cornerRadius = 10
    }
}






