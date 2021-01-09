//
//  User.swift
//  Study
//
//  Created by Navjeeven Mann on 2020-08-30.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import Foundation
class User {
    // Declare user timer value
    static var sharedInstance = User()
    var sprintTime = 1
    var backgroundDate: Date?
    var shortBreakTime = 2
    var longBreakTime = 1
    var sprintTarget = 4
    var sessionTarget = 12
    var sprintRate = 0
    var sessionRate = 0
}
