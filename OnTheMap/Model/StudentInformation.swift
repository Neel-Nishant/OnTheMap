//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Neel Nishant on 24/01/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import Foundation

class StudentInformation {
    static let sharedInstance = StudentInformation()
    var students = [StudentData]()
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    private init(){}
}
