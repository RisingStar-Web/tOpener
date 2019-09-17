

//
//  ViewController.swift
//  VisualHTMLeditor
//
//  Created by Valeriy PETRENKO on 13/04/2018.
//  Copyright © 2018 Slavamax BVBA. All rights reserved.
//
//<!--<body bgcolor = "#EBEBF1">-->

import UIKit

import CloudKit

extension UIButton {
       func setAnimation() {
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        let myColor = UIColor.white
            // UIColor(red: 174.0/255.0, green: 189.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        colorAnimation.fromValue =  myColor.cgColor
        colorAnimation.duration = 0.5  // animation duration
        self.layer.add(colorAnimation, forKey: "ColorPulse")
    }
}

class ViewController: UIViewController,  UIGestureRecognizerDelegate, UITextViewDelegate  {
    @IBOutlet weak var labelFilenam: UILabel!
    
   // , WKNavigationDelegate
        var document: UIDocument?
        var document2: Document?
    
     var fileSize : UInt64 = 0
    
    let undoFileName1 : String = "undoFileName1zxcz"
    let undoFileName2 : String = "undoFileName2cvbn"
    let undoFileName3 : String = "undoFileName3uiop"
    
    var currentEditingString : String = ""
    
    var undoCount : Int = 0
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textVewBottomConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBOutlet weak var slavamaxButton: UIButton!
    @IBOutlet weak var appsButton: UIButton!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    //@IBOutlet weak var infoButton: UIButton!
    //@IBOutlet weak var currentFileNameButton: UIButton!
 
    @IBOutlet weak var redoButton: UIBarButtonItem!
    //@IBOutlet weak var refreshButton: UIButton!
   // @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var undoButton: UIBarButtonItem!
    //@IBOutlet weak var redoButton: UIButton!
    
    
    var heightKeyboard : CGFloat? = 170
    var currentFileName : String = "~index.html"
    

/*
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //print(error.localizedDescription)
    }
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //print("Start to load")
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print("finish to load")
    }
    
    */
    //_______________________________
//_______________________________
    
    func covertToFileString(with size: UInt64) -> String {
        var convertedValue: Double = Double(size)
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }
//_______________________________
    func readFile()
    {
          //print("\r\r\r  readFile \(#line) ")
        //let fileExtension = (self.document?.fileURL)!.pathExtension // pdf
        //print(" \(#line)  fileExtension =\(fileExtension)")
        
        let resultDictionary =  NSDictionary(contentsOf:(self.document?.fileURL)!)
        //print(resultDictionary?.description as Any)
        
        let file = "tmp.txt"  //this is the file. we will write to and read from it
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file) as NSURL
        
      
        
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: resultDictionary as Any, format: .xml, options: 0)
            try plistData.write(to: fileURL as URL)
          
            do {
                let tmp = try String(contentsOf: fileURL as URL, encoding: .utf8)
                 //print(" \(#line) tmp =\(tmp)  \(#line) ")
                self.textView.text = tmp
                
                
                DispatchQueue.main.async(execute: {
                    // work Needs to be done
                    
                    let alert = UIAlertController(title: "Note", message: "The binary file has been converted to the source code.", preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                  
                    
                    self.present(alert, animated: true, completion: nil)
                })
            } catch {
              
                //print("\(#line) Failed 118: \(fileURL), Error: " + error.localizedDescription)
                   return
            }
        } catch {
            
             //print("\(#line)  Error: " + error.localizedDescription)
            return
        }
       
         //print("\r\r\r  readFile \(#line) ")
        
     //   @"Note:"
      
     //   delegate:nil
     //   cancelButtonTitle:@"Ok"
       // var path: NSString = NSBundle.mainBundle().pathForResource("bhsCustom", ofType: "plist")!
        
        
        // Get host link from plist
     //   let wordList = Dictionary(content:(self.document?.fileURL)!)
      //  var webLink: NSString = wordList.objectForKey("about_bhs") as NSString
  
        //print("\r\r\r  \(#line)  webLink= \(webLink) ")
       // let filePath = getURL(for: path).path + "/" + name
     /*
        
        var data = Data()
      do {
          data = try Data(contentsOf:(self.document?.fileURL)!)
      } catch {
        //print("\(#line)  Error: " + error.localizedDescription)
     }
        
        
        let file = "tmp.txt"  //this is the file. we will write to and read from it
      
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file) as NSURL
       
        do {
            try  data.write(to: fileURL as URL, options: Data.WritingOptions.atomic)
         } catch {
            //print("\(#line) Failed writing  URL: \(fileURL), Error: " + error.localizedDescription)
        }
        
        do {
            let tmp = try String(contentsOf: fileURL as URL, encoding:String.Encoding(rawValue: 0))
            //print(" \(#line) tmp =\(tmp)  \(#line) ")
            
        } catch {
            //print("\(#line) Failed 118: \(fileURL), Error: " + error.localizedDescription)
        }
     */
       
        return
    }
 
