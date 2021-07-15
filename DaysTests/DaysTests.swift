//
//  DaysTests.swift
//  DaysTests
//
//  Created by donghyun on 2021/06/01.
//

import XCTest
@testable import Days

class DaysTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let defaults = UserDefaults(suiteName: "test")!
        defaults.removeObject(forKey: "event_list")
        
        let storage: EventStorage = LocalEventStorage(with: defaults)
        
        XCTAssertTrue(storage.list().count == 0)
        
        
        let firstDate = Date()
        let first = Event(icon: 1, title: "first", date: firstDate)
        
        storage.add(first)
        
        XCTAssertTrue(storage.list().count == 1)
        
        let fetchedFirst = storage.list()[0]
        XCTAssertTrue(fetchedFirst.title == "first" && fetchedFirst.icon == 1 && fetchedFirst.date == firstDate)
        
        let secondDate = Date()
        let second = Event(icon: 2, title: "second", date: secondDate)
        
        storage.add(second)
        
        XCTAssertTrue(storage.list().count == 2)
        
        storage.delete(first)
        
        XCTAssertTrue(storage.list().count == 1)
        
        let fetchedSecond = storage.list()[0]
        
        XCTAssertTrue(fetchedSecond.title == "second" && fetchedSecond.icon == 2 && fetchedSecond.date == secondDate)
        
        storage.delete(second)
        
        XCTAssertTrue(storage.list().isEmpty)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
