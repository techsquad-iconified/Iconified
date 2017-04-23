//
//  TranslationViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 13/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

/*
 TranslationViewController is a view controller linked to the translate screen.
 */

import UIKit
import AVFoundation

class TranslationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //UI Controls
    @IBOutlet var tranalateText: UITextField!
    @IBOutlet var translatedLabel: UILabel!
    
    @IBOutlet var targetLangPicker: UIPickerView!
    @IBOutlet var sourceLangPicker: UIPickerView!
    
    @IBOutlet var translateButton: UIButton!
    @IBOutlet var speakerButton: UIButton!
    
    //Globle variables
    var sourceLanguage:String?
    var sourceCode:String?
    
    var targetLanguage:String?
    var targetCode:String?
    var plistPath: String!
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    //Arary of langauges
    let languageArray : [String] = ["Arabic", "Chinese", "English", "French", "German", "Greek", "Italian",  "Japanese" , "Spanish", "Vietnamese"]
    
    //let languageDictionary: [String : String] = ["Arabic" : "ar", "Chinese" : "zh-CN", "English" : "en", "French" : "fr", "German" : "de", "Greek" :  "el", "Italian" : "it",  "Japanese" : "ja", "Spanish" : "es", "Vietnamese" : "vi"]
    //Methos called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceLangPicker.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.5)
        targetLangPicker.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.5)
        
        sourceLangPicker.delegate = self
        sourceLangPicker.dataSource = self
        targetLangPicker.delegate = self
        targetLangPicker.dataSource = self
        tranalateText.delegate = self
        self.speakerButton.isHidden = true
        /*
        self.translateButton.isHidden = true
        self.tranalateText.isHidden = true
         */
        self.loadPreferredLanguagefromPlistData()
 
        // Do any additional setup after loading the view.
    }
    
    //Method to check if the translate text view was cleared and accordingly clear the translated label
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text == "")
        {
            self.translatedLabel.text = ""
            self.speakerButton.isHidden = true
        }
    }
    
    //Method to check if preferred language keyboard is configured in the Settings
    func checkPreferredLanguageKeyboardInSetings(selectedLanguageCode: String) -> Bool
    {
        // let langStr = Locale.current.languageCode
        let lang = Locale.preferredLanguages as NSArray
        print("language count is \(lang.count)")
        for lan in lang
        {
            print("\(lan) is in list")
        }
        switch(selectedLanguageCode)
        {
        case "en" : if(lang.contains("en"))
        {
            print("sucess with English")
            return true
            }
        case "ar" : if(lang.contains("ar"))
        {
            print("sucess with Arabic")
            return true
            }
        case "zh-CN": if(lang.contains("zh-Hans-US"))
        {
            print("sucess with Chinese")
            return true
            }
        case "fr": if(lang.contains("fr"))
        {
            print("sucess with French")
            return true
            }
        case "de" : if(lang.contains("de"))
        {
            print("sucess with german")
            return true
            }
        case "el" : if(lang.contains("el"))
        {
            print("sucess with greek")
            return true
            }
        case "it" : if(lang.contains("it"))
        {
            print("sucess with Italian")
            return true
            }
        case "ja" : if(lang.contains("ja"))
        {
            print("sucess with Japanese")
            return true
            }
        case "es" : if(lang.contains("es-MX"))
        {
            print("sucess with spanish")
            return true
            }
        case "vi" : if(lang.contains("vi"))
        {
            print("sucess with vietnamese")
            return true
            }
        default: return false
        }
        return false
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Action for translate button
    @IBAction func translateButton(_ sender: Any) {
       DispatchQueue.main.async(){
                self.translate(toTranslate: self.tranalateText.text!)
            }
        DispatchQueue.main.async(){
            self.checkSpeakerOptionForTargetLanguageSelected()
            
        }
        
      
    }
    //Action for speaker Method
    @IBAction func speakerAction(_ sender: Any) {
        myUtterance = AVSpeechUtterance(string: self.translatedLabel.text!)
        myUtterance.rate = 0.3
        synth.speak(myUtterance)
    }
    
    //Method to retrieved the languge preferrence saved on plist
    func loadPreferredLanguagefromPlistData()
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        plistPath = delegate.plistPathInDocument
        
        do{
            let loadString = try String(contentsOfFile: plistPath)
            //var value = (Array(languageDictionary.keys)).index(of: loadString)
            var value = languageArray.index(of: loadString)
            print("value is \(value)")
            sourceLangPicker.selectRow(value!, inComponent: 0, animated: true)
            targetLangPicker.selectRow(2, inComponent: 0, animated: true)
            self.sourceCode = self.getCodeForLanguage(language: self.languageArray[value!])
            self.targetCode = self.getCodeForLanguage(language: self.languageArray[2])
        } catch {
            print("Error")
        }
        
    }
    
    
    //Method to hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // method to establish connection and download JSON data from the API
    func translate(toTranslate: String) {
        
        var url: URL
        print("Finally source is \(self.sourceCode!)")
        print("Finally target is \(self.targetCode!)")
        print("Finally msg is \(toTranslate)")
        print("urls is https://translation.googleapis.com/language/translate/v2?key=AIzaSyAdaFAS__rtr1U2kmJgapmQ1A4je0iWQwc&source=\(self.sourceCode!)&target=\(self.targetCode!)&q=\(toTranslate)")
        // url = URL(string:"https://translation.googleapis.com/language/translate/v2?key=AIzaSyAdaFAS__rtr1U2kmJgapmQ1A4je0iWQwc&source=\(self.sourceCode!)&target=\(self.targetCode!)&q=\(toTranslate)")!
        // print(url)
        
        
        let original = "https://translation.googleapis.com/language/translate/v2?key=AIzaSyAdaFAS__rtr1U2kmJgapmQ1A4je0iWQwc&source=\(self.sourceCode!)&target=\(self.targetCode!)&q=\(toTranslate)"
        if let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded)
        {
            print(url)
            let urlRequest = URLRequest(url: url)
            
            
            //set up session
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if (error != nil)    //checking if the any error message received during connection
                {
                    print("Error \(error)")
                }
                else
                {
                    DispatchQueue.main.async(){
                        self.parseJSON(articleJSON: data! as NSData)
                    }
                    // print("data is \(data)")
                }
            })
            
            task.resume()
        }
        
    }
    
    //Parsing JSON retrieved to get the translated text
    func parseJSON(articleJSON:NSData)
    {
        do{
            // making an API Request
            let jsonData = try JSONSerialization.jsonObject(with: articleJSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
            // print(jsonData)
            if let data = jsonData["data"] as? NSDictionary
            {
                if let translations = data["translations"] as? NSArray
                {
                    for  message in translations
                    {
                        let text = message as! NSDictionary
                        let transText = text.object(forKey: "translatedText") as! String
                        self.translatedLabel.text = transText
                        print("Message is \(message)")
                    }
                }
            }
        }
        catch{
            print("JSON Serialization error")
        }
        
    }
    
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView.tag == 1)
        {
            return languageArray.count
        }
        else
        {
            return languageArray.count
        }
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1)
        {
            return languageArray[row]
        }
        else
        {
            return languageArray[row]
        }
    }
    //Method called when a picker row iss selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1)
        {
            self.sourceLanguage =  languageArray[row]
            self.sourceCode = self.getCodeForLanguage(language: self.sourceLanguage!)
            self.checkSourceLanguageSelected()
            print("Seleted language is \(self.sourceLanguage!)")
            print("Seleted code is \(self.sourceCode!)")
        }
        else
        {
            self.targetLanguage =  languageArray[row]
            self.targetCode = self.getCodeForLanguage(language: self.targetLanguage!)
            print("Target language is \(self.targetLanguage!)")
            print("Target code is \(self.targetCode!)")
            
        }
    }
    
    //Method to return the code for a specific language
    func getCodeForLanguage(language: String) -> String
    {
        switch(language)
        {
        case "Arabic" : return "ar"
        case "Chinese" : return "zh-CN"
        case "English" : return "en"
        case "French" : return "fr"
        case "German" : return "de"
        case "Greek" : return "el"
        case "Italian" : return "it"
        case "Japanese" : return "ja"
        case "Spanish" : return "es"
        case "Vietnamese" : return "vi"
        default: return "en"
        }
        
    }
    
    //Method to check source language selected
    func checkSourceLanguageSelected()
    {
        if(self.checkPreferredLanguageKeyboardInSetings(selectedLanguageCode: self.sourceCode!))
        {
            self.translateButton.isHidden = false
            self.tranalateText.isHidden = false
            self.translatedLabel.isHidden = false
            self.speakerButton.isHidden = false
        }
        else
        {
            let alert = UIAlertController(title: "Missing Language Keyboard", message: "Please select the language keyboard in your settings", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.translateButton.isHidden = true
            self.tranalateText.isHidden = true
            self.translatedLabel.isHidden = true
            self.speakerButton.isHidden = true
        }
    }
    
    //Method to check Speaker Option ForTarget Language Selected
    func checkSpeakerOptionForTargetLanguageSelected()
    {
        if(self.targetCode != "en")
        {
            self.speakerButton.isHidden = true
        }
        else
        {
            self.speakerButton.isHidden = false
        }
    }
    
    //Method to load flags to picker view
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        /*
         let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 10, height: 160))
         //CGRectMake(0, 0, pickerView.bounds.width - 30, 60))
         
         let myImageView = UIImageView(frame: CGRect(x: 60, y: 0, width: 80, height: 80))
         
         var rowString = String()
         switch row
         {
         case 0: //rowString = "Australia"
         myImageView.image = UIImage(named:"Australia")
         case 1: //rowString = "India"
         myImageView.image = UIImage(named:"China")
         case 2:// rowString = "Italy"
         myImageView.image = UIImage(named:"Australia")
         case 3: myImageView.image = UIImage(named:"Australia")
         case 4: myImageView.image = UIImage(named:"Australia")
         case 5: myImageView.image = UIImage(named:"Australia")
         case 6: myImageView.image = UIImage(named:"Italy")
         case 7: myImageView.image = UIImage(named:"Japan")
         case 8: myImageView.image = UIImage(named:"Mexico")
         case 9: myImageView.image = UIImage(named:"Vietnam")
         
         default:
         //rowString = "Error: too many rows"
         myImageView.image = nil
         }
         let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60))
         myLabel.font = UIFont(name: "some font", size: 18)
         myLabel.text = rowString
         
         // myView.addSubview(myLabel)
         myView.addSubview(myImageView)
         
         return myView
         */
        
        var myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        if(pickerView.tag == 1)
        {
            
            switch row
            {
                case 0:
                    myImageView = UIImageView(image: UIImage(named:"Arab"))
                case 1:
                    myImageView = UIImageView(image: UIImage(named:"China"))
                case 2:
                    myImageView = UIImageView(image: UIImage(named:"Australia"))
                case 3:
                    myImageView = UIImageView(image: UIImage(named:"France"))
                case 4:
                    myImageView = UIImageView(image: UIImage(named:"Germany"))
                case 5:
                    myImageView = UIImageView(image: UIImage(named:"Greece"))
                case 6:
                    myImageView = UIImageView(image: UIImage(named:"Italy"))
                case 7:
                    myImageView = UIImageView(image: UIImage(named:"Japan"))
                case 8:
                    myImageView = UIImageView(image: UIImage(named:"Mexico"))
                case 9:
                    myImageView = UIImageView(image: UIImage(named:"Vietnam"))
                default:
                    myImageView.image = nil
                    return myImageView
            }
        }
        else
        {
            
            switch row {
                case 0:
                    myImageView = UIImageView(image: UIImage(named:"Arab"))
                case 1:
                    myImageView = UIImageView(image: UIImage(named:"China"))
                case 2:
                    myImageView = UIImageView(image: UIImage(named:"Australia"))
                case 3:
                    myImageView = UIImageView(image: UIImage(named:"France"))
                case 4:
                    myImageView = UIImageView(image: UIImage(named:"Germany"))
                case 5:
                    myImageView = UIImageView(image: UIImage(named:"Greece"))
                case 6:
                    myImageView = UIImageView(image: UIImage(named:"Italy"))
                case 7:
                    myImageView = UIImageView(image: UIImage(named:"Japan"))
                case 8:
                    myImageView = UIImageView(image: UIImage(named:"Mexico"))
                case 9:
                    myImageView = UIImageView(image: UIImage(named:"Vietnam"))
                default:
                    myImageView.image = nil
                    return myImageView
            }
            
        }
        return myImageView
        
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
