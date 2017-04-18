//
//  PtvVideoViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 7/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit
/*
 PtvWebViewController is a view comtroller that displays a web view
 The web view displays the video requested
 */
class PtvVideoViewController: UIViewController {

    //UI Controls
    @IBOutlet var videoView: UIWebView!
    //Global variable
    var videoUrl: String?
    var languageCode: String?
  
    //Method called when view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoForLanguage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Method to return the video of the langueg selected
    func videoForLanguage()
    {
        print("language code in video is \(self.languageCode!)")
        self.videoView.allowsInlineMediaPlayback = true
        switch(self.languageCode!)
        {   //If language is Arabic
            case "ar":  self.videoView.loadHTMLString("<div style=\"position:relative;height:0;padding-bottom:56.25%\"><iframe src=\"https://www.youtube.com/embed/IGB1355ts_I?ecver=2\" width=\"640\" height=\"360\" frameborder=\"0\" style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen></iframe></div>", baseURL: nil)
            //If language is Chinese
            case "zh-CN": self.videoView.loadHTMLString("<div style=\"position:relative;height:0;padding-bottom:56.25%\"><iframe src=\"https://www.youtube.com/embed/ZaFE5scMbYU?ecver=2\" width=\"640\" height=\"360\" frameborder=\"0\" style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen></iframe></div>", baseURL: nil)
        //If language is Vietnamese
            case "vi": self.videoView.loadHTMLString("<div style=\"position:relative;height:0;padding-bottom:56.25%\"><iframe src=\"https://www.youtube.com/embed/BGq1xd5OVBU?ecver=2\" width=\"640\" height=\"360\" frameborder=\"0\" style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen></iframe></div>", baseURL: nil)
            
            //If language is Spanish
            case "es":  self.videoView.loadHTMLString("<div style=\"position:relative;height:0;padding-bottom:56.25%\"><iframe src=\"https://www.youtube.com/embed/I5sfvywgUPk?ecver=2\" width=\"640\" height=\"360\" frameborder=\"0\" style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen></iframe></div>", baseURL: nil)
         
            default: break
        }
    }
}
