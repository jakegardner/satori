//
//  NotificationHelper.swift
//  satori
//
//  Created by Jake on 5/30/19.
//  Copyright © 2019 Jake C Gardner. All rights reserved.
//

import Foundation
import UserNotifications
import Dollar

class NotificationHelper {
    static var app: NotificationHelper = {
        return NotificationHelper()
    }()

    func getDefaultTimesOfDay() -> Array<DateComponents> {
        var times: Array<DateComponents> = []
        
        var timeOne = DateComponents()
        timeOne.hour = 7
        times.append(timeOne)
        
        var timeTwo = DateComponents()
        timeTwo.hour = 11
        times.append(timeTwo)
        
        var timeThree = DateComponents()
        timeThree.hour = 15
        times.append(timeThree)
        
        var timeFour = DateComponents()
        timeFour.hour = 19
        times.append(timeFour)
        
        return times
    }
    
    func createNotificationRequest(id: String, text: String, dateComponent: DateComponents) -> UNNotificationRequest {
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let content = UNMutableNotificationContent()
        content.body = text
        content.sound = .default
        let request = UNNotificationRequest(identifier: id,
                                            content: content, trigger: trigger)
        return request
    }

    func createScheduleForItems(items:  [Affirmation]) -> [UNNotificationRequest] {
        let defaultTimes = getDefaultTimesOfDay()
        var requests: [UNNotificationRequest] = []
        
        if items.count <= 4 {
            for (timeIndex, item) in items.enumerated() {
                let request = createNotificationRequest(id: item.uuid, text: item.text, dateComponent: defaultTimes[timeIndex])
                requests.append(request)
            }
        } else {
            var fullMonthItems: [Affirmation] = []
            while fullMonthItems.count < 120 {
                fullMonthItems += items
            }
            let itemsByDay = Dollar.chunk(fullMonthItems, size: 4)
            for (dayIndex, daySet) in itemsByDay.enumerated() {
                for (timeIndex, item) in daySet.enumerated() {
                    var dc = defaultTimes[timeIndex]
                    dc.day = dayIndex + 1
                    let request = createNotificationRequest(
                        id: "\(item.uuid)-\(dayIndex)\(timeIndex)",
                        text: item.text,
                        dateComponent: dc
                    )
                    requests.append(request)
                }
            }
        }
        return requests
    }

    func createNotifications(items: [UNNotificationRequest]) {
        for (_, item) in items.enumerated() {
            UNUserNotificationCenter.current().add(item) { (error) in
                if error != nil {
                    print("Failed to add notification for ", item.identifier)
                }
            }
        }
    }

    func removeNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
