//
//  Task.swift
//  RxSListApp
//
//  Created by eren kulan on 20/10/2019.
//  Copyright © 2019 eren kulan. All rights reserved.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