//_______________________________
func loadContent() {
   // self.readFile(at: "", withName: "")
    #if DEBUG
      //print("  func loadContent \(#line)   ")
    #endif
    /*
    if let tmpString = UserDefaults.standard.string(forKey: "CurrentFileName") {
        self.currentFileName = tmpString
     }
    */
    #if DEBUG
      //print(" currentFileName =\(currentFileName) \(#line)   ")
    #endif
    
 //   let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
  //  let htmlPath = (dir as NSString).appendingPathComponent(self.currentFileName)
    //---file Size------
     // do {
        //return [FileAttributeKey : Any]
     //   let attr = try FileManager.default.attributesOfItem(atPath:  (self.document?.fileURL.path)!)
      //  fileSize = attr[FileAttributeKey.size] as! UInt64
      //   } catch {
        //print("Error: \(error)")
     // }
    //-----------
    //let url = URL(fileURLWithPath: htmlPath)
    //let request = URLRequest(url: url)
    // webView.load(request)
   // if let htmlString = try? String(contentsOfFile: htmlPath)
    
    
   // textView.text =  self.document2?.htmlString
    
  //  //print("textView.text = \(textView.text)")
  //  webView.loadHTMLString((self.document2?.htmlString)!, baseURL: Bundle.main.bundleURL)
 //   currentEditingString =  (self.document2?.htmlString)!
      //print(" start if let htmlString   \(#line) ")
 // if let htmlString =   try? String(contentsOfFile: (self.document?.fileURL.path)!, encoding: String.Encoding.utf8){
    //  if let htmlString =   try? String(contentsOfFile: (self.document?.fileURL.path)!){
    
    var htmlString = ""
    self.textView.text = ""
    do {
        htmlString = try String(contentsOf: (self.document?.fileURL)!, encoding:.utf8)
        //print(" if let htmlString   \(#line) ")
        self.textView.text = htmlString
        currentEditingString = htmlString
       // self.textView.text = htmlString
    } catch {
        //print("\(#line) Failed reading from URL: \((self.document?.fileURL)!)), Error: " + error.localizedDescription)
        
         self.readFile()
        
        if  self.textView.text == "" {
            
          let  tmpStr = "Probably <" + self.currentFileName + "> isn't a text file. \nEditing is not allowed.  \nFTP upload and sharing are allowed. \n\nNot opens a text file? Please contact tOpener@slavamax.com"
          self.textView.text = tmpStr
        self.textView.isUserInteractionEnabled = false
        
        self.refreshButton.isEnabled = false
        self.undoButton.isEnabled = false
        self.redoButton.isEnabled = false
              }
        #if DEBUG
        //print("cannot retrieve htmlString from \(currentFileName) \(#line)   ")
        #endif
        //let newStr1 = String(data: data.subdata(in: 0 ..< data.count - 1), encoding: .utf8)
       /*
        do {
            htmlString = try  String(contentsOf: (self.document?.fileURL)!, encoding: .macOSRoman )
            //print(" if let htmlString   \(#line) ")
            self.textView.text = htmlString
        } catch {
            //print("\(#line) Failed reading from URL: \((self.document?.fileURL)!)), Error: " + error.localizedDescription)
            textView.text = ""
            
            
            textView.isUserInteractionEnabled = false
            
            self.refreshButton.isEnabled = false
            self.undoButton.isEnabled = false
            self.redoButton.isEnabled = false
          }
       */
        
       // textView.isUserInteractionEnabled = false
        
      //  self.refreshButton.isEnabled = false
      //  self.undoButton.isEnabled = false
      //  self.redoButton.isEnabled = false
        
            }
    
    

        
    
        
    // htmlString =   "<div style='width:100%;height:100px'></div>"+htmlString
        //webView.navigationDelegate = self
        //view = webView
        
      //  let folderPath = Bundle.main.bundlePath
       // let baseUrl = URL(fileURLWithPath: folderPath, isDirectory: true)
        
      //  self.webView.loadHTMLString(htmlString, baseURL: baseUrl)
        
    
  //  } else {
        
    
        
        //let url: NSString = "http://hr-platform.nv5.pw/image/comp_1/pdf-test.pdf" // http://hr-platform.nv5.pw/image/comp_1/pdf-test.pdf
        //let fileExtension = url.pathExtension // pdf
        //let urlWithoutExtension = url.deletingPathExtension // http://hr-platform.nv5.pw/image/comp_1/pdf-test
        //As @David Berry suggested use the URL-class:
        //let url = URL(string: "http://hr-platform.nv5.pw/image/comp_1/pdf-test.pdf")
        //let fileExtension = url?.pathExtension // pdf
        //let fileName = url?.lastPathComponent // pdf-test.pdf
        
  //  }
  
    UserDefaults.standard.set(self.currentFileName, forKey: "CurrentFileName")
    UserDefaults.standard.synchronize()
   
  }
