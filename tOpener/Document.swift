//
//  Document.swift
//  VisualHTMLeditor
//
//  Created by Valeriy PETRENKO on 08/05/2018.
//  Copyright © 2018 Slavamax BVBA. All rights reserved.
//

import UIKit

class Document: UIDocument {
    //var htmlString: String? = "22"
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
         //print("Document  contents forType \(typeName) ")
        
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
         //print("Document  load ")
       // guard let data = contents as? Data else { return }
       /*
        if let userContent = contents as? Data {
           htmlString = NSString(bytes: (contents as AnyObject).bytes,
                                length: userContent.count,
                                encoding: String.Encoding.utf8.rawValue) as String?
             //print("htmlString=\(htmlString)")
 }
 */
    }
}

