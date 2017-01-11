//
//  BuyBookViewcontrollerViewController.swift
//  
//
//  Created by Cynthia Whitlatch on 6/20/16.
//
//

import UIKit

class BuyBookViewcontrollerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL (string: "http://www.amazon.com");
        let requestObj = URLRequest(url: url!);
        webView.loadRequest(requestObj);

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
            self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var webView: UIWebView!

}
