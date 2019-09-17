//
//  infoViewController.swift
//  VisualHTMLeditor
//
//  Created by Valeriy PETRENKO on 10/05/2018.
//  Copyright © 2018 Slavamax BVBA. All rights reserved.
//

import UIKit
import SafariServices
import StoreKit

class infoViewController: UIViewController, SFSafariViewControllerDelegate, SKStoreProductViewControllerDelegate {

 
    @IBAction func donePressed(_ sender: Any) {
 
        dismiss(animated: true) {
        }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func ratePressed(_ sender: Any) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        let parameters = [SKStoreProductParameterITunesItemIdentifier : NSNumber(value: 590402807)]
        storeViewController.loadProduct(withParameters: parameters,  completionBlock: {result, error in
            if result {  self.present(storeViewController,   animated: true, completion: nil)   } })
        
    }
    
     //_______________________________
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //_______________________________
    
    @IBAction func sitePressed(_ sender: Any) {
        let safariVC = SFSafariViewController(url: NSURL(string: "https://www.slavamax.com")! as URL)
        self.present(safariVC, animated: true, completion: nil)
    }
    //_______________________________
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    //_______________________________

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
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
