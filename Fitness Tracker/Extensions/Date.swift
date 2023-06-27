//
//  Date.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 21/06/2023.
//

import Foundation

struct InitError: Error {}

extension Date {
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale.current
        return calendar
    }
    
    init(from components: DateComponents) {
        self = Calendar.current.date(from: components)!
    }
    
    init(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {
        if let date = Date().with(year: year, month: month, day: day, hour: hour, minute: minute, second: second) {
            self = date
        } else {
            print("Failed to init date with custom components, making default Date")
            self = Date()
        }
    }
    
    func with(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date? {
        if let date = calendar.date(from: DateComponents(year: year ?? self.year, month: month ?? self.month, day: day ?? self.day, hour: hour ?? self.hour, minute: minute ?? self.minute, second: second ?? self.second)) {
            return date
        }
        return nil
    }
    
    var year: Int { calendar.component(.year, from: self) }
    var month: Int { calendar.component(.month, from: self) }
    var day: Int { calendar.component(.day, from: self) }
    var weekday: Int {
        var index = calendar.component(.weekday, from: self) - calendar.firstWeekday
        if index < 0 {
            index = index + 7
        }
        return index
    }
    var hour: Int { calendar.component(.hour, from: self) }
    var minute: Int { calendar.component(.minute, from: self) }
    var second: Int { calendar.component(.second, from: self) }
    
    static var weekdaySymbols: [String] { DateFormatter().weekdaySymbols }
    
    func time(as format: String = "HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func before(_ other: Date) -> Bool {
        return self < other
    }
    
    func after(_ other: Date) -> Bool {
        return self > other
    }
    
    func between(start: Date, end: Date) -> Bool {
        return self.after(start) && self.before(end)
    }
    
    func equal(_ other: Date) -> Bool {
        return self == other
    }
    
    func add(component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: self)!
    }
    
    func subtract(component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: -value, to: self)!
    }
    
    func format(format: String? = "dd MMMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func startOfDay() -> Date {
        return calendar.startOfDay(for: self)
    }
    
    func startOfWeek() -> Date {
        self.subtract(component: .day, value: Date().weekday - 1)
    }
    
    func currentWeek() -> [Date] {
        Date.weekForDay(Date())
    }
    
    static func weekForDay(_ day: Date? = nil) -> [Date] {
        return (0..<7).map { (day ?? Date()).startOfWeek().add(component: .day, value: $0) }
    }
    
    func endOfDay() -> Date {
        return calendar.date(byAdding: .day, value: 1, to: startOfDay())!
    }
    
    func isInWeekend() -> Bool {
        return calendar.isDateInWeekend(self)
    }
}
