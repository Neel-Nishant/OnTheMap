//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Neel Nishant on 17/01/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
