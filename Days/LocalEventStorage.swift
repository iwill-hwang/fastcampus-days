//
//  LocalEventStorage.swift
//  Days
//
//  Created by donghyun on 2021/06/01.
//

import Foundation

extension Event {
    init(with info: [String: Any]) {
        self.id = info["id"] as! TimeInterval
        self.icon = info["icon"] as! Int
        self.title = info["title"] as! String
        self.date = info["date"] as! Date
    }
    
    func asDinctionary() -> [String: Any] {
        return ["id": id, "icon": icon, "title": title, "date": date]
    }
}

final class LocalEventStorage: EventStorage {
    private let defaults = UserDefaults.standard
    private let key = "event_list"
    
    func add(_ event: Event) {
        var list = defaults.object(forKey: key) as? [[String: Any]] ?? []
        
        list.append(event.asDinctionary())
        
        defaults.set(list, forKey: key)
    }
    
    func update(_ event: Event) {
        var list = defaults.object(forKey: key) as? [[String: Any]] ?? []
        
        if let index = list.firstIndex(where: {Event(with: $0) == event}) {
            list[index] = event.asDinctionary()
        }
        defaults.set(list, forKey: key)
    }
    
    func delete(_ event: Event) {
        var list = defaults.object(forKey: key) as? [[String: Any]] ?? []
        
        if let index = list.firstIndex(where: {Event(with: $0) == event}) {
            list.remove(at: index)
        }
        defaults.set(list, forKey: key)
    }
    
    func list() -> [Event] {
        (defaults.object(forKey: key) as? [[String: Any]] ?? []).map{Event(with: $0)}
    }
}
