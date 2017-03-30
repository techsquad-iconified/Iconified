//
//  WebViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 28/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    var selectedPlace: Place?
    var type: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.selectedPlace?.placeName
        self.loadWebPage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadWebPage()
    {
        var url: NSURL
        
        //loading wedpage to the web view
        if(self.type! == "navigation")
        {
             url = NSURL (string: (selectedPlace?.url!)!)!
        }
        else
        {
             url = NSURL (string: (selectedPlace?.website!)!)!
            
        }
        print("In webview url is \(url)")
        let requestObj = NSURLRequest(url: url as URL);
        webView.loadRequest(requestObj as URLRequest)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
