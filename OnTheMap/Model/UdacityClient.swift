//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Neel Nishant on 24/01/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import Foundation
import UIKit
class UdacityClient : NSObject {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func taskForGETMethod (completionHandler: @escaping(_ success: Bool,_ error: String?) -> Void) {
        let urlString = Constants.Udacity.BaseURL + "users/\((StudentInformation.sharedInstance.uniqueKey))"
        
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completionHandler(false, error?.localizedDescription)
//                self.createAlert(title: "Error", message: (error?.localizedDescription)!)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completionHandler(false, "Your request returned a status code other than 2xx!")
//                self.createAlert(title: "Error", message: "Your request returned a status code other than 2xx!")
                return
            }
            let range = Range(5..<data!.count)
            guard let newData = data?.subdata(in: range) else {
                /* subset response data! */
                completionHandler(false, "No data received")
//                self.createAlert(title: "Error", message: "No data received")
                return
            }
            let parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String: AnyObject]
            }
            catch {
                completionHandler(false, "error parsing JSON data")
//                self.createAlert(title: "Error", message: "error parsing JSON data")
                return
            }
            guard let user = parsedResult["user"] else {
                return
            }
            StudentInformation.sharedInstance.firstName = user["first_name"] as? String ?? ""
            StudentInformation.sharedInstance.lastName = user["last_name"] as? String ?? ""
//            self.appDelegate?.firstName = user["first_name"] as? String ?? ""
//            self.appDelegate?.lastName = user["last_name"] as? String ?? ""
            completionHandler(true, nil)
//            self.submitPost()
            
        }
        task.resume()
    }
    func taskForPOSTMethod(email: String, password: String, completionHandlerForAuth: @escaping(_ succes: Bool, _ errorString: String?) -> Void) {
        let url = URL(string: Constants.Udacity.BaseURL + "session")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpBody = "{\"\(Constants.JSONBodyKeys.Udacity)\": {\"\(Constants.JSONBodyKeys.Username)\": \"\(email)\", \"\(Constants.JSONBodyKeys.Password)\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            
            if error != nil { // Handle error…
//                sendError(error: (error?.localizedDescription)!)
                completionHandlerForAuth(false, error?.localizedDescription)
//                self.createAlert(title: "Error", message: (error?.localizedDescription)!)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                self.createAlert(title: "Error", message: "Account not found or invalid credentials")
                completionHandlerForAuth(false, "Account not found or invalid credentials")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            //            print(String(data: newData!, encoding: .utf8)!)
            
            let parsedResult : [String:AnyObject]
            do  {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String : AnyObject]
            }
            catch {
                return
            }
            //            print(parsedResult["session"])
            guard let account = parsedResult[Constants.JSONResponseKeys.Account] as? [String:AnyObject] else {
                return
            }
            completionHandlerForAuth(true, nil)
            let key = account["key"] as? String
//            self.appDelegate?.uniqueKey = key!
            StudentInformation.sharedInstance.uniqueKey = key!
            
//            self.completeLogin()
        }
        task.resume()
    }
    func taskForDeleteMethod(completionHandler : @escaping(_ success: Bool,_ errorString: String?) -> Void){
        var request = URLRequest(url: URL(string: Constants.Udacity.BaseURL + "session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(false, error?.localizedDescription)
//                self.createAlert(title: "Error", message: (error?.localizedDescription)!)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 299 else {
                completionHandler(false, "Your request returned a status code other than 2xx!")
//                self.createAlert(title: "Error", message: "Your request returned a status code other than 2xx!")
                return
            }
            let range = Range(5..<data!.count)
            guard let newData = data?.subdata(in: range) else {
                /* subset response data! */
//                self.createAlert(title: "Error", message: "No data was returned by the request!")
                completionHandler(false, "No data was returned by the request!")
                return
            }
            
//            print("logged out successfully")
            completionHandler(true, nil)
//            self.completeLogout()
        }
        task.resume()
    }
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
