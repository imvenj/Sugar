//
//  NSDate+Ruby.swift
//  Sugar Example
//
//  Created by 朱文杰 on 15/11/19.
//  Copyright © 2015年 朱文杰. All rights reserved.
//

import Foundation

public enum WeekDay: Int {
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
}

@warn_unused_result public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    let lhsTimeStamp = lhs.timeIntervalSince1970
    let rhsTimeStamp = rhs.timeIntervalSince1970
    return (rhsTimeStamp - lhsTimeStamp) > 0
}

extension NSDate: Comparable {
}

@available(iOS 7.0, OSX 10.9, *)
public extension NSDate {
    func isIt(weekDay: WeekDay) -> Bool {
        return __components.weekday == weekDay.rawValue ? true : false
    }

    private var __calender: NSCalendar {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        cal.locale = NSLocale.currentLocale()
        return cal
    }

    private var __components: NSDateComponents {
        return __calender.components([.Year, .Month, .Day, .Hour, .Minute, .Second, .Weekday, .WeekOfYear, .WeekOfMonth], fromDate: self)
    }

    var year: Int {
        return __components.year
    }

    var month: Int {
        return __components.month
    }

    var day: Int {
        return __components.day
    }

    var hour: Int {
        return __components.hour
    }

    var minute: Int {
        return __components.minute
    }

    var second: Int {
        return __components.second
    }


}