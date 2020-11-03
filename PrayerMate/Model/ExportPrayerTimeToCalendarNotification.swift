//
//  ExportPrayerTimeToCalendarNotification.swift
//  PrayerMate
//
//  Created by eman shedeed on 6/22/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import UserNotifications

class ExportPrayerTimeToCalendarNotification{
    var notificationArray : [Notification] = .init()
    let formatter=DateFormatter()
    init(notification:Notification) {
        registerLocal(_notification: notification)

    }
//    func registerLocal(_notification:Notification) {
//        let center = UNUserNotificationCenter.current()
//        //        UNUserNotificationCenter.current().delegate=self
//        center.requestAuthorization(options: [.alert, .badge, .sound]) {[weak self] (granted, error) in
//            if granted {
//                if let self2=self{
//                self2.scheduleLocal(notification: _notification)
//                }
//                print("ay haga")
//            } else {
//                Helper.showToast(message:"alertToEnableNotifications".localized)
//            }
//        }
//    }
    func registerLocal(_notification:Notification) {
         let center = UNUserNotificationCenter.current()
         center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
             if granted {
                self.scheduleLocal(notification: _notification)
             } else {
                 Helper.showToast(message:"alertToEnableNotifications".localized)
             }
         }
     }
    func scheduleLocal(notification:Notification) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        //Notification
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.description ?? ""
       content.categoryIdentifier = "ExportingRenewal"
        //        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        
        var dateComponents = DateComponents()
        let time = notification.time.split(separator: ":")
        var hour = Int(time[0])
        let minutes = time[1].split(separator: " ")
        hour = minutes[1].contains("pm") ? (hour ?? 0) + 12 : hour
        
        dateComponents.year = Calendar.current.component(.year, from: notification.date ?? Date())
        dateComponents.month = Calendar.current.component(.month, from: notification.date ?? Date())
        dateComponents.day = Calendar.current.component(.day, from: notification.date ?? Date())
        dateComponents.hour =  hour
        dateComponents.minute = Int(minutes[0])
        
        //trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //Request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
        
        //Actions
        let okAction=UNNotificationAction(identifier: "OkAction", title: "OK", options: .foreground)
        let cancelAction=UNNotificationAction(identifier: "CancelAction", title: "Cancel", options: .foreground)
        
        let category=UNNotificationCategory(identifier: "ExportingRenewal", actions: [okAction,cancelAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
 
}