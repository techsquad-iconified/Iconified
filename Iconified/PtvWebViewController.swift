//
//  PtvWebViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 5/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit
/*
 PtvWebViewController is a view comtroller that displays a web view 
 The web view displays the websites requested
 */

class PtvWebViewController: UIViewController {
    
   //UI controls
    @IBOutlet var webView: UIWebView!
    var selectedUrl: String?
    
    // creating a view to display a progress spinner while data is being loaded from the server
    var progressView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting up the progress view
        setProgressView()
        self.webView.addSubview(self.progressView)
        
        DispatchQueue.main.async(){
        var url: NSURL
        print("usl sent is \(self.selectedUrl!)")
        url = NSURL (string: "\(self.selectedUrl!)")! //if website was selected
        let requestObj = NSURLRequest(url: url as URL);
        self.webView.loadRequest(requestObj as URLRequest)
        //getSettings().setBuiltInZoomControls(true);
        

        self.stopProgressView()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.portrait)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
