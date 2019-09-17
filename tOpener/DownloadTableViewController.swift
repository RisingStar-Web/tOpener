//
//  DownloadTableViewController.swift
//  VisualHTMLeditor
//
//  Created by Valeriy PETRENKO on 25/04/2018.
//  Copyright © 2018 Slavamax BVBA. All rights reserved.
//

import UIKit
import Foundation
import CFNetwork

class DownloadTableViewController: UITableViewController,  UITextFieldDelegate, StreamDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var linkhtml : String = ""
    var er : String = ""
    var currentFileName  : String = ""
  var inputData = Data()
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var hostFTPTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadLink: UIButton!
    @IBOutlet weak var getFTP: UIButton!
    //----------
    var host : String = ""
    var login : String = ""
    var password : String = ""
    var fileNameFTP : String = ""
    //_______________________
class Downloader : NSObject, URLSessionDownloadDelegate, StreamDelegate    {
        
        var url : URL?
        // will be used to do whatever is needed once download is complete
        var obj1 : NSObject?
        
        init(_ obj1 : NSObject)
        {
            self.obj1 = obj1
        }
        
        //is called once the download is complete
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
        {
            //copy downloaded data to your documents directory with same names as source file
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let destinationUrl = documentsUrl!.appendingPathComponent(url!.lastPathComponent)
            let dataFromURL = NSData(contentsOf: location)
            dataFromURL?.write(to: destinationUrl, atomically: true)
            //now it is time to do what is needed to be done after the download
            //obj1!.callWhatIsNeeded()
            UserDefaults.standard.set(destinationUrl, forKey: "CurrentFileName")
            
              UserDefaults.standard.synchronize()
        }
        
        //this is to track progress
        private func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
        {
        }
        
        // if there is an error during download this will be called
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
        {
            if (error != nil)
            {
                //handle the error
                //print("Download completed with error: \(error!.localizedDescription)");
                
                /*
                let alert = UIAlertController(title: "Download completed with error:", message:  error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
                */
            }
        }
        
        //method to be called to download
        func download(url: URL)
        {
            self.url = url
            
            //download identifier can be customized. I used the "ulr.absoluteString"
            let sessionConfig = URLSessionConfiguration.background(withIdentifier: url.absoluteString)
            let session = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
            let task = session.downloadTask(with: url)
            task.resume()
        }}
   

  
    func displayAlert(title: String, message: String) {
        DispatchQueue.main.async(execute: {
            // work Needs to be done
       
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            if title == "Success!" {
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  {(alert: UIAlertAction!) in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateView"), object: nil)
                    self.dismiss(animated: true) {   }
                }))
            } else {
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            }
            
            self.present(alert, animated: true, completion: nil)
         })
    }

//===========
    
    static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        //print("loadFileAsync")
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(destinationUrl.path, nil)
        }
        else
        {
            #if DEBUG
            //print("  line \(#line)   ")
            #endif
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {  data, response, error in
                if error == nil
                {
                    #if DEBUG
                    //print("  line \(#line)   ")
                    #endif
                    
                    if let response = response as? HTTPURLResponse
                    {
                        #if DEBUG
                        //print("  line \(#line)   ")
                        #endif
                        
                        if response.statusCode == 200
                        {
                            #if DEBUG
                            //print("  line \(#line)   ")
                            #endif
                            
                            if let data = data
                            {
                                #if DEBUG
                                //print("  line \(#line)   ")
                                #endif
                                
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    #if DEBUG
                                    //print("  line \(#line)   ")
                                    #endif
                                    
                                      UserDefaults.standard.set(url.lastPathComponent, forKey: "CurrentFileName")
                                      UserDefaults.standard.synchronize()
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    #if DEBUG
                                    //print("  line \(#line)   ")
                                    #endif
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                #if DEBUG
                                //print("  line \(#line)   ")
                                #endif
                                completion(destinationUrl.path, error)
                            }
                            #if DEBUG
                            //print("  line \(#line)   ")
                            #endif
                        }
                        #if DEBUG
                        //print("  line \(#line)   ")
                        #endif
                    }
                    #if DEBUG
                    //print("  line \(#line)   ")
                    #endif
                }
                else
                {
                    #if DEBUG
                    //print(" MY ERROR error =  \(String(describing: error))  line \(#line)   ")
                    //print("  line \(#line)   ")
                    #endif
                    completion(destinationUrl.path, error)
                }
                #if DEBUG
                //print(" MY ERROR error2 =  \(String(describing: error))  line \(#line)   ")
                #endif
            })
            #if DEBUG
            //print("  line \(#line)   ")
            #endif
            task.resume()
        }
        #if DEBUG
        //print("  line \(#line)   ")
        #endif
    }
//===========
    
    @IBAction func doneButtonpressed(_ sender: UIButton) {
        #if DEBUG
        //print(" doneButtonpressed \(#line)   ")
        #endif
        dismiss(animated: true) {
        }
    }
    
    
