//
//  Event.swift
//  Days
//
//  Created by donghyun on 2021/06/01.
//

import Foundation

struct Event: Equatable {
    let id: TimeInterval
    var icon: Int
    var title: String
    var date: Date
    
    public init(icon: Int, title: String, date: Date) {
        self.id = Date().timeIntervalSince1970
        self.icon = icon
        self.title = title
        self.date = date
    }
    
    static func create() -> Event {
        Event(icon: 1, title: "", date: Date())
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
