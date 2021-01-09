//
//  CountdownTimer.swift
//  Study Timer
//
//  Created by Navjeeven Mann on 2020-05-23.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import Foundation
import UIKit

// Declare enum for timerStatus
enum status {
    case normal, shortBreak, longBreak
}

class CountdownTimer {
    // Declare countdown constants and class singleton
    static var sharedInstance = CountdownTimer()
    var timerStatus: status = .normal
    var seconds: Int = 59
    var sprintTime = User.sharedInstance.sprintTime

    init() {
        // Decrease the sprint time by 1 to account for the timer starting
        self.sprintTime = sprintTime - 1
    }
    
    func returnFromBackground() {
        // Purpose of this function is to get the difference between when the user leaves and returns to the app
        // Get the date the user went to the background

        if let backgroundDate = User.sharedInstance.backgroundDate {

            // Get the difference in seconds and the current total time
            let difference = Int(Date().timeIntervalSince(backgroundDate).rounded())
            let timerSeconds = (self.sprintTime * 60) + seconds

            // if the user has left longer than the remaining time in the timer
            if (timerSeconds - difference) < 0 {
                // get the remaining time
                var remainderTime = abs(timerSeconds - difference)

                // continue the timerStatus to the appropriate value
                while remainderTime > 0 {
                    
                    timerControl()

                    switch timerStatus {
                    case .longBreak:
                        remainderTime -= User.sharedInstance.longBreakTime * 60
                    case .normal:
                        remainderTime -= User.sharedInstance.sprintTime * 60
                    case .shortBreak:
                        remainderTime -= User.sharedInstance.shortBreakTime * 60
                    }
                }
                print("Diff:\(remainderTime)")
                remainderTime = abs(remainderTime)
                // Appropriately update values
                self.sprintTime = (remainderTime % 3600) / 60
                self.seconds = (seconds % 3600) % 60
            } else {
                print("Diff:\(difference) Timer: \(timerSeconds)")
                // Appropriately update values
                self.sprintTime -= (difference % 3600) / 60
                self.seconds -= (difference % 3600) % 60
            }
        }
    }
    
    func timerControl () {
        var rate = 0

        // The timer has ended and so we are updating to the next status
        switch self.timerStatus {
        case .normal:
            rate = 1
            // The user has a longBreak now since the sprint and session target's have been met or short break otherwise
            if ((User.sharedInstance.sprintRate == User.sharedInstance.sprintTarget) && (User.sharedInstance.sessionRate == User.sharedInstance.sessionTarget)) || (User.sharedInstance.sprintRate == User.sharedInstance.sprintTarget) {
                self.timerStatus = .longBreak
                self.sprintTime = User.sharedInstance.longBreakTime
            } else {
                self.timerStatus = .shortBreak
                self.sprintTime = User.sharedInstance.shortBreakTime
            }
            // Continue the normal status
        case .longBreak, .shortBreak:
            self.timerStatus = .normal
            self.sprintTime = User.sharedInstance.sprintTime
        }
        // Update the timer rate
        User.sharedInstance.sessionRate += rate
        User.sharedInstance.sprintRate += rate
    }

    @objc func countdown() {
        if seconds != 0 {
            seconds -= 1
        } else {
            sprintTime -= 1
            seconds = 59
        }
    }
}
