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
        let storage: EventStorage = LocalEventStorage()
        
        XCTAssertTrue(storage.list().count == 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
