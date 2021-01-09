//  NotificationController.swift
//  Study
//
//  Created by Navjeeven Mann on 2020-08-30.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import Foundation
import UserNotifications
class NotificationController {
    static var sharedInstance = NotificationController()
    var notificationAllowed: Bool = false
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestNotifications() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        // Request notification authorization from user
        notificationCenter.requestAuthorization(options: options) { (didAllow, _) in
            self.notificationAllowed = didAllow
        }
        
        func removeNotifications() {
            notificationCenter.removeAllPendingNotificationRequests()
        }
    }
}
