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
    
    
    func loginFromViewController(fromViewController: UIViewController, withCompletion completion: (success: Bool) -> Void) {
        FBSDKLoginManager().logInWithReadPermissions(
            self.permissions,
            fromViewController: fromViewController)
            { (result, error) -> Void in
                if error != nil {
                    print("error in login from veiw controller: \(error)")
                } else if result.isCancelled {
                  print("user canceld facebook login")
                } else {
                    print("got user info")
                    let fields = "id, name, link, first_name, last_name, picture.type(large), email"
                    let fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: ["fields": fields]);
                    fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                        
                        if error == nil {
                            print("User Info : \(result)")
                            if let info = result as? [String:AnyObject] {
                                let user = WHUser(fbInfo: info)
                                print("got user: \(user)")
                                self.saveUserToServer(user)
                                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                appDelegate.userManager.addUser(user)
                                appDelegate.userManager.currentUser = user
                                completion(success: true)
                                self.getFacebookPic(user, completion: { (data) -> Void in
                                    if data == nil {
                                        print("No user image for \(user.email)")
                                    } else {
                                        print("Got pic for \(user.email)")
                                    }
                                })
                            }
                        } else {
                            print("Error Getting Info \(error)");
                            completion(success: false)
                        }
                    }
                }
        }
    }
    
    func getFacebookPic(user:WHUser, completion:(image: UIImage?) -> Void ){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let picCache = appDelegate.picCache
        picCache.getImage(user.email) { (pic) -> Void in
            if pic == nil {
                let restHandler = WHRestHandler()
                let url = "https://graph.facebook.com/\(user.fbId)/picture?type=large"
                restHandler.getPicFromUri(url) { (picData) -> Void in
                    if picData == nil {
                        print("Error: failed to fetch image")
                        return
                    }
                    
                    if let pic = UIImage(data: picData!) {
                        picCache.setImage(user.email, image: pic)
                        completion(image: pic)
                    }
                }
            } else {
                completion(image: pic)
            }
        }
        
    }
    
    func saveUserToServer(user: WHUser) {
        let restHandler = WHRestHandler()
        restHandler.post(WHServerPath.SaveUser, objectToPost: user.toJson()) { (responseObject) -> Void in
            if responseObject == nil {
                print("Got a nill response saving user: \(user.email)")
                return
            }
            
            if let responseDict = responseObject as? [String:AnyObject?] {
                if let error = responseDict["error"] {
                    print("Error saving user\(error)")
                }
                
                if let payload = responseDict["payload"] {
                    print("received response saveing user: \(payload)")
                }
            }
        }
    }
    
//    func getFBUserInfo() {
//        if (FBSDKAccessToken.currentAccessToken() != nil) {
//            let params = [
//                "fields": "id, name, link, first_name, last_name, picture.type(large), email"
//            ]
//            
//            FBSDKGraphRequest(graphPath: "me", parameters: params).startWithCompletionHandler({(connection: FBSDKGraphRequestConnection, result: AnyObject, error: NSError) -> Void in
//                if !error {
//                    self.userInfoRecieved(result)
//                }
//            })
//        }
//    }
    
    func userInfoRecieved(info: [NSObject : AnyObject]) {

    }
    
    func getFacebookPicForUserId(userId: String, withCompletion completion: () -> Void) {
    
    }
}
