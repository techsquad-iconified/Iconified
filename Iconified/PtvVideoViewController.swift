//
//  PtvVideoViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 7/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class PtvVideoViewController: UIViewController {

    @IBOutlet var videoView: UIWebView!
    var videoUrl: String?
    var languageCode: String?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoForLanguage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func videoForLanguage()
    {
        print("language code in video is \(self.languageCode!)")
        self.videoView.allowsInlineMediaPlayback = true
        switch(self.languageCode!)
        {
            case "ar":  self.videoView.loadHTMLString("<div style=\"position:relative;height:0;padding-bottom:56.25%\"><iframe src=\"https://www.youtube.com/embed/IGB1355ts_I?ecver=2\" width=\"640\" height=\"360\" frameborder=\"0\" style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen></iframe></div>", baseURL: nil)
            
            case "zh-CN": self.videoView.loadHTMLString("<div style=\"position:relative;height:0;padding-bottom:56.25%\"><iframe src=\"https://www.youtube.com/embed/ZaFE5scMbYU?ecver=2\" width=\"640\" height=\"360\" frameborder=\"0\" style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen></iframe></div>", baseURL: nil)
        
            case "vi": self.videoView.loadHTMLString("<div style=\"position:relative;height:0;padding-bottom:56.25%\"><iframe src=\"https://www.youtube.com/embed/BGq1xd5OVBU?ecver=2\" width=\"640\" height=\"360\" frameborder=\"0\" style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen></iframe></div>", baseURL: nil)
            
            
            case "es":  self.videoView.loadHTMLString("<div style=\"position:relative;height:0;padding-bottom:56.25%\"><iframe src=\"https://www.youtube.com/embed/I5sfvywgUPk?ecver=2\" width=\"640\" height=\"360\" frameborder=\"0\" style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen></iframe></div>", baseURL: nil)
         
            default: break
        }
    }
}
