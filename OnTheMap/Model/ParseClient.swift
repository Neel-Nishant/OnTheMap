//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Neel Nishant on 24/01/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import Foundation
import UIKit
class ParseClient : NSObject {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    func taskForGETMethod(completionHandler : @escaping(_ success: Bool, _ error: String?) -> Void) {
        let urlString = Constants.Parse.BaseURL + "?limit=100&order=-updatedAt"
        //print(urlString)
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completionHandler(false, error?.localizedDescription)
//                self.createAlert(title: "Error", message: (error?.localizedDescription)!)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                self.createAlert(title: "Error", message: "Unauthorized")
                completionHandler(false, "Unauthorized")
                return
            }
            guard let data = data else{
//                self.createAlert(title: "Error", message: "No data was returned by the request!")
                completionHandler(false, "No data was returned by the request!")
                return
            }
            let parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
            }
            catch {
                completionHandler(false, "unable to parse JSON data")
//                self.createAlert(title: "Error", message: "unable to parse JSON data")
                return
            }
            guard let studentArray = parsedResult[Constants.JSONResponseKeys.Results] as? [[String: AnyObject]] else {
                return
            }
            for student in studentArray {
                
                if student["firstName"] != nil{
                    let studentInfo = StudentData(dictionary: student)
                    StudentInformation.sharedInstance.students.append(studentInfo)
//                    self.appDelegate?.students.append(studentInfo)
                }
                
                
            }
//            print(StudentInformation.sharedInstance.students)
            completionHandler(true, nil)
//            self.loadMap()
        }
        task.resume()
    }
    
    func taskForPOSTMethod (annotationString: String, websiteText: String, completionHandler : @escaping(_ success: Bool, _ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: Constants.Parse.BaseURL)!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"\(Constants.JSONBodyKeys.UniqueKey)\": \"\((StudentInformation.sharedInstance.uniqueKey))\", \"\(Constants.JSONBodyKeys.FirstName)\": \"\(StudentInformation.sharedInstance.firstName)\", \"\(Constants.JSONBodyKeys.LastName)\": \"\(StudentInformation.sharedInstance.lastName)\",\"\(Constants.JSONBodyKeys.MapString)\": \"\(annotationString)\", \"\(Constants.JSONBodyKeys.MediaURL)\": \"\((websiteText))\",\"\(Constants.JSONBodyKeys.Latitude)\": \(lat), \"\(Constants.JSONBodyKeys.Longitude)\": \(long)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(false, error?.localizedDescription)
//                self.createAlert(title: "Error", message: (error?.localizedDescription)!)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completionHandler(false,"Your request returned a status code other than 2xx!")
//                self.createAlert(title: "Error", message: "Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else{
                completionHandler(false, "No data was returned by the request")
//                self.createAlert(title: "Error", message: "No data was returned by the request")
                return
            }
            print(String(data: data, encoding: .utf8)!)
            completionHandler(true, nil)
//            self.updatePostList()
        }
        task.resume()
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
