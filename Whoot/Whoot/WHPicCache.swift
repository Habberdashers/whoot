//
//  WHPicCache.swift
//  Whoot
//
//  Created by Andre Green on 1/15/16.
//  Copyright © 2016 Andre Green. All rights reserved.
//

import UIKit
import Foundation

struct WHPicCache {
    let cache: NSCache
    
    init() {
        let picCache = NSCache()
        picCache.countLimit = 20
        self.cache = picCache
    }
    
    func getImage(userName: String, completion: (pic: UIImage?) -> Void) {
        if let image = self.cache.objectForKey(userName) as? UIImage {
            completion(pic: image)
            return
        }
        
        completion(pic: nil)
    }
    
    func setImage(userName: String, image: UIImage) {
        self.cache.setObject(image, forKey: userName)
    }
}