//
//  TranslationViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 13/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class TranslationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var tranalateText: UITextField!
    @IBOutlet var translatedLabel: UILabel!
    
    @IBOutlet var targetLangPicker: UIPickerView!
    @IBOutlet var sourceLangPicker: UIPickerView!
    
    var sourceLanguage:String?
    var sourceCode:String?
    
    var targetLanguage:String?
    var targetCode:String?
    var plistPath: String!
    
    let languageArray : [String] = ["Arabic", "Chinese", "English", "French", "German", "Greek", "Italian",  "Japanese" , "Spanish", "Vietnamese"]
    
    //let languageDictionary: [String : String] = ["Arabic" : "ar", "Chinese" : "zh-CN", "English" : "en", "French" : "fr", "German" : "de", "Greek" :  "el", "Italian" : "it",  "Japanese" : "ja", "Spanish" : "es", "Vietnamese" : "vi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        sourceLangPicker.delegate = self
        sourceLangPicker.dataSource = self
        targetLangPicker.delegate = self
        targetLangPicker.dataSource = self
        self.loadPreferredLanguagefromPlistData()
        // Do any additional setup after loading the view.
    }
    override open var shouldAutorotate: Bool {
        return false
    }
    
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
        case "ar" : if(lang.contains("en"))
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
    
    @IBAction func translateButton(_ sender: Any) {
        if(self.checkPreferredLanguageKeyboardInSetings(selectedLanguageCode: self.sourceCode!))
        {
            DispatchQueue.main.async(){
                self.translate(toTranslate: self.tranalateText.text!)
            }
        }
        else
        {
            
        }
    }
    
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
    
    func parseJSON(articleJSON:NSData){
        
        var placeLat: Double?
        var placeLng: Double?
        var placeId: String?
        var placeName: String?
        var placeAddress: String?
        var isOpen: Bool?
        
        do{
            
            
            //  When the json data is from TIM api
            
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
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1)
        {
            self.sourceLanguage =  languageArray[row]
            self.sourceCode = self.getCodeForLanguage(language: self.sourceLanguage!)
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
