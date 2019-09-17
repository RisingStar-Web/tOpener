//
//  JavascriptTableViewController.swift
//  VisualHTMLeditor
//
//  Created by Valeriy PETRENKO on 12/05/2018.
//  Copyright © 2018 Slavamax BVBA. All rights reserved.
//

import UIKit

class JavascriptTableViewController: UITableViewController {

    
@IBOutlet weak var switchJava: UISwitch!
@IBOutlet weak var donePressed: UIButton!

    var javaValue : Bool = true
    
@IBAction func switchChanged(_ sender: UISwitch) {
    #if DEBUG
    //print(" switchChanged \(#line)   ")
    #endif
    if (sender.isOn == true) {
        //print("UISwitch state is now ON")
          self.javaValue = true
        
    }
    else {
        self.javaValue = false
        //print("UISwitch state is now Off")
    }
    UserDefaults.standard.set(self.javaValue, forKey: "JavaScript")
    UserDefaults.standard.synchronize()
}
    
    
override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    let tmpBool =  UserDefaults.standard.bool(forKey: "JavaScript") as Bool?
    
    if (tmpBool != nil) {
        self.javaValue = tmpBool!
    }  else  {
        UserDefaults.standard.set(true, forKey: "JavaScript")
        UserDefaults.standard.synchronize()
    }
    #if DEBUG
    //print(" javaValue=\(self.javaValue) \(#line)   ")
    #endif
    
    if self.javaValue {
     self.switchJava.setOn(true, animated: false)
    } else  {
      self.switchJava.setOn(false, animated: false)
    }
}
    
    
@IBAction func donePressed(_ sender: UIButton) {
    #if DEBUG
    //print(" doneButtonpressed \(#line)   ")
    #endif
    dismiss(animated: true) {
    }
}
    
    
override func viewDidLoad() {
        super.viewDidLoad()
    self.switchJava.isUserInteractionEnabled = true
    /*
        if self.javaValue {
            self.switchJava.setOn(true, animated: false)
        } else  {
            self.switchJava.setOn(false, animated: false)
        }
 */
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
