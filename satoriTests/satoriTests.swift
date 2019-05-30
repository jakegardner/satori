//
//  satoriTests.swift
//  satoriTests
//
//  Created by Jake on 7/17/19.
//  Copyright © 2019 Jake C Gardner. All rights reserved.
//

import XCTest
import UserNotifications
@testable import satori

class satoriTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateNotificationRequest() {
        let dc = DateComponents()
        let request: UNNotificationRequest = NotificationHelper.app.createNotificationRequest(id: "test1", text: "notify", dateComponent: dc)
        XCTAssertEqual(request.content.body, "notify")
        XCTAssertEqual(request.content.sound, .default)
    }
    
    func testCreateNotificationRequestDateComponents() {
        var dc = DateComponents()
        dc.day = 5
        dc.hour = 7
        let request: UNNotificationRequest = NotificationHelper.app.createNotificationRequest(id: "test1", text: "notify", dateComponent: dc)
        let trigger = request.trigger as! UNCalendarNotificationTrigger
        XCTAssertEqual(trigger.dateComponents.day, 5)
        XCTAssertEqual(trigger.dateComponents.hour, 7)
        XCTAssertEqual(trigger.repeats, true)
    }
    
    func testSingleDaySchedule() {
        var items: [Affirmation] = []
        
        let one = Affirmation()
        one.text = "first"
        items.append(one)
        
        let two = Affirmation()
        two.text = "second"
        items.append(two)
        
        let three = Affirmation()
        three.text = "third"
        items.append(three)
        
        let four = Affirmation()
        four.text = "fourth"
        items.append(four)
        
        let requests = NotificationHelper.app.createScheduleForItems(items: items)
        let triggerOne = requests[0].trigger as! UNCalendarNotificationTrigger
        let triggerTwo = requests[1].trigger as! UNCalendarNotificationTrigger
        let triggerThree = requests[2].trigger as! UNCalendarNotificationTrigger
        let triggerFour = requests[3].trigger as! UNCalendarNotificationTrigger
        
        XCTAssertEqual(triggerOne.dateComponents.hour, 7)
        XCTAssertEqual(triggerOne.repeats, true)
        
        XCTAssertEqual(triggerTwo.dateComponents.hour, 11)
        XCTAssertEqual(triggerTwo.repeats, true)
        
        XCTAssertEqual(triggerThree.dateComponents.hour, 15)
        XCTAssertEqual(triggerThree.repeats, true)
        
        XCTAssertEqual(triggerFour.dateComponents.hour, 19)
        XCTAssertEqual(triggerFour.repeats, true)
    }
    
    func getNextTaskNumber(taskNumber: Int, count: Int) -> Int {
        if taskNumber < count - 1 {
            return taskNumber + 1
        } else {
            return 0
        }
    }

    func testMultiDaySchedule() {
        var items: [Affirmation] = []
        
        let one = Affirmation()
        one.text = "first"
        items.append(one)
        
        let two = Affirmation()
        two.text = "second"
        items.append(two)
        
        let three = Affirmation()
        three.text = "third"
        items.append(three)
        
        let four = Affirmation()
        four.text = "fourth"
        items.append(four)
        
        let five = Affirmation()
        five.text = "fifth"
        items.append(five)
        
        let six = Affirmation()
        six.text = "sixth"
        items.append(six)
        
        let seven = Affirmation()
        seven.text = "seventh"
        items.append(seven)
        
        let requests = NotificationHelper.app.createScheduleForItems(items: items)
        
        // verify schedule for current day
        let date = Date()
        let dayOfMonth = Calendar.current.component(.day, from: date)
        let startingIndex = ((dayOfMonth - 1) * 4)
        var currentTaskNumber = startingIndex % items.count
        
        let triggerOne = requests[startingIndex].trigger as! UNCalendarNotificationTrigger
        let triggerTwo = requests[startingIndex + 1].trigger as! UNCalendarNotificationTrigger
        let triggerThree = requests[startingIndex + 2].trigger as! UNCalendarNotificationTrigger
        let triggerFour = requests[startingIndex + 3].trigger as! UNCalendarNotificationTrigger

        XCTAssertEqual(triggerOne.dateComponents.hour, 7)
        XCTAssertEqual(triggerOne.dateComponents.day, dayOfMonth)
        XCTAssertEqual(items[currentTaskNumber].text, requests[startingIndex].content.body)
        XCTAssertEqual(triggerOne.repeats, true)

        currentTaskNumber = getNextTaskNumber(taskNumber: currentTaskNumber, count: items.count)
        XCTAssertEqual(triggerTwo.dateComponents.hour, 11)
        XCTAssertEqual(triggerTwo.dateComponents.day, dayOfMonth)
        XCTAssertEqual(items[currentTaskNumber].text, requests[startingIndex + 1].content.body)
        XCTAssertEqual(triggerTwo.repeats, true)

        currentTaskNumber = getNextTaskNumber(taskNumber: currentTaskNumber, count: items.count)
        XCTAssertEqual(triggerThree.dateComponents.hour, 15)
        XCTAssertEqual(triggerThree.dateComponents.day, dayOfMonth)
        XCTAssertEqual(items[currentTaskNumber].text, requests[startingIndex + 2].content.body)
        XCTAssertEqual(triggerThree.repeats, true)

        currentTaskNumber = getNextTaskNumber(taskNumber: currentTaskNumber, count: items.count)
        XCTAssertEqual(triggerFour.dateComponents.hour, 19)
        XCTAssertEqual(triggerFour.dateComponents.day, dayOfMonth)
        XCTAssertEqual(items[currentTaskNumber].text, requests[startingIndex + 3].content.body)
        XCTAssertEqual(triggerFour.repeats, true)
    }
}
