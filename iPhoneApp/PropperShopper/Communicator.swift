//
//  Communicator.swift
//  PropperShopper
//
//  Created by Mark Larah on 25/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

//    
//    Alamofire.request(.GET, "http://172.20.10:5000/test")
//    .responseJSON {(request, response, JSON, error) in
//    
//    println(JSON)
//    
//    }
//    
//    


import Foundation
import Alamofire

protocol CommunicatorDelegate {
    func itemObjectRecieved(data: String)
}

class Communicator: NSObject {
   
//    var server = "http://172.20.10.2:5000"
    var server = "http://46.101.1.221:5000"

    var delegate: CommunicatorDelegate?
    
    override init() {
        super.init()
    }
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func sendVoice (file: NSURL) {
  
        println("sending")
 
        let boundary = generateBoundaryString()
        let beginningBoundary = "--\(boundary)"
        let endingBoundary = "--\(boundary)--"
        let contentType = "multipart/form-data;boundary=\(boundary)"
        
        var header = "Content-Disposition: form-data; name=\"\(file.path)\"; filename=\"\(file)\"\r\n"

        
        var recording: NSData = NSData(contentsOfURL: file)!
        
        var body = NSMutableData()
        body.appendData(("\(beginningBoundary)\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData((header as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(("Content-Type: application/octet-stream\r\n\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(recording) // adding the recording here
        body.appendData(("\r\n\(endingBoundary)\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
        
        var request = NSMutableURLRequest()
        request.URL = NSURL(string: "\(server)/sendVoice")!
        request.HTTPMethod = "POST"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.HTTPBody = body
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            println("upload complete")
            let dataStr = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
            self.delegate?.itemObjectRecieved(dataStr)
            
        })
        
        task.resume()

    }
        
}