//
//  DocumentBrowserViewController.swift
//  Document-Based-App
//
//  Created by Valeriy PETRENKO on 01/05/2018.
//  Copyright © 2018 Slavamax BVBA. All rights reserved.
//

import UIKit





class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
let documentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editorEYE") as! ViewController
   
    var shouldPresentModalVC:Bool = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("DocumentBrowserViewController viewDidLoad")
       // delegate = self
       // self.view.backgroundColor = UIColor.white
       // self.view.isHidden = true
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        shouldPresentModalVC = true
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        //browserUserInterfaceStyle = .light
        //browserUserInterfaceStyle = .white
        // view.tintColor = .white
        
        // let myColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        // view.tintColor = myColor
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view, typically from a nib.
       
        #if DEBUG
          //print("viewDidLoad  ")
        //print(" currentFileName =\(currentFileName) \(#line)   ")
        #endif
        
    }
    
    
//===========
override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//   let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
 //BUG FIX: Move the embedded VC to be a modal VC as is expected. See viewWillAppear
if self.shouldPresentModalVC {
    var currentFileName = ""
    if let tmpString = UserDefaults.standard.string(forKey: "CurrentFileName") {
        currentFileName = tmpString
        
        if checkFileExistings(fileName: currentFileName)  {
            let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let htmlPath = (dir as NSString).appendingPathComponent(currentFileName)
            let url = URL(fileURLWithPath: htmlPath)
            self.documentViewController.document = Document(fileURL: url)
            present(documentViewController, animated: false, completion: nil)
            self.shouldPresentModalVC = false
        }
    }
    
    
        //print("** if self.shouldPresentModalVC ")
    }
}
    
//===========
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //print("DocumentBrowserViewController viewWillAppear")
        // self.view.isHidden = false
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        //BUG FIX: We have to embed the VC rather than modally presenting it because:
        // - Modal presentation within viewWillAppear(animated: false) is not allowed
        // - Modal presentation within viewDidAppear(animated: false) is not visually glitchy
        //The VC is presented modally in viewDidAppear:
      
        
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        
      //  let newDocumentURL: URL? = nil
        
        //let targetURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Untitled").appendingPathExtension("doc-extension")
        
        //print("* didRequestDocumentCreationWithHandler HTML, empty")
        /*
         let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
         completion(nil, true)
         }
         presentTemplateChooser(completion: {templateURL, canceled) in
         if canceled {
         //print("User canceled")
         }
         if let templateURL = templateURL
         {
         importHandler(templateURL, .copy)
         }
         else
         {
         importHandler(nil, .none)
         }
         
         */
        // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
        // Make sure the importHandler is always called, even if the user cancels the creation request.
        if let url = Bundle.main.url(forResource: "_NewFile", withExtension: "txt") {
            importHandler(url, .copy)
        } else {
            importHandler(nil, .none)
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        //print("sourceURL=\(sourceURL)")
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        //print("presentDocument")
       
      //   let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        
        self.documentViewController.document = Document(fileURL: documentURL)
        
        
        // let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.documentViewController.modalTransitionStyle = modalStyle
               // self.view.isHidden = false
        var controller = presentingViewController
        while let presentingVC = controller?.presentingViewController {
            controller = presentingVC
              controller?.dismiss(animated: true)
        }
        documentViewController.dismiss(animated: true)
        present(documentViewController, animated: true, completion: nil)
    }
}

