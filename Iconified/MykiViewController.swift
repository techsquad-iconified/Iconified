//
//  MykiViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 6/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class MykiViewController: UIViewController {

    var selectedUrl: String?
    var plistPath: String?
    
    let langugeKey = "Default Language"
    var defaultLangugeCode: String?
    var languageDictionary: [String : String] = ["Arabic" : "ar", "Italian" : "it","Chinese" : "zh-CN","Greek" :  "el","English" : "en","Spanish" : "es", "Vietnamese" : "vi", "Japanese" : "ja", "French" : "fr", "German" : "de"]    

    @IBOutlet var aboutMyki: UIImageView!
    @IBOutlet var videoMyki: UIImageView!
    @IBOutlet var studentOffer: UIImageView!
    @IBOutlet var mykiStoreLocations: UIImageView!
   
    override func viewWillAppear(_ animated: Bool) {
        getDefaultBrowsingLanguage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
     
        //Adding gesture recognition for About icon
        let tapGestureRecogniserForAboutMyki = UITapGestureRecognizer(target: self, action:#selector(MykiViewController.aboutMykiSelected))
        aboutMyki.isUserInteractionEnabled = true
        aboutMyki.addGestureRecognizer(tapGestureRecogniserForAboutMyki)
        
        //Adding gesture recognition for Video Myki icon
        let tapGestureRecogniserForVideoMyki = UITapGestureRecognizer(target: self, action:#selector(MykiViewController.videoMykiSelected))
        videoMyki.isUserInteractionEnabled = true
        videoMyki.addGestureRecognizer(tapGestureRecogniserForVideoMyki)

        
        //Adding gesture recognition for Student offer icon
        let tapGestureRecogniserForStudentOffer = UITapGestureRecognizer(target: self, action:#selector(MykiViewController.studentOfferSelected))
        studentOffer.isUserInteractionEnabled = true
        studentOffer.addGestureRecognizer(tapGestureRecogniserForStudentOffer)
        
        //Adding gesture recognition for Myki store locations icon
        let tapGestureRecogniserForMykiStore = UITapGestureRecognizer(target: self, action:#selector(MykiViewController.findMykiStoreSelected))
        mykiStoreLocations.isUserInteractionEnabled = true
        mykiStoreLocations.addGestureRecognizer(tapGestureRecogniserForMykiStore)
       
       
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        
        super.init(coder: aDecoder)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func aboutMykiSelected()
    {
       if(self.checkDefaultLangugeSet())
       {
         if(self.defaultLangugeCode! == "en")
         {
            self.selectedUrl = "https://www.ptv.vic.gov.au/tickets/myki/"
            performSegue(withIdentifier: "translationWebSegue", sender: nil)
         }
         else
         {
            switch(self.defaultLangugeCode!)
            {
                case "ar":self.selectedUrl = "https://static.ptv.vic.gov.au/PDFs/Ticketing/1483075660/PTV_2017_myki-Quick-Guide_Arabic.pdf"
                case "it": self.selectedUrl = "https://static.ptv.vic.gov.au/PDFs/Ticketing/1483075662/PTV_2017_myki-Quick-Guide_Italian.pdf"
                case "zh-CN": self.selectedUrl = "https://static.ptv.vic.gov.au/PDFs/Ticketing/1483075664/PTV_2017_myki-Quick-Guide_Mandarin.pdf"
                case "el": self.selectedUrl = "https://static.ptv.vic.gov.au/PDFs/Ticketing/1483075662/PTV_2017_myki-Quick-Guide_Greek.pdf"
                case "vi": self.selectedUrl = "https://static.ptv.vic.gov.au/PDFs/Ticketing/1483075664/PTV_2017_myki-Quick-Guide_Vietnamese.pdf"
                case "es": self.selectedUrl = "https://static.ptv.vic.gov.au/PDFs/Ticketing/1483075664/PTV_2017_myki-Quick-Guide_Spanish.pdf"
                case "ja": self.selectedUrl = "https://static.ptv.vic.gov.au/PDFs/Ticketing/1483075664/PTV_2017_myki-Quick-Guide_Japanese.pdf"
                case "fr": self.selectedUrl = "https://static.ptv.vic.gov.au/PDFs/Ticketing/1483075661/PTV_2017_myki-Quick-Guide_French.pdf"
                case "de": self.selectedUrl = "https://static.ptv.vic.gov.au/PDFs/Ticketing/1483075661/PTV_2017_myki-Quick-Guide_German.pdf"
            default: self.selectedUrl = ""
                
                self.selectedUrl = "https://static.ptv.vic.gov.au/PDFs/Ticketing/1483075664/PTV_2017_myki-Quick-Guide_Spanish.pdf"
             }
           performSegue(withIdentifier: "mykiWebViewSegue", sender: nil)
        }
       }
    }
    
    func videoMykiSelected()
    {
        if(self.checkDefaultLangugeSet())
        {
            if(self.defaultLangugeCode! == "it" || self.defaultLangugeCode! == "el" || self.defaultLangugeCode! == "ja" || self.defaultLangugeCode! == "fr" || self.defaultLangugeCode! == "de" || self.defaultLangugeCode! == "en" )
            {
                let alert = UIAlertController(title: "Video Information", message: "Sorry! There is no video information for the selected default language", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                performSegue(withIdentifier: "mykiVideoViewSegue", sender: nil)
            }
        }
    }
    
    func studentOfferSelected()
    {
        if(self.checkDefaultLangugeSet())
        {
            if(self.defaultLangugeCode! == "en")
            {
                self.selectedUrl = "https://www.ptv.vic.gov.au/tickets/fares/concession/tertiary-students/international-students/"
            }
            else
            {
                self.selectedUrl = "https://translate.google.com.au/translate?hl=en&sl=auto&tl=\(self.defaultLangugeCode!)&u=https://www.ptv.vic.gov.au/tickets/fares/concession/tertiary-students/international-students/"
            }
            performSegue(withIdentifier: "translationWebSegue", sender: nil)
        }
    }
    
    func findMykiStoreSelected()
    {
        if(self.checkDefaultLangugeSet())
        {
            self.selectedUrl = "https://www.ptv.vic.gov.au/tickets/myki/ef1d0f60a/buying-your-myki/widget/149/showmap/"
            performSegue(withIdentifier: "mykiWebViewSegue", sender: nil)
        }
        
    }
    
    func checkDefaultLangugeSet() -> Bool
    {
        if(self.defaultLangugeCode == nil)
        {
            let alert = UIAlertController(title: "Select a browsing language", message: "Please select a language in you wish to  view further detils in", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:"Select Language", style: .default, handler:
                { action in self.performSegue(withIdentifier: "settingsFromMykiSegue", sender: self) }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else{
            return true
        }
        
    }
    
    func getDefaultBrowsingLanguage()
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        plistPath = delegate.plistPathInDocument
        
        do{
            let loadString = try String(contentsOfFile: plistPath!)
            print("loadString is \(loadString)")
            for (key,value) in languageDictionary
            {
                if(key == loadString)
                {
                    self.defaultLangugeCode = value
                }
            }
            
        } catch {
            print("Error")
        }
        print("value two is \(self.defaultLangugeCode)")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mykiWebViewSegue")
        {
            let destinationWebVC : PtvWebViewController = segue.destination as! PtvWebViewController
            destinationWebVC.selectedUrl = self.selectedUrl!
        }
        if (segue.identifier == "translationWebSegue")
        {
            let destinationWebVC : TranslationWebViewController = segue.destination as! TranslationWebViewController
            destinationWebVC.selectedUrl = self.selectedUrl!
        }
        if (segue.identifier == "mykiVideoViewSegue")
        {
            let destinationVideoVC : PtvVideoViewController = segue.destination as! PtvVideoViewController
            destinationVideoVC.languageCode = self.defaultLangugeCode
        }
        if (segue.identifier == "settingsFromMykiSegue")
        {
            let destinationSettingsVC : SettingsViewController = segue.destination as! SettingsViewController
            
        }
        if(segue.identifier == "publicTransportSegue")
        {
            let destinationMapView: PtvMapViewController = segue.destination as! PtvMapViewController
        }
    }
    
    

}
