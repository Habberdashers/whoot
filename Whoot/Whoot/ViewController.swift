//
//  ViewController.swift
//  Whoot
//
//  Created by Andre Green on 1/15/16.
//  Copyright © 2016 Andre Green. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = UIColor.redColor()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let isSignedIn = userDefaults.valueForKey(WHUserDefault.LoggedIn.rawValue) as! Bool? {
            if isSignedIn {
                self.performSegueWithIdentifier(WHSegue.RootToCurrentlyPlaying.rawValue, sender: self)
            } else {
                self.performSegueWithIdentifier(WHSegue.RootToLogin.rawValue, sender: self)
            }
        } else {
            userDefaults.setBool(false, forKey: WHUserDefault.LoggedIn.rawValue)
            self.performSegueWithIdentifier(WHSegue.RootToLogin.rawValue, sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

