//
//  SearchClubViewController.swift
//  BookClub
//
//  Created by Cynthia Whitlatch on 6/20/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit

class SearchClubViewController: UIViewController {

    let buttonBorder = UIColor.white.cgColor
    let buttonColor = UIColor(red: 40/255, green: 141/255, blue: 255/255, alpha: 0.5).cgColor
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var viewClub: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customButtons()
    }

    @IBAction func viewClubPressed(_ sender: AnyObject) {
        
    }
    
    
    @IBAction func clearButtonPressed(_ sender: AnyObject) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customButtons() {
        clearButton.layer.borderColor = buttonBorder
        clearButton.layer.backgroundColor  = buttonColor
        clearButton.layer.borderWidth = 1
        clearButton.layer.cornerRadius = 10
        
        viewClub.layer.borderColor = buttonBorder
        viewClub.layer.backgroundColor  = buttonColor
        viewClub.layer.borderWidth = 1
        viewClub.layer.cornerRadius = 10
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
