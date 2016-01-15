//
//  WHFacebookHandler.swift
//  Whoot
//
//  Created by Andre Green on 1/15/16.
//  Copyright © 2016 Andre Green. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import UIKit

struct WHFacebookHandler {
    let permissions = [
        "public_profile",
        "email",
        "user_friends"
    ]
    
    func becameActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func applicationFinishedLaunching(application: UIApplication, options: [NSObject:AnyObject]?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: options)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation
        )
    }
    
    func currentToken() -> FBSDKAccessToken {
        return FBSDKAccessToken.currentAccessToken
    }
    
    func loginFromViewController(fromViewController: UIViewController, withCompletion completion: () -> Void) {
        NSLog("%@ %@", NSStringFromClass(self.self!), NSStringFromSelector(cmd))
        var login: FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(self.permissions, fromViewController: fromViewController, handler: {(result: FBSDKLoginManagerLoginResult, error: NSError) -> Void in
            if error! {
                NSLog("Error logging into facebook %@", error.description)
            }
            else if result.isCancelled {
                NSLog("Canceled login to facebook")
            }
            else {
                self.getFBUserInfo()
            }
            
        })
    }
    
    func getFBUserInfo() {
        NSLog("%@ %@", NSStringFromClass(self.self!), NSStringFromSelector(cmd))
        if FBSDKAccessToken.currentAccessToken() {
            let params = [
                "fields": "id, name, link, first_name, last_name, picture.type(large), email"
            ]
            
            FBSDKGraphRequest(graphPath: "me", parameters: params).startWithCompletionHandler({(connection: FBSDKGraphRequestConnection, result: AnyObject, error: NSError) -> Void in
                if !error {
                    self.userInfoRecieved(result)
                }
            })
        }
    }
    
    func userInfoRecieved(info: [NSObject : AnyObject]) {

    }
    
    func getFacebookPicForUserId(userId: String, withCompletion completion: () -> Void) {
    
    }
}
