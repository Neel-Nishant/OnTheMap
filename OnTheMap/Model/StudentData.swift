//
//  StudentData.swift
//  OnTheMap
//
//  Created by Neel Nishant on 18/01/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import Foundation
import UIKit

struct StudentData {
    var firstName: String
    var lastName: String
    var url: String
    var longitude: Double
    var latitude: Double
    var mapString: String
    
    init (dictionary : [String:AnyObject]) {
        firstName = dictionary[Constants.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[Constants.JSONResponseKeys.LastName] as! String
        url = dictionary[Constants.JSONResponseKeys.MediaURL] as! String
        longitude = dictionary[Constants.JSONResponseKeys.Longitude] as! Double
        latitude = dictionary[Constants.JSONResponseKeys.Latitude] as! Double
        if dictionary[Constants.JSONResponseKeys.MapString] != nil {
            mapString = dictionary[Constants.JSONResponseKeys.MapString] as! String
        }
        else {
            mapString = ""
        }
    }
}
