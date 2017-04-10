//
//  TranslateViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 4/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//


import UIKit

class TranslateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var tranalateText: UITextField!
    @IBOutlet var translatedLabel: UILabel!
    
    @IBOutlet var targetLangPicker: UIPickerView!
    @IBOutlet var sourceLangPicker: UIPickerView!
    
    var sourceLanguage:String?
    var sourceCode:String?
    
    var targetLanguage:String?
    var targetCode:String?
    
    var languageDictionary: [String : String] = ["Afrikaans" : "af", "Albanian" : "sq", "Amharic" : "am",
        "Arabic" : "ar",
        "Armenian" : "hy",
        "Azeerbaijani" : "az",
        "Basque" : "eu",
        "Belarusian" :"be",
        "Bengali" : "bn",
        "Bosnian" : "bs",
        "Bulgarian" : "bg",
        "Catalan" : "ca",
        "Cebuano" : "ceb",
        "Chichewa" : "ny",
        "Chinese" : "zh-CN",
        "Corsican" : "co",
        "Croatian" : "hr",
        "Czech" : "cs",
        "Danish" : "da",
        "Dutch" : "nl",
        "English" :	"en",
        "Kannada" : "kn",
        "Spanish" : "es"]



    override func viewDidLoad() {
        super.viewDidLoad()
        sourceLangPicker.delegate = self
        sourceLangPicker.dataSource = self
        targetLangPicker.delegate = self
        targetLangPicker.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func translateButton(_ sender: Any) {
        DispatchQueue.main.async(){
            
        self.translate(toTranslate: self.clearSpace(inputString: self.tranalateText.text!))
        }
    }
    
    func clearSpace(inputString: String) -> String
    {
        return inputString.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
 
    // method to establish connection and download JSON data from the API
    func translate(toTranslate: String) {
      
        var url: URL
        url = URL(string:"https://translation.googleapis.com/language/translate/v2?key=AIzaSyAdaFAS__rtr1U2kmJgapmQ1A4je0iWQwc&source=\(self.sourceCode!)&target=\(self.targetCode!)&q=\(toTranslate)")!
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
            return languageDictionary.count
        }
        else
        {
            return languageDictionary.count
        }
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1)
        {
            return Array(languageDictionary.keys)[row]
        }
        else
        {
            return Array(languageDictionary.keys)[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1)
        {
        self.sourceLanguage =  Array(languageDictionary.keys)[row]
        self.sourceCode = Array(languageDictionary.values)[row]
        print("Seleted language is \(self.sourceLanguage!)")
        print("Seleted code is \(self.sourceCode!)")
        }
        else
        {
            self.targetLanguage =  Array(languageDictionary.keys)[row]
            self.targetCode = Array(languageDictionary.values)[row]
            print("Target language is \(self.targetLanguage!)")
            print("Target code is \(self.targetCode!)")
            
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
