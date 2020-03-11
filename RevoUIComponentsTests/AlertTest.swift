import XCTest
@testable import RevoUIComponents

class AlertTest: XCTestCase {

    override func setUp() { }

    override func tearDown() { }

    func test_alert_can_be_faked() {
        Alert.enableFake([1])
        
        Alert(alert: "hola").show(UIViewController()){ result in
            XCTAssertEqual(1, result)
        }
    }

    func test_alert_action_can_be_faked() {
        Alert.enableFake([4])
        
        Alert(action: "hola", actions:["hi", "bye"]).show(UIViewController()){ result in
            XCTAssertEqual(4, result)
        }
    }

}
