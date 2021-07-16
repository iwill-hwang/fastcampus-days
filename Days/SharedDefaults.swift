//
//  GroupDefaults.swift
//  Days
//
//  Created by donghyun on 2021/07/16.
//

import Foundation

// 싱글턴 패턴은 class 로 사용

class GroupDefaults {
    static let shared = GroupDefaults()
    
    private let defaults = UserDefaults(suiteName: "group.com.fastcampus.days")
    private let key = "widget_id"
    
    var widgetId: Double? {
        get {
            return defaults?.double(forKey: key)
        }
        set {
            defaults?.setValue(newValue, forKey: key)
        }
    }
}