//===========
    func checkFileExistings(fileName: String) -> Bool  {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                return true
            } else {
                // //print("FILE NOT AVAILABLE")
                return false
            }
        } else {
            // //print("FILE PATH NOT AVAILABLE")
            return false
        }
    }
    
//===========
    func fileExistsAt  (url: URL, completion: @escaping (Bool) -> Void) {
        let checkSession = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 1.0
       
        let task = checkSession.dataTask(with: request) { (data, response, error) -> Void in
            if let httpResp = response as? HTTPURLResponse {
            completion(httpResp.statusCode == 200) }
            
        }
        task.resume()
        
    }
    
        //===========
    @IBAction func loadLinkPressed(_ sender: UIButton) {
        //print("loadLinkPressed")
     
        
        if ( linkTextField.text ==  "" )
           {
         
            
            self.displayAlert(title: "Attention!", message:"enter URL please")
            
            
           }
        else
         {
            
        if let object = linkTextField.text  {
            self.linkhtml = object
            if let   url1 = URL(string: object) {
        
            //print("url1=\(url1)")
                
                let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let lastPathComponentURL = url1.lastPathComponent
                let destinationUrl = documentsUrl.appendingPathComponent(lastPathComponentURL)
                if FileManager().fileExists(atPath: destinationUrl.path)
                {
                    
               
       if ((lastPathComponentURL == "")  || (lastPathComponentURL == "/"))
        
       {
        self.displayAlert(title:"Enter the full name", message: "On most web servers, the default page in a directory is named index.html. A web server can be configured to recognize any file you want as the default for that site.")
          
          return
                    }

          
                    self.displayAlert(title:"The  \(lastPathComponentURL) exists on device", message: "Rename or delete the file to download the new copy.")
                    
                    return
                }
             
                
              fileExistsAt (url: url1, completion:  { (answer) in
                //print("*** answer == \(answer)")
                
                if answer {
                    DispatchQueue.main.async(execute: {
                         self.activityIndicator.startAnimating()
                    })
                    
                   
                    //print("*** error == nil")
                    DownloadTableViewController.loadFileAsync(url: url1, completion:{ (path, error) in
                        
                        if error == nil
                        {
                            //print("*** error == nil")
                            
                        }
                            // guard error == nil
                        else {
                            //print("error:  \(error!.localizedDescription)")
                            
                            self.displayAlert(title: "Download completed with error:", message: error!.localizedDescription)
                                  self.activityIndicator.stopAnimating()
                            return
                            
                        }
                        
                        if path == nil
                        {
                            //print("*** path == nil")
                        }
                            // guard path == nil
                        else {
                            //print("file downloaded to: \(path ?? "")")
                            
                            DispatchQueue.main.async(execute: {
                                // work Needs to be done
                                
                                   UserDefaults.standard.set(self.linkhtml, forKey: "GetURLText")
                                  UserDefaults.standard.synchronize()
                                    self.activityIndicator.stopAnimating()
                              
                                
                                self.displayAlert(title: "Success!", message: "File has been downloaded!")
                                
                                
                                
                                // возврат в редектор
                               // _ = self.navigationController?.popToRootViewController(animated: true)
                               // self.dismiss(animated: true) {  }
                            })
                            
                            
                        }
                        
                        
                        
                        
                    })
                } else  {
                    self.displayAlert(title: "File not found on the server.", message: "")
                    self.activityIndicator.stopAnimating()
                 }
              })
                
                /*
        DownloadTableViewController.loadFileAsync(url: url1, completion:{ (path, error) in
            
            if error == nil
            {
                  //print("*** error == nil")
               
             }
           // guard error == nil
             else {
                //print("error:  \(error!.localizedDescription)")
                
                self.displayAlert(title: "Download completed with error:", message: error!.localizedDescription)
               return
                
                }
            
            if path == nil
            {
                 //print("*** path == nil")
                 }
           // guard path == nil
                else {
                 //print("file downloaded to: \(path ?? "")")
                
                DispatchQueue.main.async(execute: {
                    // work Needs to be done
                      _ = self.navigationController?.popToRootViewController(animated: true)
                })
              
                
            }
           
            
          
            
             })
                 */
        // check if exist
         //  //print("999+++++")
        //
            } // let   url1 = URL(string: object)
            else {
                self.displayAlert(title: "Enter error:", message: "Unable to retrieve URL")
            }
           
            
               // Downloader(url1! as NSObject).download(url: url1!)
             } //   if let object = linkTextField.text
         }
  }
    
