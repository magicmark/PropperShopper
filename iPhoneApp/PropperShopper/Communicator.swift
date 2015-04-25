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

class Communicator {
   
    var server = "http://172.20.10.2:5000"

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func sendVoice (file: NSURL) {
  
        println("sending")
                println("sending again")

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
            let dataStr = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(dataStr)
            
        })
        
        task.resume()

    }
    
//    
//    func sendVoice (file: NSURL) {
//
//        let boundary = generateBoundaryString()
//        
//        let params = [
//            "user": "mark"
//        ]
//        
//        let request = NSMutableURLRequest(NSURL(string: "\(server)/sendVoice")!);
//        request.HTTPMethod = "POST";
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
////        request.HTTPBody = createBodyWithParameters(params, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
//
//
//    }
//    
//    
//    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
//        
//        var body = NSMutableData();
//        
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.appendString("–\(boundary)\r\n")
//                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString("\(value)\r\n")
//            }
//        }
//        
//        let filename = “user-profile.jpg”
//        
//        let mimetype = “image/jpg”
//        
//        body.appendString(“–\(boundary)\r\n”)
//        body.appendString(“Content-Disposition: form-data; name=\”\(filePathKey!)\”; filename=\”\(filename)\”\r\n”)
//        body.appendString(“Content-Type: \(mimetype)\r\n\r\n”)
//        body.appendData(imageDataKey)
//        body.appendString(“\r\n”)
//        
//        body.appendString(“–\(boundary)–\r\n”)
//        
//        return body
//    }
//    

    
}