//
//  WHUserManager.swift
//  Whoot
//
//  Created by Andre Green on 1/16/16.
//  Copyright © 2016 Andre Green. All rights reserved.
//

import Foundation

class WHUserManager {
    var currentUser: WHUser?
    var alphaUser: WHUser?
    var users = [String:WHUser]()
    
    func isCurrentUserAlpha() -> Bool {
        if self.currentUser != nil && self.alphaUser != nil {
            return self.currentUser!.email == self.alphaUser!.email
        }
        
        return false
    }
    
    func addUser(user: WHUser) {
        if self.users.count == 0 {
            self.alphaUser = user
        }
        
        self.users[user.email] = user
    }
    
    func removeUser(user: WHUser) {
        if let storedUser = self.users[user.email] {
            if self.currentUser != nil {
                if storedUser.email == self.currentUser!.email {
                    self.currentUser = nil
                }
            }
            
            if self.alphaUser != nil {
                if storedUser.email == self.alphaUser!.email {
                    self.currentUser = nil
                }
            }
            
            self.users.removeValueForKey(user.email)
        }
    }
}