//_______________________
 
 
    
    @IBAction func getFTPpressed(_ sender: UIButton) {
         //print("getFTPpressed")
        
        if let fileString = self.fileNameTextField.text, !fileString.isEmpty
        { //do something if it's not empty
            //  hostString
            if self.checkFileExistings(fileName: fileString)  {
                self.displayAlert(title:"The  \(fileString) exists on device", message: "Rename or delete the file to download the new copy.")
                self.fileNameTextField.becomeFirstResponder()
                return
             }
            
            self.fileNameFTP = fileString
            
            
        } else  { //do something if it's not empty
            self.displayAlert(title: "Attention!", message: "Enter file name please")
            self.fileNameTextField.becomeFirstResponder()
            return
        }
    
        if let hostString = self.hostFTPTextField.text, !hostString.isEmpty
        { //do something if it's not empty
            //  hostString
            self.host = hostString
        } else  { //do something if it's not empty
            self.displayAlert(title: "Attention!", message: "Enter FTP host please")
            self.hostFTPTextField.becomeFirstResponder()
            return
        }
        
        
        if let loginString = self.loginTextField.text, !loginString.isEmpty
        { //do loginString if it's not empty
            self.login = loginString
        } else  { //do something if it's not empty
            self.displayAlert(title: "Attention!", message: "Enter FTP login please")
            self.loginTextField.becomeFirstResponder()
            return
        }
        
        if let passwordString = self.passwordTextField.text, !passwordString.isEmpty
        { //do something if it's not empty
            self.password  =    passwordString
        } else  { //do something if it's not empty
            self.displayAlert(title: "Attention!", message: "Enter FTP password please")
            self.passwordTextField.becomeFirstResponder()
            return
        }
        
        self.view.endEditing(true)
        
        DispatchQueue.main.async(execute: {
            self.activityIndicator.startAnimating()
        })
        
        
     //   linkTextField.text =  "ftp://ordodei:#Flopopo1965@ftp.slavamax.com/index.html"
        
        let filedata : Data =  NSData() as Data
        
        DispatchQueue.global(qos: .background).async {
            
            let ftpup =  FTPDownload(baseUrl:  self.host, userName:  self.login, password: self.password, directoryPath: "")
            
            ftpup.send(data: filedata, with: self.fileNameFTP, success: {(success) -> Void in
                
                
                
                if !success {
                    //print("Failed download!")
                    self.displayAlert(title: "Attention!", message: "Failed download!\r Common Reasons: incorrect entering your host, username, password;  hosting server problems; the file is not exist e.t.c.")
                    
                    
                    DispatchQueue.main.async(execute: {
                        self.activityIndicator.stopAnimating()
                    })
                    
                }  else {
                    //print("File download!")
                    
                    
                    DispatchQueue.main.async(execute: {
                        UserDefaults.standard.set(self.fileNameFTP, forKey: "CurrentFileName")
                        UserDefaults.standard.set(self.fileNameFTP, forKey: "GetFileNamed")
                        UserDefaults.standard.set(self.host, forKey: "URLGetURLText")
                        UserDefaults.standard.set(self.login, forKey: "UsernameGet")
                        UserDefaults.standard.set(self.password, forKey: "PasswordGet")
                        UserDefaults.standard.synchronize()
                        
                     
                        
                        self.activityIndicator.stopAnimating()
                        self.displayAlert(title: "Success!", message: "File has been downloaded!")
                        
                        
                       // _ = self.navigationController?.popToRootViewController(animated: true)
                        //self.dismiss(animated: true) {    }
                    })
                    
                    
                    
                }
                
                
                
            })
        } //DispatchQueue.global(qos: .background).async
        
        //  "ftp://editoreye:flopopo1.@ftp.slavamax.com/books.html"
        //  ftp://ordodei:#Flopopo1965@ftp.slavamax.com/index.html
        
      //  func OpenAndTestFTPConn(user:NSString, pass:NSString) -> Bool {
            
        //self.OpenAndTestFTPConn()
       // self.openFTPConnection2()
       // self.loadLinkPressed(sender)
        
    }
    
//_______________________
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    #if DEBUG
    //print("  viewWillAppear DownloadTableViewController \(#line)   ")
    #endif
    
    
    
    self.linkTextField.text  = UserDefaults.standard.string(forKey: "GetURLText")!
 
    self.fileNameTextField.text = UserDefaults.standard.string(forKey: "GetFileNamed")!
    
    self.currentFileName  = UserDefaults.standard.string(forKey: "CurrentFileName")!
    //self.fileLabel.text = "file: \(self.currentFileName)"
    self.host  = UserDefaults.standard.string(forKey: "URLGetURLText")!
    self.hostFTPTextField.text = self.host
    self.login  = UserDefaults.standard.string(forKey: "UsernameGet")!
    self.loginTextField.text = self.login
    self.password  = UserDefaults.standard.string(forKey: "PasswordGet")!
    self.passwordTextField.text = self.password
    
    
}
    
//_______________________
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fileNameTextField.delegate = self
        self.hostFTPTextField.delegate = self
        self.loginTextField.delegate = self
        self.passwordTextField.delegate = self
        
       // self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white  )
        self.activityIndicator.color =    UIColor(red: 74.0/255.0, green: 173.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        let item = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.rightBarButtonItem = item
        self.activityIndicator.hidesWhenStopped = true
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

 //_______________________
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//_______________________
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
