//
//  UploadTableViewController.swift
//  VisualHTMLeditor
//
//  Created by Valeriy PETRENKO on 28/04/2018.
//  Copyright © 2018 Slavamax BVBA. All rights reserved.
//
import Foundation
import CFNetwork

import UIKit

class UploadTableViewController: UITableViewController, UITextFieldDelegate,  StreamDelegate {
    
    
   
    var leftOverSize = 0
    var isRunLoop = true
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
 
  
    @IBOutlet weak var fileLabel: UILabel!
    @IBOutlet weak var hostFTPTextField: UITextField!
    @IBOutlet weak var loginFTPTextField: UITextField!
    @IBOutlet weak var passwordFTPTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var currentFileName : String = ""
    var host : String = ""
    var login : String = ""
    var password : String = ""
     var directoryPath : String = ""
 //_______________________
   var  ftpBaseUrl: String = ""
     var username: String = ""
    
 
    //_______________________
    
    func displayAlert(title: String, message: String) {
        DispatchQueue.main.async(execute: {
            // work Needs to be done
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
          
            if title == "Success!" {
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  {(alert: UIAlertAction!) in  self.dismiss(animated: true) {   }}))
            } else {
                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                 }
            
            self.present(alert, animated: true, completion: nil)
            self.activityIndicator.stopAnimating()
       
        })
    }
    
    //===========
   
 
    
@IBAction func sendButtonPressed(_ sender: UIButton) {
    if let hostString = self.hostFTPTextField.text, !hostString.isEmpty
    { //do something if it's not empty
        //  hostString
        self.host = hostString
    } else  { //do something if it's not empty
        self.displayAlert(title: "Attention!", message: "Enter FTP host please")
        self.hostFTPTextField.becomeFirstResponder()
        return
    }
    
    
    if let loginString = self.loginFTPTextField.text, !loginString.isEmpty
    { //do loginString if it's not empty
        self.login = loginString
    } else  { //do something if it's not empty
        self.displayAlert(title: "Attention!", message: "Enter FTP login please")
        self.loginFTPTextField.becomeFirstResponder()
        return
    }
    
    if let passwordString = self.passwordFTPTextField.text, !passwordString.isEmpty
    { //do something if it's not empty
        self.password  =    passwordString
    } else  { //do something if it's not empty
        //self.password  =  ""
       self.displayAlert(title: "Attention!", message: "Enter FTP password please")
       self.passwordFTPTextField.becomeFirstResponder()
        //return
    }
    
 DispatchQueue.main.async(execute: {
        self.activityIndicator.startAnimating()
 })
   
    
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let localUrl = documentDirectory?.appendingPathComponent(self.currentFileName)
    
    if FileManager.default.fileExists(atPath: (localUrl?.path)!){
        if let  tmpdata = NSData(contentsOfFile: (localUrl?.path)!) {
            
            let filedata = tmpdata as Data
            
             DispatchQueue.global(qos: .background).async {
                
            let ftpup =  FTPUpload(baseUrl:  self.host, userName:  self.login, password: self.password, directoryPath: "")
            
            ftpup.send(data: filedata, with: self.currentFileName, success: {(success) -> Void in
                
                
                
                if !success {
                    //print("Failed upload!")
                    self.displayAlert(title: "Attention!", message: "Failed upload!\r Common Reasons: incorrect entering your host, username, password;  hosting server problems e.t.c.")
                    
                    
                    DispatchQueue.main.async(execute: {
                        self.activityIndicator.stopAnimating()
                    })
                    
                }  else {
                    //print("File uploaded!")
                    
                    
                    DispatchQueue.main.async(execute: {
                        UserDefaults.standard.set(self.host, forKey: "CreateDirURLText")
                        UserDefaults.standard.set(self.login, forKey: "Username")
                        UserDefaults.standard.set(self.password, forKey: "Password")
                        UserDefaults.standard.synchronize()
                        
                        self.activityIndicator.stopAnimating()
                        
                        self.displayAlert(title: "Success!", message: "File has been uploaded!")
                       
                        
                        //  _ = self.navigationController?.popToRootViewController(animated: true)
                     
                    })
                    
                    
                    
                }
                
                
                
            })
                 } //DispatchQueue.global(qos: .background).async
         
        }  else { // if let  tmpdata = NSData(contentsOfFile: (localUrl?.path)!)
           DispatchQueue.main.async(execute: {
                self.activityIndicator.stopAnimating()
            })
            
        }
    } else { // if FileManager.default.fileExists(atPath: (localUrl?.path)!){
         DispatchQueue.main.async(execute: {
            self.activityIndicator.stopAnimating()
        })
}
//=========================
 
   // let ftpup = FTPUpload(baseUrl: "ftp.slavamax.com", userName: "editoreye", password: "flopopo1.", directoryPath: "")
    // DispatchQueue.global(qos: .background).async {
      // //print("This is run on the background queue")
    // }
    
    
    //let image = UIImage(named: "medium")
    //let imagedata = UIImageJPEGRepresentation(image!, 1)
    
    //So in case of reading data you can use:
    //Data(contentsOf: <URL>, options: <Data.ReadingOptions>)
    //Reading a plain text as a String, use:
    //String(contentsOfFile: <LocalFileDirPath>)
    //Reading an image from document directory, use:
    //UIImage(contentsOfFile: <LocalFileDirPath>)
    
    //let filedata: Data? = "Café".data(using: .utf8) // non-nil
    
    
    /*
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let localUrl = documentDirectory?.appendingPathComponent(self.currentFileName)
    
    if FileManager.default.fileExists(atPath: (localUrl?.path)!){
        if let  tmpdata = NSData(contentsOfFile: (localUrl?.path)!) {
           
            
            let filedata = tmpdata as Data
            
            let ftpup =  FTPUpload(baseUrl:  self.host, userName:  self.login, password: self.password, directoryPath: "")
            
            ftpup.send(data: filedata, with: self.currentFileName, success: {(success) -> Void in
                
             
         
                if !success {
                    //print("Failed upload!")
                     self.displayAlert(title: "Attention!", message: "Failed upload!")
                   
                    
                    DispatchQueue.main.async(execute: {
                        self.activityIndicator.stopAnimating()
                    })
                    
                }
                else {
                    //print("File uploaded!")
                     self.displayAlert(title: "Success!", message: "File uploaded!")
                 
                    DispatchQueue.main.async(execute: {
                           self.activityIndicator.stopAnimating()
                      })
                 
                
                    
                }
                
                
                
            })
        }  else {
         
            
            DispatchQueue.main.async(execute: {
                self.activityIndicator.stopAnimating()
            })
             
        }
    } else {
       
      
        DispatchQueue.main.async(execute: {
            self.activityIndicator.stopAnimating()
        })
       
    }
  
*/
    
   

}
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        #if DEBUG
        //print("  Done (shareButtonPressed) \(#line)   ")
        #endif
        dismiss(animated: true) {
        }
        //self.share()
    }
    //_______________________
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hostFTPTextField.delegate = self
         self.loginFTPTextField.delegate = self
         self.passwordFTPTextField.delegate = self
        
        
        
    //    self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white  )
        self.activityIndicator.color =    UIColor(red: 74.0/255.0, green: 173.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        let item = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.rightBarButtonItem = item
        self.activityIndicator.hidesWhenStopped = true
    
         // self.activityIndicator.startAnimating()
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//_______________________________
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        #if DEBUG
        //print("  viewWillAppear UploadTableViewController \(#line)   ")
        #endif
     
        self.currentFileName  = UserDefaults.standard.string(forKey: "CurrentFileName")!
        self.fileLabel.text = "file: \(self.currentFileName)"

        self.host  = UserDefaults.standard.string(forKey: "CreateDirURLText")!
        
        self.hostFTPTextField.text = self.host
        
        
        self.login  = UserDefaults.standard.string(forKey: "Username")!
        self.loginFTPTextField.text = self.login
        self.password  = UserDefaults.standard.string(forKey: "Password")!
         self.passwordFTPTextField.text = self.password
        
          // self.share()
    
    }
    
