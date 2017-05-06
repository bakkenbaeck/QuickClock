import UIKit
import XCTest

class ScenarioCreatorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        func delay(_ delay:Double, closure:@escaping ()->()) {
            let when = DispatchTime.now() + delay
            DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
        }
        
        let expect = expectation(description: "test logout")

        let scenarioCreator = ScenarioCreator()
        scenarioCreator.executeScenario()

        delay(100.0) {
            for event in scenarioCreator.events {
                XCTAssert(event.executed == true)
            }
            expect.fulfill()
        }

        waitForExpectations(timeout: 1000)
    }

    
}