//_______________________________
    
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
    
@objc func updateView(notification: NSNotification) {
    #if DEBUG
    //print("updateView \(#line)   ")
    #endif
    var currentFileName = ""
    if let tmpString = UserDefaults.standard.string(forKey: "CurrentFileName") {
        currentFileName = tmpString
        #if DEBUG
        //print("currentFileName=\(currentFileName) \(#line)   ")
        #endif
        if checkFileExistings(fileName: currentFileName)  {
            let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let htmlPath = (dir as NSString).appendingPathComponent(currentFileName)
            let url = URL(fileURLWithPath: htmlPath)
            self.document = Document(fileURL: url)
        }
    }
    
  self.loadContent()
}
    
 //_______________________________
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
//_______________________________
    func share(sender:UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let textToShare = "Check out my app"
        
        if let myWebsite = URL(string: "http://itunes.apple.com/app/id471830978") {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }    }
    
 //_______________________________
     /*
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
        let textCount: Int = textView.text.count
        guard textCount >= 1 else { return }
       textView.scrollRangeToVisible(NSMakeRange(textCount - 1, 1))
        
    }
 
   
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print("func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)")
    }
//_______________________________
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
           //print("decidePolicyFor 1")
         // decisionHandler(.allow)
        decisionHandler(.cancel  )
        guard (navigationAction.request.url?.absoluteString) != nil else { return }
            //print("decidePolicyFor 2")
          //  decisionHandler(.allow)
        
    }
 */
//_______________________________
override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
     textView.delegate = self
    //self.loadContent()
        
        let notificationCenter = NotificationCenter.default


    
 notificationCenter.addObserver(self, selector: #selector(ViewController.updateView), name: NSNotification.Name(rawValue: "updateView"), object: nil)
        
 
notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardShown), name: UIResponder.keyboardWillShowNotification, object: nil)

notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardShown), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    

notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
//Dismiss keyboard when touching outside of UITextField or UITextView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
       tapGesture.cancelsTouchesInView = false
         tapGesture.numberOfTapsRequired = 1
      //  self.view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
       //self.webView.addGestureRecognizer(tapGesture)
    //self.webView.navigationDelegate = self as! WKNavigationDelegate
       self.view.isUserInteractionEnabled = true
        
        //currentFileNameButton.showsTouchWhenHighlighted = true
 
    }
//______________________________
// Dismiss keyboard when touching outside of UITextField or UITextView:
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touchesBegan")
        if touches.first != nil {
            // ...
            self.textView.endEditing
        }
        super.touchesBegan(touches, with: event)
    }
 */
//_______________________________
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
//_______________________________
@objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
       //print("dismissKeyboard")
   // touch
    if textView.isFirstResponder{
    
 
    let touchPoint = sender.location(in: self.view)
    let DynamicView = UIView(frame: CGRectMake(touchPoint.x-25, touchPoint.y-25, 50, 50))
    //let scrollView = UIScrollView()
    
   // scrollView.frame = CGRect(0,0,self.view.frame.width,self.view.frame.height)
    
    
   // DynamicView.backgroundColor=UIColor.green
    DynamicView.layer.cornerRadius=25
    DynamicView.layer.borderWidth=0
    self.view.addSubview(DynamicView)
    let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
    let myColor = UIColor(red: 174.0/255.0, green: 189.0/255.0, blue: 227.0/255.0, alpha: 1.0)
    colorAnimation.fromValue =  myColor.cgColor
    colorAnimation.duration = 0.7  // animation duration
   DynamicView.layer.add(colorAnimation, forKey: "ColorPulse")
    DispatchQueue.main.asyncAfter(deadline: .now() +  0.7  ) { // change 2 to desired number of seconds
        // Your code with delay
         DynamicView.removeFromSuperview()
    }
   
    
    
    //--------------
    
     self.textView.resignFirstResponder()
     self.textView.endEditing
     }
}
//_______________________________
  @objc func keyboardWillHide(notification: NSNotification) {
     ////print("keyboardWillHide")
    // self.textVewBottomConstrant.constant = 0
    }
