import UIKit
import XCTest

class ScenarioCreatorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testScenario() {
        let expect = expectation(description: "test scenario")

        let scenarioCreator = Scenario()
        scenarioCreator.createScenario()

        for event in scenarioCreator.events {
            XCTAssert(event.executed == false)
        }

        scenarioCreator.executeScenario()

        delay(100.0) {
            for event in scenarioCreator.events {
                XCTAssert(event.executed == true)
            }
            expect.fulfill()
        }

        waitForExpectations(timeout: 1000)
    }

    func testScenarioOnce() {
        let expect = expectation(description: "test scenario twice")

        let scenarioCreator = Scenario()
        scenarioCreator.createScenario()
        scenarioCreator.executeScenario()

        delay(20.0) {
            scenarioCreator.createScenario()
            scenarioCreator.executeScenario()

            for event in scenarioCreator.events {
                XCTAssert(event.executed == false)
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 1000)
    }

    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
