//
//  WHLoginViewController.swift
//  Whoot
//
//  Created by Andre Green on 1/15/16.
//  Copyright © 2016 Andre Green. All rights reserved.
//

import UIKit

class WHLoginViewController: UIViewController {
    // IB vars
    @IBOutlet weak var FaceBookLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    @IBAction func faceBookButtonPressed(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let facebookHandler = appDelegate.fbHandler
        facebookHandler.loginFromViewController(self) { (success) -> Void in
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setBool(success, forKey: WHUserDefault.LoggedIn.rawValue)
            userDefaults.synchronize()
            
            success ? self.performSegueWithIdentifier(WHSegue.LoginToCurrentlyPlaying.rawValue, sender: self) :
                print("Failed to login")
        }
    }
    
    
    
}