//_______________________________
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
@objc func keyboardShown(notification: NSNotification) {
    
     guard let info = notification.userInfo else { return }
      //  let info = notification.userInfo!
      let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue   
        self.heightKeyboard = keyboardFrame.size.height
        ////print("keyboardFrame: \(keyboardFrame)")
    
    //if (Int(self.heightKeyboard!) < 170)  { self.heightKeyboard = 0 }
    
  //  self.textVewBottomConstrant.constant = self.heightKeyboard
    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
    textView.contentInset = contentInsets
    
    self.textView.layoutIfNeeded()
    
    //self.textView.contentInset.bottom = keyboardFrame.size.height
   // self.textView.scrollIndicatorInsets.bottom = keyboardFrame.size.height
 
}
   
//_______________________________
@IBAction func currentFileNameButtonPressed(_ sender: Any) {
    
   
    dismiss(animated: true) {
        self.document?.close(completionHandler: nil)
    }
}
    
//_______________________________
    
@IBAction func infoButtonPressed(_ sender: UIButton) {
//print("infoButtonPressed")
    
    //make screenshot of view
  //  self.share(sender:self.view)
    //
}
    

   
@IBAction func appsButtonPressed(_ sender: UIButton) {
//print("appsButtonPressed")


}

//_______________________________
    @IBAction func slavamaxButtonPressed(_ sender: UIButton) {
//print("slavamaxButtonPressed")
  
}
//_______________________________
 
    func showPageInSafari(_ webPage: String) {
        //print("showPageInSafari")
        
     //   let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
     //   self.present(safariVC, animated: true, completion: nil)
        
        /*
        var getURLText = "https://www.slavamax.com"
        if let  tmpString :String = UserDefaults.standard.string(forKey: "GetURLText") {
       
            getURLText = tmpString
        }
        
        //print("GetURLText =\(getURLText)")
        
        
        
      
        
        
        let alertController = UIAlertController(title: "Enter your web page address", message: "The URL must use the http or https scheme", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            if let master = alertController.textFields?[0].text {
                  //print("fffffff  \(master)  ")
                var tmpMaster = master
                
                if tmpMaster == ""  {
                    tmpMaster = getURLText
                }
                
                
                
                    UserDefaults.standard.set(tmpMaster, forKey: "GetURLText")
                    
                    if ((tmpMaster.lowercased().hasPrefix("http://")==false)&&(tmpMaster.lowercased().hasPrefix("https://")==false)) {
                        tmpMaster = "http://" + tmpMaster
                    }
                   // tmpMaster = "https://google.com" //for test
                  //print("new file name \(master)")
                    let safariVC = SFSafariViewController(url: NSURL(string: tmpMaster)! as URL)
                    self.present(safariVC, animated: true, completion: nil)
                    
                
             } // master = alertController.textFields?[0].text
            else {
                //print("Unable to retrieve file name.")
            }
         }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = getURLText
              textField.text = getURLText
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
        
        
            */
            
    }
    //_______________________________
    


    @IBAction func downloadButtonPressed(_ sender: UIButton) {
   //print("downloadButtonPressed")
        sender.setAnimation()
    }

