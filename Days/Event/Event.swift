//
//  Event.swift
//  Days
//
//  Created by donghyun on 2021/06/01.
//

import Foundation

struct Event: Equatable {
    let id: Double
    var icon: Int
    var title: String
    var date: Date
        
    public init(icon: Int, title: String, date: Date) {
        self.id = Date().timeIntervalSince1970
        self.icon = icon
        self.title = title
        self.date = date
    }
    
    public func dayCount(from: Date = Date()) -> Int {
        let calendar = Calendar.current

        let from = calendar.startOfDay(for: from)
        let to = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: from, to: to)
        return components.day!
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
