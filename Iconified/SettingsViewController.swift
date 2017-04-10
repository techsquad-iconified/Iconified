//
//  SettingsViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 7/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var languagePicker: UIPickerView!
  
    var plistPath: String!
    var selectedLanguage: String?
    var selectedCode: String?
    var languageDictionary: [String : String] = ["Arabic" : "ar", "Italian" : "it","Chinese" : "zh-CN","Greek" :  "el","English" : "en","Spanish" : "es", "Vietnamese" : "vi", "Japanese" : "ja", "French" : "fr", "German" : "de"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languagePicker.delegate = self
        languagePicker.dataSource = self
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData()
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        plistPath = delegate.plistPathInDocument
        
        do{
            let loadString = try String(contentsOfFile: plistPath)
            var value = (Array(languageDictionary.keys)).index(of: loadString)
            languagePicker.selectRow(value!, inComponent: 0, animated: true)
        } catch {
            print("Error")
        }
    
    }
    
    func savePlistData(selectedLanguage: String)
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let pathForPlistFile = delegate.plistPathInDocument
        do{
            try selectedLanguage.write(toFile: pathForPlistFile, atomically: true, encoding: String.Encoding.utf8)
           
        } catch {
            print("Error")
        }
    }

    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return languageDictionary.count
        
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(languageDictionary.keys)[row]
       
    }
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      self.selectedLanguage =  Array(languageDictionary.keys)[row]
      self.selectedCode = Array(languageDictionary.values)[row]
       print("Seleted language is \(self.selectedCode!)")
       print("Seleted code is \(self.selectedLanguage!)")
        self.savePlistData(selectedLanguage: self.selectedLanguage!)
       
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
