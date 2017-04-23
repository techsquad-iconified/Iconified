//
//  WebViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 28/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//
/*
 the view controller presents a webview to load teh google directions page or website of the place selected
 */
import UIKit

class WebViewController: UIViewController {

    //UI Webview
    @IBOutlet var webView: UIWebView!
    
    //Object of the place selected by the user
    var selectedPlace: Place?
    var type: String?  // representing the selection (website or navigation)
    
    // creating a view to display a progress spinner while data is being loaded from the server
    var progressView = UIView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up the progress view
        setProgressView()
        self.webView.addSubview(self.progressView)
        
        //set screen title
        self.title = self.selectedPlace?.placeName
        self.loadWebPage()
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Method to load teh web page
    func loadWebPage()
    {
        var url: NSURL
        
        //loading wedpage to the web view
        if(self.type! == "navigation")
        {
             url = NSURL (string: (selectedPlace?.url!)!)!  //if navigation was selected
        }
        else
        {
             url = NSURL (string: (selectedPlace?.website!)!)! //if website was selected
            
        }
        print("In webview url is \(url)")
        DispatchQueue.main.async(){
            let requestObj = NSURLRequest(url: url as URL);
            self.webView.loadRequest(requestObj as URLRequest)
            self.stopProgressView()
        }
        DispatchQueue.main.async(){
           // self.stopProgressView()
        }
        
        
        
    }
    
    
    
    /*
     Setting up the progress view that displays a spinner while the serer data is being downloaded.
     The view uses an activity indicator (a spinner) and a simple text to convey the information.
     Source: YouTube
     Tutorial: Swift - How to Create Loading Bar (Spinners)
     Author: Melih Şimşek
     URL: https://www.youtube.com/watch?v=iPTuhyU5HkI
     */
    func setProgressView()
    {
        self.progressView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        self.progressView.backgroundColor = UIColor.darkGray
        self.progressView.layer.cornerRadius = 10
        let wait = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        wait.color = UIColor.white
        //UIColor(red: 254/255, green: 218/255, blue: 2/255, alpha: 1)
        wait.hidesWhenStopped = false
        wait.startAnimating()
        
        let message = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        message.text = "Loading webpage..."
        message.textColor = UIColor.white
        
        self.progressView.addSubview(wait)
        self.progressView.addSubview(message)
        self.progressView.center = self.view.center
        self.progressView.tag = 1000
        
    }
    
    /*
     This method is invoked to remove the progress spinner from the view.
     Source: YouTube
     Tutorial: Swift - How to Create Loading Bar (Spinners)
     Author: Melih Şimşek
     URL: https://www.youtube.com/watch?v=iPTuhyU5HkI
     */
    func stopProgressView()
    {
        let subviews = self.webView.subviews
        for subview in subviews
        {
            if subview.tag == 1000
            {
                subview.removeFromSuperview()
            }
        }
    }
 
    
    

}