//_______________________________
    
func share() {
    var sharedObjects:[AnyObject] = []
    
    let fm = FileManager.default
    
    
  
    
    
    let pdfURL = (fm.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
    let fileURL = pdfURL.appendingPathComponent(currentFileName) as URL
    //Rename document name to NSTemporaryDirectory
    let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(currentFileName) as NSURL
     do {
        let data = try Data(contentsOf: fileURL)
        try data.write(to: url as URL)
         sharedObjects.append(url as AnyObject)
     }
    catch   {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = (dir as NSString).appendingPathComponent(currentFileName)
        if let textToShare =   try? String(contentsOfFile: filePath, encoding: String.Encoding.utf8){
            sharedObjects.append(textToShare as AnyObject)
        }
    }
    
    
    // var  activitycontroller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
    let activitycontroller = UIActivityViewController(activityItems:sharedObjects, applicationActivities: nil)
      if activitycontroller.responds(to: #selector(getter: activitycontroller.completionWithItemsHandler))
    {
        activitycontroller.completionWithItemsHandler = {(type, isCompleted, items, error) in
            if isCompleted
            {
                //print("completed = \(String(describing: type))")
               
                if  type == UIActivity.ActivityType.copyToPasteboard {
                    //print("copied to clipboard")
                   
                    let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                    let filePath = (dir as NSString).appendingPathComponent(self.currentFileName)
                    if let textToShare =   try? String(contentsOfFile: filePath, encoding: String.Encoding.utf8){
                         UIPasteboard.general.string = textToShare
                    }
                }
            }
        }
    }
    
    //activitycontroller.excludedActivityTypes = [UIActivityType.airDrop]
    activitycontroller.popoverPresentationController?.sourceView = self.shareButton
    activitycontroller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
    self.present(activitycontroller, animated: true, completion: nil)
    
    
}
//_______________________________
    
    
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      //  segue.destination.popoverPresentationController?.sourceRect =  CGRect(self.shareButton.frame.size.width/2, self.shareButton.frame.size.height, 0, 0)
    }
 

}
