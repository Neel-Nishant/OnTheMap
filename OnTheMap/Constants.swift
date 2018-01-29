//
//  Constants.swift
//  OnTheMap
//
//  Created by Neel Nishant on 16/01/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    
    struct Udacity {
        static let BaseURL = "https://www.udacity.com/api/"
    }
    struct Parse {
        static let BaseURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    struct JSONBodyKeys {
        
        //Parse
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
        //Udacity
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    struct JSONResponseKeys {
        
        //Udacity
        static let Key = "key"
        static let Account = "account"
        
        //Parse
        static let Results = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
}
