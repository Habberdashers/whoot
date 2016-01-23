//
//  WHUser.swift
//  Whoot
//
//  Created by Andre Green on 1/15/16.
//  Copyright © 2016 Andre Green. All rights reserved.
//

import Foundation
import CoreLocation


class WHUser {
    var isAlpha = false
    let firstName: String
    let lastName: String
    let fbLink: String
    let picLink: String
    let fbId: String
    let email: String
    var location: CLLocationCoordinate2D?
    
    init(fbInfo: [String: AnyObject]) {
        self.firstName = fbInfo["first_name"] as! String
        self.lastName = fbInfo["last_name"] as! String
        self.fbLink = fbInfo["link"] as! String
        self.fbId = fbInfo["id"] as! String
        self.email = fbInfo["email"] as! String
        
        let picture = fbInfo["picture"] as! [String:AnyObject]
        let picData = picture["data"] as! [String:AnyObject]
        self.picLink = picData["url"] as! String
    }
    
    func fullName() -> String {
        return self.firstName + " " + self.lastName
    }
    
    func toJson() -> [String: AnyObject] {
        var data: [String:AnyObject] = [
            "firstName": self.firstName,
            "lastName": self.lastName,
            "fbLink": self.fbLink,
            "picLink": self.picLink,
            "fbId": self.fbId,
            "email": self.email,
            "isAlpha": self.isAlpha,
        ]
        
        if let location = self.location {
            data["longitude"] =  location.longitude
            data["latitude"] = location.latitude
        }
        
        return data
    }
}
