//
//  BaseService.swift
//  Arrive
//
//  Created by Yetian Mao on 4/19/15.
//  Copyright (c) 2015 yetian. All rights reserved.
//

import Foundation

let errorDomain = "error.domain"

class HttpService{
    var stringEncoding: NSNumber
    var cachePolicy: NSURLRequestCachePolicy
    var timeoutInterval: NSTimeInterval
    var boundary = "BOUNDARY_STRING"
    
    init() {
        self.stringEncoding = NSUTF8StringEncoding
        self.timeoutInterval = 60
        self.cachePolicy = .UseProtocolCachePolicy
    }
    
    //send http request
    func sendHttpRequest(request: NSMutableURLRequest, callback: (Dictionary<String, AnyObject>?, String?) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(
            request,
            completionHandler: {
                data, response, error in
                if (error != nil) {
                    callback(nil, error.localizedDescription)
                    return
                }
                var httpError : NSError!
                var isValid = self.validateResponse(response, error: &httpError)
                if (isValid == false) {
                    callback(nil, httpError.localizedDescription)
                    return
                }
                var jsonError : NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(1), error: &jsonError) as? Dictionary<String, AnyObject>
                if(jsonError != nil){
                    callback(nil, jsonError?.localizedDescription)
                    return
                }
                callback(json, nil)
        })
        task.resume()
    }
    
    //upload file
    func multiPartUpload(request: NSMutableURLRequest, callback: (Dictionary<String, AnyObject>?, String?) -> Void) {
        let task = NSURLSession.sharedSession().uploadTaskWithRequest(
            request,
            fromData: request.HTTPBody,
            completionHandler: {
                data, response, error in
                if (error != nil) {
                    callback(nil, error.localizedDescription)
                    return
                }
                var httpError : NSError!
                var isValid = self.validateResponse(response, error: &httpError)
                if (isValid == false) {
                    callback(nil, httpError.localizedDescription)
                    return
                }
                var jsonError : NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(1), error: &jsonError) as? Dictionary<String, AnyObject>
                if(jsonError != nil){
                    callback(nil, jsonError?.localizedDescription)
                    return
                }
                callback(json, nil)
        })
        task.resume()
    }
    
    //download file
    func multiPartDownload(url: NSURL, callback: (NSData?, String?) -> Void) {
        let task = NSURLSession.sharedSession().downloadTaskWithURL(
            url,
            completionHandler: {
                location, response, error in
                if (error != nil) {
                    callback(nil, error.localizedDescription)
                    return
                }
                var httpError : NSError!
                var isValid = self.validateResponse(response, error: &httpError)
                if (isValid == false) {
                    callback(nil, httpError.localizedDescription)
                    return
                }
                var data = NSData(contentsOfURL: url)
                callback(data, nil)
        })
        task.resume()
    }
    
    //get
    
    func getRequest(url: String, callback: (Dictionary<String, AnyObject>?, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.HTTPMethod = "GET"
        sendHttpRequest(request, callback: callback)
    }
    
    //delete
    
    func deleteRequest(url: String, callback: (Dictionary<String, AnyObject>?, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.HTTPMethod = "DELETE"
        sendHttpRequest(request, callback: callback)
    }
    
    //post
    
    func postRequest(url: String, jsonObj: Dictionary<String, AnyObject>, callback: (Dictionary<String, AnyObject>?, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var jsonError : NSError?
        let data : NSData?  = NSJSONSerialization.dataWithJSONObject(jsonObj, options: nil, error: &jsonError)
        request.HTTPBody = data
        sendHttpRequest(request, callback: callback)
    }
    
    //patch
    
    func patchRequest(url: String, jsonObj: Dictionary<String, AnyObject>, callback: (Dictionary<String, AnyObject>?, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.HTTPMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var jsonError : NSError?
        let data : NSData?  = NSJSONSerialization.dataWithJSONObject(jsonObj, options: nil, error: &jsonError)
        request.HTTPBody = data
        sendHttpRequest(request, callback: callback)
    }
    
    //upload
    
    func uploadRequest(url: String, jsonObj: Dictionary<String, AnyObject>, callback: (Dictionary<String, AnyObject>?, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.HTTPMethod = "POST"
        var contentType = "multipart/form-data; boundary=\(boundary)"
        request.addValue(contentType, forHTTPHeaderField:"Content-Type")
        request.HTTPBody = buildBody(jsonObj)
        sendHttpRequest(request, callback: callback)
    }
    
    /**
    *  Function to upload image & data using POST request
    *
    *  @param parameters: [String: AnyObject]
    *
    *  @return NSData
    */
    func buildBody(parameters: [String: AnyObject]) -> NSData {
        var postBody:NSMutableData = NSMutableData()
        var postData:String = String()
        
        
        for (key, value) in parameters {
            if !(value is NSMutableArray) {
                if let value = value as? String {
                    postData = String()
                    postData += "\r\n--\(boundary)\r\n"
                    postData += "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                    postData += "\(value)"
                    postBody.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
                }
            }else {
                let data = value as! NSMutableArray
                postData = String()
                postData += "\r\n--\(boundary)\r\n"
                postData += "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(Int64(NSDate().timeIntervalSince1970*1000)).\(data.objectAtIndex(1))\"\r\n"
                postData += "Content-Type: \(data.objectAtIndex(1))\r\n\r\n"
                postBody.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
                postBody.appendData(value.objectAtIndex(2) as! NSData)
                postData = String()
                postBody.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        postData += "\r\n--\(boundary)--\r\n"
        postBody.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
        return postBody
    }
    
    /**
    *  Function to build GET/POST request data E.g., a dictionary of ["a":"b","c":"d"] will return "a=b&c=d"
    *
    *  @param data:Dictionary<String, AnyObject>
    *
    *  @return of type String
    */
    func build(data: Dictionary<String, AnyObject>) -> String? {
        var dataList: [String] = [String]()
        for (key, value : AnyObject) in data {
            dataList.append("\(key)=\(value)")
        }
        return join("&", dataList).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    }
    
    /**
    *  Function to store cookie info in the http request
    *
    *  @param response: NSURLResponse
    *
    *  @return of type TBD
    */
    
    func cookieManager(response: NSURLResponse!){
        let httpResp = response as! NSHTTPURLResponse
        var cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(httpResp.allHeaderFields, forURL: httpResp.URL!) as Array
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookies[0] as! NSHTTPCookie)
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: httpResp.URL, mainDocumentURL: nil)
    }
    
    /**
    *  Function to check if the request returned a http code between 200 and 300
    *
    *  @param response: NSURLResponse!,
    *  @param data: NSData!,
    *  @param inout error: NSError!
    *
    *  @return of type Boolean
    */
    
    func validateResponse(response: NSURLResponse!, inout error: NSError!) -> Bool {
        let httpResponse = response as! NSHTTPURLResponse
        var isValid = true
        if (httpResponse.statusCode < 200 && httpResponse.statusCode >= 300) {
            isValid = false
            error = NSError(domain: errorDomain, code: httpResponse.statusCode, userInfo: nil)
        }
        
        return isValid
    }
    
    /**
    *  Function makes image or audio data into a NSMutableArray with its contentType, fileExtension defined
    *
    *  @param data: NSData,
    *  @param contentType: String?,
    *  @param fileExtension: String
    *
    *  @return of type NSMutableArray
    */
    
    func labelData(data: NSData, contentType: String?, fileExtension: String) -> NSMutableArray {
        var fileInfo:NSMutableArray = NSMutableArray()
        var type = contentType
        if(type == nil){
            type = "application/octet-stream"
        }
        fileInfo.insertObject(type!, atIndex: 0)
        fileInfo.insertObject(fileExtension, atIndex: 1)
        fileInfo.insertObject(data, atIndex: 2)
        return fileInfo
    }
    
}