//_______________________________
    
    
@IBAction func uploadButtonPressed(_ sender: UIButton) {
   //print("uploadButtonPressed")
    sender.setAnimation()
}
    
    
//_______________________________
    
    

    
//_______________________________
    
    func showUndoCount() {
        
          //print("showUndoCount undoCount=\(undoCount)")
        
        switch undoCount {
        case -1, 1 :
            let file = undoFileName1  //this is the file. we will write to and read from it
            //let text = textView.text //just a text
            //if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                //let fileURL = dir.appendingPathComponent(file)
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file) as NSURL
            do {
                let text =  try String(contentsOf: fileURL as URL, encoding: .utf8)
                textView.text = text
                //webView.loadHTMLString(text, baseURL: Bundle.main.bundleURL)
            }
            catch {/* error handling here */}
            
                
            
        case -2,2 :
            let file = undoFileName2  //this is the file. we will write to and read from it
            //let text = textView.text //just a text
            
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file) as NSURL
            do {
                let text =  try String(contentsOf: fileURL as URL, encoding: .utf8)
                textView.text = text
                //webView.loadHTMLString(text, baseURL: Bundle.main.bundleURL)
            }
            catch {/* error handling here */}
            
            
        case -3,3 :
            let file = undoFileName3  //this is the file. we will write to and read from it
            //let text = textView.text //just a text
            
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file) as NSURL
            do {
                let text =  try String(contentsOf: fileURL as URL, encoding: .utf8)
                textView.text = text
                
                    //self.webView.loadHTMLString(text, baseURL: Bundle.main.bundleURL)
                
               
            }
            catch {/* error handling here */}
            
        case 0 :
            textView.text = currentEditingString
            /*
             ar tmpStr = currentEditingString
            if currentEditingString ==   ""  {
              //tmpStr =
                "<html><head><meta name ='viewport' content = 'width = device-width'  initial-scale=1.0; >" +
                    "</head><body bgcolor ='#FFFFDD'><center><table width ='97%' height = '97%' >" +
                    "<tr><td align ='center' valign = 'middle' >" +
                    self.currentFileName + "<br><br><b>you can upload this file to your website</b><br><br>editing is not allowed<br>FTP upload and sharing is allowed<br></td></tr></table></center></body></html>"
                 }
            webView.loadHTMLString(tmpStr, baseURL: Bundle.main.bundleURL)
            */
        default:
            if (undoCount > 3)   { undoCount = 3 }
            if (undoCount < -3)   { undoCount = -3 }
            
            let file = currentFileName  //this is the file. we will write to and read from it
            //let text = textView.text //just a text
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent(file)
                do {
                    let text = try String(contentsOf: fileURL, encoding: .utf8)
                    textView.text = text
                  //  webView.loadHTMLString(text, baseURL: Bundle.main.bundleURL)
                    DispatchQueue.main.async(execute: {
                        //self.webView.loadHTMLString(text, baseURL: Bundle.main.bundleURL)
                    })
                }
                catch {/* error handling here */}
            }
        } // end of switch undoCount
        
        
    }
    
//_______________________________
    
    @IBAction func redoButtonPressed(_ sender: Any) {
   
    //print("redoButtonPressed")
    //sender.setAnimation()
    
    undoCount = undoCount + 1
      self.showUndoCount()
}
    
//_______________________________

    @IBAction func undoButtonPressed(_ sender: Any) {
    
    
    //print("undoButtonPressed")
//sender.setAnimation()
    
    undoCount = undoCount - 1
    self.showUndoCount()
}

//_______________________________
    
