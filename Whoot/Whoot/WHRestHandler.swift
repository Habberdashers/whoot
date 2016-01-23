//
//  WHRestHandler.swift
//  Whoot
//
//  Created by Andre Green on 1/15/16.
//  Copyright © 2016 Andre Green. All rights reserved.
//

import Foundation
import SwiftyJSON


enum WHServerPath: String {
    case SaveUser = "save-user"
    case InRange = "in-range"
    case GetAlpha = "get-alpha"
    case GetAllUsers = "get-all-users"
    case SongSelected = "song-selected"
}


class WHRestHandler: NSObject {
    let baseUrl = "http://ec2-54-213-127-221.us-west-2.compute.amazonaws.com/"
    
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
    
    func get(partialPath: WHServerPath, completion:(responseObject: AnyObject?) -> Void) {
        let uriString = self.baseUrl + partialPath.rawValue
        if let url = NSURL(string: uriString) {
            let request = NSMutableURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                (data, response, error) -> Void in
                if let responseData = data where error == nil {
                    let json = JSON(data: responseData)
                    if let payload = json["payload"] as? AnyObject {
                        print("got payload from uriString: \(payload)")
                        completion(responseObject: payload)
                    } else {
                        completion(responseObject: nil)
                    }
                } else {
                    completion(responseObject: nil)
                }
            }
            
            task.resume()
        } else {
            print("Error: could not make url from input url: \(uriString)")
        }
    }
    
    func post(partialPath: WHServerPath, objectToPost: AnyObject, completion:(responseObject: AnyObject?) -> Void) {
        let uriString = self.baseUrl + partialPath.rawValue
        if let url =  NSURL(string: uriString) {
            let request = NSMutableURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            var err: NSError?
            do {
               try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(objectToPost, options: NSJSONWritingOptions.PrettyPrinted)
            } catch {
                print("Could not save json to request body: \(err)")
                return;
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                print("Response: \(response)")
                
                if let responseData = data where error == nil {
                    let json = JSON(data: responseData)
                    if let payload = json["payload"] as? AnyObject {
                        print("got payload from uriString: \(payload)")
                        completion(responseObject: payload)
                    } else {
                        completion(responseObject: nil)
                    }
                } else {
                    completion(responseObject: nil)
                }
            })
            
            task.resume()
        }
    }
}
