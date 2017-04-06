//
//  PtvWebViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 5/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class PtvWebViewController: UIViewController {
    
   
    @IBOutlet var webView: UIWebView!
    var selectedUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var url: NSURL
        print("usl sent is \(selectedUrl!)")
        url = NSURL (string: "\(self.selectedUrl!)")! //if website was selected
        let requestObj = NSURLRequest(url: url as URL);
        webView.loadRequest(requestObj as URLRequest)
 
  //  self.stopProgressView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getHTMl()
    {
        let myURLString = "https://google.com"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            print("HTML : \(myHTMLString)")
             webView.loadHTMLString("\(myHTMLString)", baseURL: nil)
        } catch let error {
            print("Error: \(error)")
        }
       
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
