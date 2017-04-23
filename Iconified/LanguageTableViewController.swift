//
//  LanguageTableViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 21/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

/*
 LanguageTableViewController is a table view controller linked to the table view representing the list of languages.
 */
import UIKit

//Protocol for delegate to return the language selected for doctors
protocol languageDelegate
{
    func languageSelected(language: String)
}

class LanguageTableViewController: UITableViewController {

    //Global variables
    var languageTypes = ["Arab", "Australia", "China", "India", "Italy", "France", "Greece", "Germany", "Vietnam"]
    //Setting default to English
    var currentLanguage = "Australia"
    
    //Delegate variable
    var delegate: languageDelegate?
    
    //method called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    //Method returns the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //Method returns the number of rows in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return languageTypes.count
    }
    
    //Method to set values to tableview cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageTableViewCell
        cell.flagImageView.image = UIImage(named: self.languageTypes[indexPath.row])
        return cell
    }
    
    //Method to return the selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Rowww selected")
        self.delegate?.languageSelected(language: self.languageTypes[indexPath.row])
        self.performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
