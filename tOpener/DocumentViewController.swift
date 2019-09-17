//
//  DocumentViewController.swift
//  VisualHTMLeditor
//
//  Created by Valeriy PETRENKO on 08/05/2018.
//  Copyright © 2018 Slavamax BVBA. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var documentNameLabel: UILabel!
    
    var document: UIDocument?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access the document
        document?.open(completionHandler: { (success) in
            if success {
                // Display the content of the document, e.g.:
                self.documentNameLabel.text = self.document?.fileURL.lastPathComponent
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }
    
    @IBAction func dismissDocumentViewController() {
          //  let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyBoard.instantiateViewController(withIdentifier: "tab")
       
        
     //   let messagesViewController = storyboard.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
    //    self.window?.rootViewController?.present(table, animated: true, completion: nil)

        //show(navigationController, sender: nil)
        //  present(table, animated: true, completion: nil)
      
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
      
    }
}
