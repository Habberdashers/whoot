//
//  WHRestHandler.swift
//  Whoot
//
//  Created by Andre Green on 1/15/16.
//  Copyright © 2016 Andre Green. All rights reserved.
//

import Foundation

class WHRestHandler: NSObject {
    func getPicFromUri(uri: String, completion: (picData: NSData?) -> Void) {
        if let url = NSURL(string: uri) {
            let request = NSMutableURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                (data, response, error) -> Void in
                if let picData = data where error == nil {
                    completion(picData: picData)
                } else {
                    completion(picData: nil)
                }
            }
            
            task.resume()
        }
    }
}
