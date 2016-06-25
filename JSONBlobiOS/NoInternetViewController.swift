//
//  NoInternetViewController.swift
//  JSONBlobiOS
//
//  Created by ishant on 26/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {

    var noInternetDelegate: NoInternetDelegate?
    
    @IBOutlet weak var tryAgainButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tryAgainButton.layer.borderWidth = 1
        self.tryAgainButton.layer.borderColor = UIColor.grayColor().CGColor
        self.tryAgainButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(sender: AnyObject) {
        if Utils.isInternetConnected(){
            if let delegate = self.noInternetDelegate{
                delegate.connectedToInternet()
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    delegate.connectedToInternet()
                })
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
