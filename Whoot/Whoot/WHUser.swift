//
//  WHUser.swift
//  Whoot
//
//  Created by Andre Green on 1/15/16.
//  Copyright © 2016 Andre Green. All rights reserved.
//

import Foundation

class WHUser {
    var isAlpha = false
    let firstName: String
    let lastName: String
    let link: String
    let picLink: String
    let fbId: String
    let email: String
    
    init(fbInfo: [String: AnyObject]) {
        self.firstName = fbInfo["first_name"] as! String
        self.lastName = fbInfo["last_name"] as! String
        self.link = fbInfo["link"] as! String
        self.fbId = fbInfo["id"] as! String
        self.email = fbInfo["email"] as! String
        
        let picture = fbInfo["picture"] as! [String:AnyObject]
        let picData = picture["data"] as! [String:AnyObject]
        self.picLink = picData["url"] as! String
    }
    
    func fullName() -> String {
        return self.firstName + " " + self.lastName
    }
}
