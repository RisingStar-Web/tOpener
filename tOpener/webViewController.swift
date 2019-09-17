//
//  webViewController.swift
//  tOpener
//
//  Created by Valeriy PETRENKO on 17/05/2018.
//  Copyright © 2018 Slavamax BVBA. All rights reserved.
//

import UIKit
import WebKit

class webViewController: UIViewController, WKUIDelegate, WKNavigationDelegate  {

    @IBOutlet weak var webView: WKWebView!
    var document: UIDocument?
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        
        self.javascriptOnOff()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //_______________________________
    func javascriptOnOff() {
        #if DEBUG
        //print(" javascriptOnOff \(#line)   ")
        #endif
        
        
        
        let tmpBool =  UserDefaults.standard.bool(forKey: "JavaScript") as Bool?
        
        if (tmpBool != nil) {
            if tmpBool! {
                self.webView.configuration.preferences.javaScriptEnabled = true
            } else  {
                self.webView.configuration.preferences.javaScriptEnabled = false
            }
        }  else  {
            UserDefaults.standard.set(true, forKey: "JavaScript")
            UserDefaults.standard.synchronize()
        }
        
        #if DEBUG
        //print(" self.webView.configuration.preferences.javaScriptEnabled=\(self.webView.configuration.preferences.javaScriptEnabled) \(#line)   ")
        #endif
        
    }
    
        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        #if DEBUG
         //print("  viewWillAppear webViewController.swift \(#line)   ")
        #endif
             self.javascriptOnOff()
            
            
  if let htmlString =   try? String(contentsOfFile: (self.document?.fileURL.path)!, encoding: String.Encoding.utf8){
                
            let folderPath = Bundle.main.bundlePath
            let baseUrl = URL(fileURLWithPath: folderPath, isDirectory: true)
            
            self.webView.loadHTMLString(htmlString, baseURL: baseUrl)
       } else  {
            
            let htmlString:String = "<html><head><meta name ='viewport' content = 'width = device-width'  initial-scale=1.0; >" +
                "</head><body bgcolor ='#FFFFDD'><center><table width ='97%' height = '97%' >" +
                "<tr><td align ='center' valign = 'middle' >" +  "<br><br><b>you can upload this file to your website</b><br>editing is not allowed<br>FTP upload and sharing is allowed<br></td></tr></table></center></body></html>"
            
            
            DispatchQueue.main.async(execute: {
                self.webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
            })
             }
           
        
}
    
    //_______________________________
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
