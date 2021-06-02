//
//  EventStorage.swift
//  Days
//
//  Created by donghyun on 2021/06/01.
//

import Foundation

protocol EventStorage {
    func add(_ event: Event)
    func update(_ event: Event)
    func delete(_ event: Event)
    func list() -> [Event]
}