func safeUndo() {
    
    let file = currentFileName  //this is the file. we will write to and read from it
    
    var text = "" //just a text
    var text2 = "" //just a text
    var text3 = "" //just a text
    
    
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        /*
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
         
 */
        let fileURL = dir.appendingPathComponent(file)
        
        let dirUndo = URL(fileURLWithPath: NSTemporaryDirectory()) as NSURL
        
        let fileURLundo1 = dirUndo.appendingPathComponent(undoFileName1)
        let fileURLundo2 = dirUndo.appendingPathComponent(undoFileName2)
        let fileURLundo3 = dirUndo.appendingPathComponent(undoFileName3)
        
        //reading fileURLundo2
        do {
            text = try String(contentsOf: fileURLundo2!, encoding: .utf8)
        }
        catch {/* error handling here */}
        
         //writing fileURLundo3
        do {
            try text.write(to: fileURLundo3!, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
        
      
        
        //reading fileURLundo1
        do {
            text2 = try String(contentsOf: fileURLundo1!, encoding: .utf8)
        }
        catch {/* error handling here */}
        
        //writing fileURLundo2
        do {
            try text2.write(to: fileURLundo2!, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
        
        
        
        //reading currentFileName
        do {
            text3 = try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch {/* error handling here */}
        
        //writing fileURLundo1
        do {
            try text3.write(to: fileURLundo1!, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
    }
    
}
    
    
//_______________________________
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
    
    #if DEBUG
    //print("  refreshButtonPressed \(#line)   ")
    #endif
    //sender.setAnimation()
    self.undoCount = 0
    self.safeUndo()
    
    
   // document?.userText = documentText.text
    
    if  let text = textView.text,   !text.isEmpty  //just a text
    {
    if let url = document?.fileURL {
        
        //writing
        do {
            try text.write(to: url, atomically: false, encoding: .utf8)
        }
        catch {
          //print("  /* error handling here */")
            
        }
        
        
        //reading
        /*
        do {
            let text2 = try String(contentsOf: url, encoding: .utf8)
             webView.loadHTMLString(text2, baseURL: Bundle.main.bundleURL)
            DispatchQueue.main.async(execute: {
                //self.webView.loadHTMLString(text2, baseURL: Bundle.main.bundleURL)
            })
        }
        catch {
              //print(" 2 /* error handling here */")
            
        }
        */
        
        /*
        document?.save(to: url,
                       for: .forOverwriting,
                       completionHandler: {(success: Bool) -> Void in
                        if success {
                            //print("File overwrite OK")
                        } else {
                            //print("File overwrite failed")
                        }
        })
 */
    }
    }
    /* if  let text = textView.text,   !text.isEmpty
     
     
    let file = currentFileName  //this is the file. we will write to and read from it
    
    if  let text = textView.text,   !text.isEmpty  //just a text
    {
    
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        let fileURL = dir.appendingPathComponent(file)
        
        //writing
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
        
        //reading
        do {
            let text2 = try String(contentsOf: fileURL, encoding: .utf8)
            webView.loadHTMLString(text2, baseURL: Bundle.main.bundleURL)
        }
        catch {/* error handling here */}
    }
   } //  text = textView.text,   !text.isEmpty
    */
      /*
    let fileName = "Test"
    let dir = try? FileManager.default.url(for: .documentDirectory,
                                           in: .userDomainMask, appropriateFor: nil, create: true)
    
    // If the directory was found, we write a file to it and read it back
    if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
        
        // Write to the file named Test
        let outString = "Write this text to the file"
        do {
            try outString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            //print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
        }
        
        
        
        // Then reading it back from the file
     
        var inString = ""
        do {
            inString = try String(contentsOf: fileURL)
        } catch {
            //print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
        //print("Read from the file: \(inString)")
 
    }
    */
}
//_______________________________
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//_______________________________
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        #if DEBUG
        //print("  viewWillAppear ViewController \(#line)   ")
        #endif
        self.textView.isUserInteractionEnabled = true
        self.refreshButton.isEnabled = true
        self.undoButton.isEnabled = true
        self.redoButton.isEnabled = true
        
        self.undoCount = 0
         
        
        
        
        document?.open(completionHandler: { (success) in
            if success {
                // Display the content of the document, e.g.:
               
                 ////print(" \(#line) self.document2?.htmlString = \(self.document2?.htmlString)")
               // self.textView.text =  self.document2?.htmlString
                
             //   //print(" \(#line) textView.text = \(self.textView.text)")
                
                #if DEBUG
                //print("   Display the content of the document, e.g.: \(#line)   ")
                #endif
                self.currentFileName = (self.document?.fileURL.lastPathComponent)!
                 
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
        
        
        
         self.currentFileName = (self.document?.fileURL.lastPathComponent)!
      
        
        #if DEBUG
        //print("  self.document?.fileURL: \( (self.document?.fileURL.lastPathComponent)!)   ")
        //print("  self.currentFileName: \(self.currentFileName)   ")
        #endif
        
        // self.currentFileNameButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
       // self.currentFileNameButton.setTitle("  \(self.currentFileName)  ", for: .normal)
        self.labelFilenam.text = self.currentFileName
        
        self.loadContent()
     // self.textView.becomeFirstResponder()
        
     
        // Hide the navigation bar on the this view controller
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
      
    }
    
//_______________________________
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        #if DEBUG
        //print("  viewWillDisappear \(#line)   ")
        #endif
        self.refreshButtonPressed(self.refreshButton)
       // self.refreshButton.sendActions(for: .touchUpInside)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
//_______________________________
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      if let seg = segue.identifier  {
        #if DEBUG
        //print(" \(#line)    segue.identifier=  \(seg)  ")
        #endif
        switch seg {
        case "segueToDownload":
            let vc = segue.destination
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            vc.modalTransitionStyle = modalStyle
            break
        case "infoSegue":
            let vc = segue.destination
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            vc.modalTransitionStyle = modalStyle
            break
         case "seeWebView":
             let vc = segue.destination as! webViewController
             vc.document = self.document
             let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
             vc.modalTransitionStyle = modalStyle
             break
        default:
            let vc = segue.destination
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            vc.modalTransitionStyle = modalStyle
            break
        }
      }
    }
//_______________________________
}

