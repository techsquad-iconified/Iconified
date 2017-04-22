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
 //  let languageDictionary: [String : String] = ["Arabic" : "ar", "Chinese" : "zh-CN", "English" : "en", "French" : "fr", "German" : "de", "Greek" :  "el", "Italian" : "it",  "Japanese" : "ja", "Spanish" : "es", "Vietnamese" : "vi"]
    let languageArray : [String] = ["Arabic", "Chinese", "English", "French", "German", "Greek", "Italian",  "Japanese" , "Spanish", "Vietnamese"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languagePicker.transform = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
            //CGAffineTransformMakeScale(.5, 0.5);
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
            var value = languageArray.index(of: loadString)
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
      return languageArray.count
        
    }
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
        return myImageView

    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageArray[row]
       
    }
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       self.selectedLanguage =  languageArray[row]
       print("Selected language is \(self.selectedLanguage!)")
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
