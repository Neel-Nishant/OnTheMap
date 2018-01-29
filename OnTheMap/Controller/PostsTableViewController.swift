//
//  PostsTableViewController.swift
//  OnTheMap
//
//  Created by Neel Nishant on 18/01/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (StudentInformation.sharedInstance.students.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "posts", for: indexPath)

        // Configure the cell...
        let textString = "\((StudentInformation.sharedInstance.students[indexPath.row].firstName)) \((StudentInformation.sharedInstance.students[indexPath.row].lastName))"
        cell.textLabel?.text = textString
        cell.detailTextLabel?.text = StudentInformation.sharedInstance.students[indexPath.row].url

        return cell
    }
    //open map
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let toOpen = StudentInformation.sharedInstance.students[indexPath.row].url
        app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
    }
    func completeLogout() {
        performUIUpdatesOnMain {
            self.dismiss(animated: true, completion: nil)
        }
    }
    //create Alert
    func createAlert(title: String, message: String){
        performUIUpdatesOnMain {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
 
    @IBAction func logOutPressed(_ sender: Any) {
        UdacityClient.sharedInstance().taskForDeleteMethod { (success, error) in
            if success {
                self.completeLogout()
                print("logged out successfully")
            }
            else {
                self.createAlert(title: "Error", message: error!)
            }
        }
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
